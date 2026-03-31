# MCP Setup Guide

Connect vytalLink to any MCP client in a few minutes

Claude Desktop

Cursor

VS Code

__ Any MCP Client

## Prerequisites

What you need before setting up MCP

__

### vytalLink Mobile App

Download and set up the vytalLink mobile app to generate your connection Word + PIN.

[ __App Store](https://apps.apple.com/app/id6752308627) [ __Google Play](https://play.google.com/store/apps/details?id=com.xmartlabs.vytallink)

__

### Node.js & npm

Required to install and run the vytalLink MCP server package.

[ __Download Node.js](https://nodejs.org/)

__

### MCP Client

Any MCP-compatible client like Claude Desktop, Cursor, or VS Code with MCP support.

[ Claude Desktop ](https://claude.ai/download)

## Setup Instructions

Choose your MCP client and follow the setup guide

Claude Desktop  Cursor  VS Code  __Other MCP Clients

1

### Install the MCP Server

__ Looking for the one-click experience? Use the [Claude Desktop bundle guide](/claude-bundle-setup.html) instead.

Install the vytalLink MCP server package globally using npm:

Terminal __
    
    
    npm install -g @xmartlabs/vytallink-mcp-server

2

### Configure Claude Desktop

Add vytalLink to your Claude Desktop configuration file:

#### Configuration file location:

macOS Windows Linux

`~/Library/Application Support/Claude/claude_desktop_config.json`

`%APPDATA%\Claude\claude_desktop_config.json`

`~/.config/claude/claude_desktop_config.json`

claude_desktop_config.json __
    
    
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

3

### Restart Claude Desktop

Close and restart Claude Desktop to load the new MCP server configuration.

4

### Connect Your Health Data

Use the Word + PIN from your vytalLink mobile app to authenticate:

**You:** Connect to my health data using Word HEALTH7 and PIN sunset42 

**Claude:** I've successfully connected to your health data! I can now help you analyze your fitness metrics, sleep patterns, and wellness trends. 

1

### Install the MCP Server

Install the vytalLink MCP server package:

Terminal __
    
    
    npm install -g @xmartlabs/vytallink-mcp-server

2

### Configure Cursor

Add vytalLink to your Cursor MCP configuration:

Cursor MCP Configuration __
    
    
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

3

### Enable MCP in Cursor

Make sure MCP is enabled in Cursor settings and restart the application.

__ Check Cursor's documentation for the latest MCP setup instructions

1

### Install MCP Extension

Install an MCP-compatible extension in VS Code (availability may vary).

__ MCP support in VS Code is evolving. Check the VS Code marketplace for MCP extensions.

2

### Install the MCP Server

Terminal __
    
    
    npm install -g @xmartlabs/vytallink-mcp-server

3

### Configure MCP Server

Create or edit the MCP configuration file in your VS Code user directory:

macOS Windows Linux

`~/Library/Application Support/Code/User/mcp.json`

`%APPDATA%\Code\User\mcp.json`

`~/.config/Code/User/mcp.json`

mcp.json __
    
    
    {
      "servers": {
        "vytalLink": {
          "command": "npx",
          "args": ["@xmartlabs/vytallink-mcp-server"]
        }
      }
    }

4

### Restart VS Code

Close and restart VS Code to load the new MCP server configuration.

1

### Install the MCP Server

Terminal __
    
    
    npm install -g @xmartlabs/vytallink-mcp-server

2

### Generic MCP Configuration

Use this configuration template for any MCP-compatible client:

MCP Configuration Template __
    
    
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

3

### Client-Specific Setup

Follow your MCP client's documentation to:

  * Add the server configuration
  * Enable MCP functionality
  * Restart the application



## Troubleshooting

Common issues and solutions

### __MCP server not found

Verify that @xmartlabs/vytallink-mcp-server is installed globally and npx is available in your PATH.

### __Authentication failed

Check that you're using the correct Word + PIN from your vytalLink mobile app. Credentials expire after some time.

### __No health data

Ensure your mobile app has permission to access health data and is actively syncing with your device's health platform.

### Need More Help?

If you're still having issues, check our documentation or reach out for support:

[ __GitHub Repository](https://github.com/xmartlabs/vytalLink) [ __Contact Support](https://xmartlabs.com)