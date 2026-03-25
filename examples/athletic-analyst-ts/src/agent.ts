import Anthropic from "@anthropic-ai/sdk";
import { McpBridge } from "./mcp-bridge.js";
import { buildSystemPrompt, type AnalysisMode } from "./system-prompt.js";
import type { ExecutionTracer } from "./execution-trace.js";
import { TEST_MODE } from "./test-config.js";

const client = new Anthropic();

const MODEL = "claude-sonnet-4-6";
const MAX_STEPS = 15; // max tool-use iterations before giving up

export type Message = Anthropic.Messages.MessageParam;

export async function runAgent(
  query: string,
  bridge: McpBridge,
  mode: AnalysisMode = "chat",
  history: Message[] = [],
  tracer?: ExecutionTracer
): Promise<{ text: string; messages: Message[] }> {
  const tools: Anthropic.Messages.Tool[] = bridge.getMcpTools().map((t) => ({
    name: t.name,
    description: t.description ?? "",
    input_schema: (t.inputSchema ?? { type: "object", properties: {} }) as Anthropic.Messages.Tool["input_schema"],
  }));

  const messages: Message[] = [...history, { role: "user", content: query }];

  for (let step = 0; step < MAX_STEPS; step++) {
    const startedAt = Date.now();
    tracer?.trace("model_request_start", { step: step + 1, mode });
    const response = await client.messages.create({
      model: MODEL,
      max_tokens: TEST_MODE ? 4096 : 8096,
      temperature: TEST_MODE ? 0 : undefined,
      system: buildSystemPrompt(mode),
      tools,
      messages,
    });
    tracer?.trace("model_request_end", {
      step: step + 1,
      mode,
      duration_ms: Date.now() - startedAt,
      stop_reason: response.stop_reason,
    });

    messages.push({ role: "assistant", content: response.content });

    if (response.stop_reason === "end_turn") {
      const text = response.content
        .filter((b): b is Anthropic.Messages.TextBlock => b.type === "text")
        .map((b) => b.text)
        .join("\n");
      tracer?.trace("final_response_ready", {
        step: step + 1,
        mode,
        text_length: text.length,
      });
      return { text, messages };
    }

    if (response.stop_reason === "tool_use") {
      const toolResults: Anthropic.Messages.ToolResultBlockParam[] = [];
      for (const block of response.content) {
        if (block.type !== "tool_use") continue;
        console.error(`[Tool] ${block.name}`);
        const result = await bridge.callTool(block.name, block.input as Record<string, unknown>);
        toolResults.push({
          type: "tool_result",
          tool_use_id: block.id,
          content: result.content,
          is_error: result.isError,
        });
      }
      messages.push({ role: "user", content: toolResults });
    } else {
      bridge.markDegraded();
      const text = response.content
        .filter((b): b is Anthropic.Messages.TextBlock => b.type === "text")
        .map((b) => b.text)
        .join("\n");
      tracer?.trace("final_response_ready", {
        step: step + 1,
        mode,
        text_length: text.length,
        degraded: true,
      });
      return { text, messages };
    }
  }

  bridge.markDegraded();
  tracer?.trace("final_response_ready", {
    mode,
    degraded: true,
    reason: "max_steps_reached",
  });
  return { text: "Max steps reached without a final response.", messages };
}
