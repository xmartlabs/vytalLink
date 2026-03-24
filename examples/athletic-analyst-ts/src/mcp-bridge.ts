import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import type { Tool } from "@modelcontextprotocol/sdk/types.js";
import type { ExecutionTracer } from "./execution-trace.js";

const DATA_TOOL_NAMES = new Set(["get_health_metrics", "get_summary"]);
const AUTH_TOOL_NAMES = new Set(["direct_login", "oauth_login", "oauth_authorize"]);
const CONNECT_RETRIES = 3;
const CONNECT_RETRY_DELAY_MS = 2000;

export type ToolCallResult = {
  content: string;
  isError: boolean;
};

export type ExecutionSummary = {
  tool_calls: number;
  tool_failures: number;
  successful_data_calls: number;
  degraded: boolean;
  auth_ok: boolean;
};

export function buildMcpEnvironment(): Record<string, string> {
  const env = Object.fromEntries(
    Object.entries(process.env).filter((entry): entry is [string, string] => typeof entry[1] === "string")
  );

  const shouldForwardCustomBaseUrl =
    process.env.ATHLETIC_ANALYST_FORWARD_VYTALLINK_BASE_URL === "1";

  if (!shouldForwardCustomBaseUrl) {
    delete env.VYTALLINK_BASE_URL;
  }

  return env;
}

function isRetryableConnectError(error: unknown): boolean {
  const message = error instanceof Error ? error.message : String(error);
  return [
    "Backend server unavailable",
    "ECONNREFUSED",
    "fetch failed",
    "request to ",
  ].some((marker) => message.includes(marker));
}

function structuredSuccess(result: { structuredContent?: unknown }): boolean | undefined {
  const structured = result.structuredContent;
  if (typeof structured === "object" && structured !== null && "success" in structured) {
    return Boolean((structured as { success?: unknown }).success);
  }
  return undefined;
}

export class McpBridge {
  private client: Client;
  private tools: Tool[] = [];
  private executionSummary: ExecutionSummary = {
    tool_calls: 0,
    tool_failures: 0,
    successful_data_calls: 0,
    degraded: false,
    auth_ok: false,
  };

  constructor(private readonly tracer?: ExecutionTracer) {
    this.client = new Client({ name: "athletic-analyst", version: "1.0.0" });
  }

  async connect(): Promise<void> {
    let lastError: unknown;

    for (let attempt = 1; attempt <= CONNECT_RETRIES; attempt++) {
      this.client = new Client({ name: "athletic-analyst", version: "1.0.0" });
      this.tracer?.trace("bridge_connect_start", { attempt });

      const transport = new StdioClientTransport({
        command: "npx",
        args: ["@xmartlabs/vytallink-mcp-server"],
        env: buildMcpEnvironment(),
      });

      try {
        await this.client.connect(transport);
        const { tools } = await this.client.listTools();
        this.tools = tools;
        this.tracer?.trace("bridge_connect_end", { attempt, tools_loaded: tools.length });
        console.error(`[MCP] Connected — ${tools.length} tools loaded`);
        return;
      } catch (error) {
        lastError = error;
        const message = error instanceof Error ? error.message : String(error);
        this.tracer?.trace("bridge_connect_retry", { attempt, error: message });
        await this.client.close().catch(() => undefined);
        if (attempt >= CONNECT_RETRIES || !isRetryableConnectError(error)) {
          throw error;
        }
        console.error(`[MCP] Connection attempt ${attempt} failed: ${message}. Retrying...`);
        await new Promise((resolve) => setTimeout(resolve, CONNECT_RETRY_DELAY_MS));
      }
    }

    throw lastError instanceof Error ? lastError : new Error(String(lastError));
  }

  async close(): Promise<void> {
    await this.client.close();
  }

  getMcpTools(): Tool[] {
    return this.tools;
  }

  getExecutionSummary(): ExecutionSummary {
    return { ...this.executionSummary };
  }

  markDegraded(): void {
    this.executionSummary.degraded = true;
  }

  async callTool(name: string, args: Record<string, unknown>): Promise<ToolCallResult> {
    this.executionSummary.tool_calls += 1;
    const startedAt = Date.now();
    this.tracer?.trace("tool_start", { tool: name });

    try {
      const result = await this.client.callTool({ name, arguments: args });
      const content = result.content as Array<{ type: string; text?: string }>;
      const toolReportedError = Boolean(result.isError);
      const authSuccess = structuredSuccess(result as { structuredContent?: unknown });

      if (!content || content.length === 0) {
        return { content: "No data returned", isError: toolReportedError };
      }

      const renderedContent = content
        .map((block) => {
          if (block.type === "text") return block.text ?? "";
          return JSON.stringify(block);
        })
        .join("\n");

      if (toolReportedError) {
        this.executionSummary.tool_failures += 1;
        this.executionSummary.degraded = true;
      } else if (DATA_TOOL_NAMES.has(name)) {
        this.executionSummary.successful_data_calls += 1;
      }
      if (!toolReportedError && AUTH_TOOL_NAMES.has(name) && (authSuccess === undefined || authSuccess)) {
        this.executionSummary.auth_ok = true;
      }
      this.tracer?.trace("tool_end", {
        tool: name,
        duration_ms: Date.now() - startedAt,
        is_error: toolReportedError,
      });

      return { content: renderedContent, isError: toolReportedError };
    } catch (error) {
      const msg = error instanceof Error ? error.message : String(error);
      this.executionSummary.tool_failures += 1;
      this.executionSummary.degraded = true;
      this.tracer?.trace("tool_end", {
        tool: name,
        duration_ms: Date.now() - startedAt,
        is_error: true,
        error: msg,
      });
      console.error(`[MCP] Tool call failed: ${name} — ${msg}`);
      return { content: `Error calling tool ${name}: ${msg}`, isError: true };
    }
  }
}
