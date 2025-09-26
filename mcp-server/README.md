# @xmartlabs/vytallink-mcp-server

A Model Context Protocol (MCP) server that provides access to vytalLink health and fitness data.

## What is vytalLink?

vytalLink is a comprehensive health and fitness platform that aggregates data from various sources including wearable devices, fitness apps, and health monitoring systems. It provides a unified API to access your health metrics, workout data, sleep patterns, and more.

## About this MCP Server

This server enables you to interact with vytalLink's functionality through any MCP-compatible client. It acts as a bridge between MCP clients and the vytalLink backend API, allowing you to:

- 🏃‍♂️ Access your fitness and health metrics
- 📊 Retrieve workout data and exercise history
- 😴 Monitor sleep patterns and quality
- ❤️ Track heart rate and vital signs
- 📈 Analyze health trends over time

## Installation

Install the server globally via npm:

```bash
npm install -g @xmartlabs/vytallink-mcp-server
```

## Usage

MCP clients launch the server automatically. Point your client at `npx @xmartlabs/vytallink-mcp-server` (or the globally installed binary) and provide any required environment variables.

### Configuration

The server accepts the following environment variables:

- `VYTALLINK_BASE_URL` - Base URL for the vytalLink API (defaults to production)

For manual smoke testing you can still run:
```bash
VYTALLINK_BASE_URL=https://api.vytallink.com npx @xmartlabs/vytallink-mcp-server
```

### MCP Client Configuration

#### Claude Desktop

**Option A: One-click bundle (Recommended)**

1. Download the latest `vytallink-mcp-server.mcpb` bundle from the releases page
2. Double-click the file or drag it into Claude Desktop Settings > Extensions
3. Review the permissions and click **Install**

**Option B: Manual npm configuration**

Add to your Claude Desktop configuration (`claude_desktop_config.json`):

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

#### Other MCP Clients

This server implements the standard MCP protocol and works with any compatible client. Refer to your client's documentation for configuration details.

## Authentication

Authentication is handled through the vytalLink mobile app. You'll need to:

1. Install the vytalLink mobile app
2. Complete the onboarding process
3. Use the authentication tools provided by this MCP server

The server provides OAuth and direct login capabilities through the vytalLink platform.

## Available Tools

The server dynamically loads tools from the vytalLink backend, ensuring you always have access to the latest functionality. Tools may include:

- Health data retrieval
- Workout analysis
- Sleep tracking
- Vital signs monitoring
- Authentication management

## Requirements

- Node.js 16.0.0 or higher
- vytalLink mobile app for authentication
- Internet connection for API access

## MCP Server

The MCP server connects to our backend to handle requests and business logic. All authentication is exclusively managed through our mobile applications.

For more information, visit [vytallink.xmartlabs.com](https://vytallink.xmartlabs.com/).

## Development

### Building Claude Desktop Bundle

To build the Claude Desktop bundle:

```bash
npm run mcpb:package
```

This creates a `dist/vytallink-mcp-server.mcpb` bundle that can be installed in Claude Desktop.

### Available Scripts

- `npm start` - Run the MCP server directly
- `npm run install-global` - Install server globally via npm
- `npm run uninstall-global` - Uninstall server globally via npm
- `npm run mcpb:package` - Build Claude Desktop bundle
- `npm run mcpb:update-icon` - Process and optimize icon

## Support

For issues related to:
- **This MCP server**: Open an issue on the vytalLink repository
- **vytalLink platform**: Contact us at vytalLink@xmartlabs.com
- **MCP protocol**: Refer to the Model Context Protocol documentation

## License

MIT License

Copyright (c) 2025 Xmartlabs

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

---

This MCP server is part of the vytalLink ecosystem developed by Xmartlabs.
