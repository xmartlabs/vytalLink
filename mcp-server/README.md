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

## Supported MCP Clients

This server works with any MCP-compatible client, including:

- **Claude Desktop** - AI assistant with health data context
- **VS Code** - Integrate health data into your development workflow
- **Custom MCP clients** - Build your own applications using the MCP protocol

## Installation

### For Claude Desktop

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
    }
  }
}
```

3. Restart Claude Desktop

### For VS Code

1. Install a compatible MCP extension
2. Configure the server in your MCP settings
3. Use the same npx command: `@xmartlabs/vytallink-mcp-server`

## Available Tools

Once connected, you'll have access to tools for:

- Retrieving health metrics (heart rate, steps, calories, etc.)
- Accessing workout and exercise data
- Monitoring sleep sessions
- Getting user profile information
- Managing OAuth authentication

## Requirements

- Node.js 16+ 
- vytalLink mobile app (for initial authentication)

# MCP Server

The MCP server connects to our backend to handle requests and business logic. All authentication is exclusively managed through our mobile applications.

For more information, visit [vytallink.xmartlabs.com](https://vytallink.xmartlabs.com/).

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
