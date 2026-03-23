import { Client } from "@modelcontextprotocol/sdk/client/index.js";
import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
import { writeFileSync, mkdirSync } from "node:fs";
import { resolve, dirname } from "node:path";
import { tmpdir } from "node:os";
import { buildMcpEnvironment } from "../src/mcp-bridge.js";

function buildOutputPath(): string {
  const customPath = process.env.VYTALLINK_DISCOVERY_OUTPUT;
  if (customPath && customPath.trim().length > 0) {
    return resolve(customPath);
  }

  return resolve(tmpdir(), "vytallink-agent-examples", "vytallink-tools.json");
}

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

  const outputPath = buildOutputPath();
  mkdirSync(dirname(outputPath), { recursive: true });
  writeFileSync(outputPath, JSON.stringify(tools, null, 2));
  console.log(`\nSaved to ${outputPath}`);
} finally {
  await client.close();
}
