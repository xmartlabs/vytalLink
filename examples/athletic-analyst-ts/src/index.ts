import "dotenv/config";
import { stdin as input, stdout as output } from "node:process";
import { McpBridge } from "./mcp-bridge.js";
import { runAgent } from "./agent.js";
import type { AnalysisMode } from "./system-prompt.js";
import type { Message } from "./agent.js";
import { createExecutionTracer } from "./execution-trace.js";
// PromptReader: thin readline wrapper that also handles piped stdin (used by integration tests).
// Python doesn't need this because input() handles piped stdin natively.
import { PromptReader } from "./line-reader.js";
import { emitTestSummary } from "./test-config.js";

const VALID_MODES: AnalysisMode[] = ["readiness", "recovery", "training", "sleep", "chat"];

function parseArgs(): { mode: AnalysisMode; query?: string } {
  const args = process.argv.slice(2);
  let mode: AnalysisMode = "chat";
  let query: string | undefined;

  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--mode" && args[i + 1]) {
      const m = args[i + 1] as AnalysisMode;
      if (VALID_MODES.includes(m)) { mode = m; i++; }
      else { console.error(`Invalid mode: ${m}. Valid: ${VALID_MODES.join(", ")}`); process.exit(1); }
    } else if (args[i] === "--query" && args[i + 1]) {
      query = args[i + 1];
      i++;
    }
  }

  return { mode, query };
}

const ANALYSIS_QUERIES: Record<AnalysisMode, string> = {
  readiness: "Analyze my daily readiness to train today.",
  recovery: "Analyze my recovery trends over the past 28 days.",
  training: "Analyze my training load and injury risk.",
  sleep: "Analyze my sleep quality and patterns over the past 14 days.",
  chat: "",
};

async function promptCredentials(reader: PromptReader): Promise<{ word: string; code: string }> {
  console.log("VytalLink credentials (from the mobile app):");
  const word = await reader.question("  Word: ");
  const code = await reader.question("  PIN:  ");
  console.log();
  return { word, code };
}

function buildQueryWithCredentials(query: string, word: string, code: string): string {
  return `My VytalLink credentials: word="${word}", code="${code}". ${query}`;
}

async function main() {
  const { mode, query: cliQuery } = parseArgs();
  const tracer = createExecutionTracer();
  const reader = new PromptReader(input, output);
  const bridge = new McpBridge(tracer);

  console.log(`\n=== Athletic Performance Analyst ===`);
  console.log(`Mode: ${mode}\n`);

  try {
    const { word, code } = await promptCredentials(reader);
    await bridge.connect();

    if (mode !== "chat") {
      const baseQuery = cliQuery ?? ANALYSIS_QUERIES[mode];
      const query = buildQueryWithCredentials(baseQuery, word, code);
      console.log(`Analyzing... (this may take a moment)\n`);
      const { text } = await runAgent(query, bridge, mode, [], tracer);
      console.log(text);
    } else {
      const history: Message[] = [];

      console.log("Interactive mode. Type your question (or 'exit' to quit).\n");

      // Seed history with a silent login message so the model authenticates on first tool call
      const loginMessage = buildQueryWithCredentials("Please authenticate with VytalLink before answering my questions.", word, code);
      tracer.trace("login_seed_start", { mode });
      const { messages: authMessages } = await runAgent(loginMessage, bridge, mode, history, tracer);
      tracer.trace("login_seed_end", { mode });
      history.splice(0, history.length, ...authMessages);

      while (true) {
        const userInput = await reader.question("You: ");
        tracer.trace("chat_input_received", { characters: userInput.length });
        if (userInput.toLowerCase() === "exit" || userInput.toLowerCase() === "quit") break;
        if (!userInput.trim()) continue;

        console.log("\nAnalyzing...\n");
        const { text, messages } = await runAgent(userInput, bridge, mode, history, tracer);
        history.splice(0, history.length, ...messages);

        console.log(`\nAnalyst: ${text}\n`);
      }
    }
  } finally {
    emitTestSummary(bridge.getExecutionSummary());
    reader.close();
    try {
      await bridge.close();
    } catch (err) {
      console.error("Non-fatal error while closing MCP bridge:", err);
    }
  }
}

main().catch((err) => {
  console.error("Fatal error:", err);
  process.exit(1);
});
