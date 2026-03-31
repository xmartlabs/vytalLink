# Claude Desktop Bundle Setup

Install vytalLink in Claude Desktop with one double-click

__ Claude Desktop

__ One-click Install

__ Secure Auth

## Prerequisites

What you need before installing the bundle

__

### vytalLink Mobile App

Use the mobile app to get your connection Word + PIN for Claude Desktop.

[ __App Store](https://apps.apple.com/app/vytallink) [ __Google Play](https://play.google.com/store/apps/details?id=com.vytallink)

### Claude Desktop

Download Claude Desktop and sign in with your Anthropic account.

[ __Download Claude](https://claude.ai/download)

__

### vytalLink Bundle

Download the latest `.mcpb` file from GitHub. It's signed and ready to install.

[ __Download Bundle](https://firebasestorage.googleapis.com/v0/b/vytallink.firebasestorage.app/o/releases%2FVytalLink%20MCP%20Server.mcpb?alt=media) [ __Release Notes](https://github.com/xmartlabs/vytalLink/releases/latest)

## Setup Instructions

Follow these steps to add vytalLink to Claude Desktop

1

### Update and open Claude Desktop

Launch [Claude Desktop](https://claude.ai/download) (install it if you haven't yet) and check for updates via **Settings → About → Check for updates**. Leave the app running; the bundle install requires Claude to be open. 

2

### Download the bundle

Click the download button and save `vytallink-mcp-server.mcpb` somewhere easy to find, like your Downloads folder.

[ __Download Bundle](https://firebasestorage.googleapis.com/v0/b/vytallink.firebasestorage.app/o/releases%2FVytalLink%20MCP%20Server.mcpb?alt=media)

3

### Install inside Claude Desktop

Double-click the bundle (or drag it into **Claude Desktop → Settings → Extensions**). Claude will show the vytalLink MCP extension details—click **Install** to confirm.

__ If the bundle doesn't open automatically, right-click the file and choose **Open With → Claude Desktop**.

4

### Restart Claude Desktop

Once the installation finishes, quit and relaunch Claude Desktop so the extension loads correctly.

5

### Authenticate with Word + PIN

Use the vytalLink mobile app to generate a connection Word and PIN. Ask Claude to connect using those credentials to start syncing your health data. Keep the app open while you chat.

**You:** Connect to vytalLink using Word HEALTH7 and PIN sunset42 

**Claude:** Connection complete! You can now explore your health metrics, workouts, and sleep trends. 

__

Need the manual npm workflow or support for other MCP clients? Visit the [advanced MCP setup guide](/mcp-setup.html) for step-by-step instructions.

## Troubleshooting

Common issues and quick fixes

### __Bundle won't open

Right-click the file and choose **Open With → Claude Desktop**. On macOS you may need to approve the download in System Settings.

### __Extension missing after install

Restart Claude Desktop. If it still doesn't appear, reinstall the bundle and check that you're running Claude Desktop version 0.13.0 or newer.

### __Authentication issues

Generate a fresh Word + PIN from the mobile app and try again. Credentials expire shortly after being issued.