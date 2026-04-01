# MCP Setup Guide

Connect vytalLink to any MCP client in a few minutes

Supported clients: Claude Desktop, Cursor, VS Code, and other MCP-compatible clients.

## Prerequisites

What you need before setting up MCP

### vytalLink Mobile App

Download and set up the vytalLink mobile app to generate your connection Word + PIN.

- [App Store](https://apps.apple.com/app/id6752308627)
- [Google Play](https://play.google.com/store/apps/details?id=com.xmartlabs.vytallink)

### Node.js & npm

Required to install and run the vytalLink MCP server package.

- [Download Node.js](https://nodejs.org/)

### MCP Client

Any MCP-compatible client like Claude Desktop, Cursor, or VS Code with MCP support.

- [Claude Desktop](https://claude.ai/download)

## Setup Instructions

Choose your MCP client and follow the setup guide

## Claude Desktop

### Step 1: Install the MCP Server

> Looking for the one-click experience? Use the [Claude Desktop bundle guide](/claude-bundle-setup.html) instead.

Install the vytalLink MCP server package globally using npm:

#### Terminal

```
npm install -g @xmartlabs/vytallink-mcp-server
```

### Step 2: Configure Claude Desktop

Add vytalLink to your Claude Desktop configuration file:

#### Configuration File Locations

- **macOS:** `~/Library/Application Support/Claude/claude_desktop_config.json`
- **Windows:** `%APPDATA%\Claude\claude_desktop_config.json`
- **Linux:** `~/.config/claude/claude_desktop_config.json`

#### claude_desktop_config.json

```json
{
  "mcpServers": {
    "vytalLink": {
      "command": "npx",
      "args": [
        "@xmartlabs/vytallink-mcp-server"
      ]
    }
  }
}
```

### Step 3: Restart Claude Desktop

Close and restart Claude Desktop to load the new MCP server configuration.

### Step 4: Connect Your Health Data

Use the Word + PIN from your vytalLink mobile app to authenticate:

#### Example Conversation
- **You:** Connect to my health data using Word HEALTH7 and PIN sunset42
- **Claude:** I've successfully connected to your health data! I can now help you analyze your fitness metrics, sleep patterns, and wellness trends.

## Cursor

### Step 1: Install the MCP Server

Install the vytalLink MCP server package:

#### Terminal

```
npm install -g @xmartlabs/vytallink-mcp-server
```

### Step 2: Configure Cursor

Add vytalLink to your Cursor MCP configuration:

#### Cursor MCP Configuration

```json
{
  "mcpServers": {
    "vytalLink": {
      "command": "npx",
      "args": [
        "@xmartlabs/vytallink-mcp-server"
      ]
    }
  }
}
```

### Step 3: Enable MCP in Cursor

Make sure MCP is enabled in Cursor settings and restart the application.

> Check Cursor's documentation for the latest MCP setup instructions

## VS Code

### Step 1: Install MCP Extension

Install an MCP-compatible extension in VS Code (availability may vary).

> MCP support in VS Code is evolving. Check the VS Code marketplace for MCP extensions.

### Step 2: Install the MCP Server

#### Terminal

```
npm install -g @xmartlabs/vytallink-mcp-server
```

### Step 3: Configure MCP Server

Create or edit the MCP configuration file in your VS Code user directory:

#### Configuration File Locations

- **macOS:** `~/Library/Application Support/Code/User/mcp.json`
- **Windows:** `%APPDATA%\Code\User\mcp.json`
- **Linux:** `~/.config/Code/User/mcp.json`

#### mcp.json

```json
{
  "servers": {
    "vytalLink": {
      "command": "npx",
      "args": ["@xmartlabs/vytallink-mcp-server"]
    }
  }
}
```

### Step 4: Restart VS Code

Close and restart VS Code to load the new MCP server configuration.

## Other MCP Clients

### Step 1: Install the MCP Server

#### Terminal

```
npm install -g @xmartlabs/vytallink-mcp-server
```

### Step 2: Generic MCP Configuration

Use this configuration template for any MCP-compatible client:

#### MCP Configuration Template

```json
{
  "mcpServers": {
    "vytalLink": {
      "command": "npx",
      "args": [
        "@xmartlabs/vytallink-mcp-server"
      ]
    }
  }
}
```

### Step 3: Client-Specific Setup

Follow your MCP client's documentation to:

- Add the server configuration
- Enable MCP functionality
- Restart the application

## Troubleshooting

Common issues and solutions

### MCP server not found

Verify that @xmartlabs/vytallink-mcp-server is installed globally and npx is available in your PATH.

### Authentication failed

Check that you're using the correct Word + PIN from your vytalLink mobile app. Credentials expire after some time.

### No health data

Ensure your mobile app has permission to access health data and is actively syncing with your device's health platform.

## Need More Help?

If you're still having issues, check our documentation or reach out for support:

- [GitHub Repository](https://github.com/xmartlabs/vytalLink)
- [Contact Support](https://xmartlabs.com)
