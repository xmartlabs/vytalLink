# Plugin Install + Connect Contract

This document defines the VytalLink-owned web contract for installed-plugin or installed-app flows that eventually connect back to the mobile app and preserve the manual Word + PIN fallback.

## Audience

- Landing pages that need a stable VytalLink install surface
- Client developers wiring ChatGPT-style install prompts
- Mobile UI surfaces that need a single source of truth for install and callback URLs

## Hosted URLs

### Install URL

Use this as the user-facing entry point when a client supports an install prompt:

```text
https://vytallink.xmartlabs.com/install/chatgpt
```

Purpose:

- Explains the install flow
- Opens the ChatGPT destination from a VytalLink-owned page
- Keeps the Word + PIN fallback visible in the same flow

Optional query params:

- `manifest`: absolute manifest URL when the launcher wants to skip path-based inference
- `source`: where the install flow was launched from, for example `mobile_app`

### Callback URL

Use this as the stable return URL after the install or connect attempt:

```text
https://vytallink.xmartlabs.com/connect/chatgpt/callback
```

Purpose:

- Confirms the round-trip completed
- Gives the user a stable VytalLink-owned endpoint before fallback
- Reminds the user that Word + PIN still works if ChatGPT requests manual auth

Accepted query params:

- `state`: opaque client state returned after install or auth
- `install_id`: provider-specific install identifier when available

Current behavior:

- The landing surface reads and displays known params
- The mobile app UI uses the same callback URL contract
- The mobile app installs or refreshes the local plugin entry when an install or connect callback returns with a resolvable manifest

## Manifest Shape

Example minimal manifest-like payload for clients that want to store the VytalLink install metadata:

```json
{
  "plugin_id": "chatgpt",
  "name": "ChatGPT",
  "description": "Hosted ChatGPT install and connect flow for vytalLink with Word + PIN fallback.",
  "icon_url": "https://vytallink.xmartlabs.com/favicon.svg",
  "entry_url": "https://chatgpt.com/g/g-68c2fb58447c8191b5af624f6b33bdd6-vytallink",
  "allowed_return_origins": [
    "https://vytallink.xmartlabs.com",
    "vytallink://connect/chatgpt/callback"
  ],
  "manifest_version": "1.0.0",
  "supports_connect_flow": true,
  "supports_word_pin_fallback": true
}
```

Notes:

- `plugin_id` is the stable local registry key used inside the app
- `entry_url` is what the app reopens after the plugin has been installed once
- `allowed_return_origins` should list every origin or custom-scheme callback that may return control to VytalLink

## App-link Association Files

The landing site publishes:

- `/.well-known/apple-app-site-association`
- `/.well-known/assetlinks.json`

These files currently target the production app identifiers:

- iOS bundle ID: `com.xmartlabs.vytallink`
- Android package: `com.xmartlabs.vytallink`

Covered path families:

- `/install/*`
- `/connect/*`

## Mobile UX Expectations

The mobile app should:

- Prefer the hosted install-link flow for ChatGPT installs
- Prepare Word + PIN before launching that flow
- Preserve the classic Word + PIN path for ChatGPT web, Claude Desktop, and other MCP clients
- Avoid heavyweight confirmation screens for the hosted install flow

## Non-goals in This Subtask

- Provider-specific server-side callback validation
- A marketplace or plugin discovery surface beyond the owned ChatGPT handoff
