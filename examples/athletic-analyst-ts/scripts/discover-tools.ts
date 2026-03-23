import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { writeFileSync, mkdirSync } from "node:fs";
import { resolve } from "node:path";
import { fileURLToPath } from "node:url";
import path from "node:path";
import { buildMcpEnvironment } from "../src/mcp-bridge.js";

const __dirname = path.dirname(fileURLToPath(import.meta.url));

console.log("Connecting to Vytallink MCP server (deployed backend)...");

const transport = new StdioClientTransport({
  command: "npx",
  args: ["@xmartlabs/vytallink-mcp-server"],
  env: buildMcpEnvironment(),
});

const client = new Client({ name: "discovery", version: "1.0.0" });

try {
  await client.connect(transport);
  console.log("Connected. Listing tools...");

  const { tools } = await client.listTools();
  console.log(`Found ${tools.length} tools:\n`);
  tools.forEach((t) => console.log(`  - ${t.name}: ${t.description?.slice(0, 80)}...`));

  const docsDir = resolve(__dirname, "../../docs");
  mkdirSync(docsDir, { recursive: true });
  const outputPath = resolve(docsDir, "vytallink-tools.json");
  writeFileSync(outputPath, JSON.stringify(tools, null, 2));
  console.log(`\nSaved to ${outputPath}`);
} finally {
  await client.close();
}
