# MCP Server Scripts

This folder groups utility scripts for packaging and asset generation.

- `package-extension.js`: syncs metadata from `package.json` into `manifest.json`, runs `npx @anthropic-ai/mcpb pack`, and moves the generated `.mcpb` bundle to `dist/vytallink-mcp-server.mcpb`.
- `update-icon.js`: crops and resizes the mobile launcher icon using `sips` so the desktop extension ships a 256x256 `icon.png`.

Both scripts assume they are executed from the `mcp-server` directory.
