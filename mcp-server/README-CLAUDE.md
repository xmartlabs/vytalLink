# vytalLink MCP Claude Desktop Extension

This directory contains the Claude Desktop extension bundle for vytalLink MCP server.

## What is vytalLink?

vytalLink is a comprehensive health and fitness platform that aggregates data from various sources including wearable devices, fitness apps, and health monitoring systems.

## Claude Desktop Installation

### Option A: One-click bundle

1. Download the latest `vytallink.mcpb` bundle from the releases page.
2. Double-click the file or drag it into Claude Desktop Settings > Extensions.
3. Review the permissions and click **Install**. Claude will manage updates automatically.

### Option B: Manual npm configuration

1. Install the server globally:
```bash
npm install -g @xmartlabs/vytallink-mcp-server
```

2. Add to your Claude Desktop configuration (`claude_desktop_config.json`):
```json
{
  "mcpServers": {
    "vytalLink": {
      "command": "npx",
      "args": ["@xmartlabs/vytallink-mcp-server"],
      "env": {
        "VYTALLINK_BASE_URL": "https://vytallink.local.xmartlabs.com"
      }
    }
  }
}
```

## Development

### Building the Claude Desktop Extension

To build the Claude Desktop bundle:

```bash
npm run mcpb:package
```

This creates a `dist/vytallink-mcp-server.mcpb` bundle that can be installed in Claude Desktop.

### Icon Management

To update the extension icon:

```bash
npm run mcpb:update-icon
```

This processes the icon from the mobile app assets and optimizes it for the extension.

### Available Scripts

- `npm start` - Run the MCP server directly
- `npm run mcpb:package` - Build Claude Desktop bundle
- `npm run mcpb:update-icon` - Process and optimize icon
- `npm run mcpb:pack` - Direct mcpb pack command
- `npm run install-global` - Install server globally via npm

### Publishing

For npm publishing, see `PUBLISHING.md` for detailed instructions.

## Files Structure

```
mcp-server/
├── vytalLink_mcp_server.js    # Main MCP server (npm + Claude)
├── package.json               # Dependencies and scripts
├── manifest.json              # Claude Desktop configuration
├── icon.png                   # Extension icon
├── README.md                  # npm documentation
├── README-GENERAL.md          # General project overview
├── README-CLAUDE.md           # This file (Claude Desktop docs)
├── PUBLISHING.md              # Publishing instructions
├── .npmignore                 # Exclude Claude Desktop files from npm
├── scripts/
│   ├── package-extension.js   # Build Claude Desktop bundle
│   └── update-icon.js         # Process extension icon
└── dist/
    └── vytallink-mcp-server.mcpb # Generated bundle
```

## Distribution Channels

### NPM Package
- **Includes**: `vytalLink_mcp_server.js`, `README.md`, `LICENSE`, `package.json`
- **Excludes**: Claude Desktop specific files
- **For**: Developers and manual installations

### Claude Desktop Bundle
- **Includes**: All files + dependencies bundled
- **For**: End users who want one-click installation

## Support

For issues related to:
- **This extension**: Open an issue on the vytalLink repository
- **vytalLink platform**: Contact us at vytalLink@xmartlabs.com
- **Claude Desktop**: Refer to Claude Desktop documentation

---

This extension is part of the vytalLink ecosystem developed by Xmartlabs.
