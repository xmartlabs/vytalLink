# Installed plugins v1

## What this is

Installed plugins v1 turns VytalLink into the place where a user starts the connection, even when the final conversation happens somewhere else.

The immediate use case is ChatGPT on mobile. Until now, the user had to keep VytalLink in the foreground while also trying to open the AI client. That created a clumsy flow and, in some cases, made the "same device" path feel unreliable.

This v1 changes that. Instead of asking the user to jump between apps and improvise the handoff, VytalLink can open a hosted install flow, keep the Word + PIN fallback ready, and recognize the plugin when the user comes back through a VytalLink-owned callback.

## The problem we are solving

The core bridge constraint has not changed: VytalLink still needs to stay alive while health data is being shared.

What was broken was the user experience around that constraint. If the user created or opened an agent on the phone, they often had to choose between:

- staying in VytalLink so the bridge kept working
- switching to the AI client so they could actually use the agent

That tradeoff is exactly what this feature is trying to soften.

## The goal of v1

The goal is not to build a full plugin platform yet.

The goal is much smaller and more practical:

- give VytalLink a first-party install surface
- make the same-device ChatGPT flow easier to start
- keep Word + PIN as a reliable fallback
- store lightweight plugin metadata locally so the app can reopen a known plugin later

If this version feels boring, that is fine. It is supposed to be boring. The point is to make the handoff predictable.

## What is in scope

- A local plugin registry in the mobile app
- A minimal manifest format for installed plugins
- VytalLink-owned install and callback URLs
- Deep link handling for install/connect returns
- A hosted ChatGPT install flow
- Word + PIN fallback when install-style flows are unavailable or incomplete

## What is not in scope

- A marketplace
- Plugin search or discovery
- Per-plugin permissions beyond the existing session-level sharing model
- Server-side validation of provider-specific install callbacks
- A new transport model for the health-data bridge

## How the flow works

### 1. VytalLink prepares the session

The user starts from VytalLink and gets a valid Word + PIN session, just like today.

### 2. VytalLink opens the install flow

If the user chooses the installed-plugin path, the app opens a VytalLink-owned install URL in the same browser-view runtime already used for ChatGPT.

That matters because we are not introducing a second launch system just for plugins. The feature rides on top of the path we already trust.

### 3. The install flow points to the AI client

The landing page explains what is happening, sends the user into ChatGPT, and keeps the fallback path visible. If ChatGPT supports an install or connect prompt, great. If not, the user can still continue with Word + PIN.

### 4. VytalLink receives the callback

When the user returns through a VytalLink-owned callback URL, the app parses the deep link, resolves the manifest, and stores or refreshes the plugin metadata locally.

### 5. Future launches can skip the install page

Once the plugin is known locally, VytalLink can reopen the plugin's `entry_url` directly instead of always sending the user through the install handoff first.

## Why the manifest exists

The manifest is the smallest stable contract that lets the app remember what it installed.

It answers a few simple questions:

- Which plugin is this?
- What URL should be opened next time?
- Which callback origins are expected?
- Does this plugin support connect-style flows?
- Should the app keep Word + PIN available as fallback?

We are intentionally keeping that shape small. V1 needs enough structure to be useful, not enough structure to become a platform project on its own.

## Why we still keep Word + PIN

Because the install flow is not guaranteed.

Even if the hosted flow works perfectly on our side, the user may still hit:

- a client that does not support installed apps yet
- a partial rollout
- a provider UX that falls back to manual authentication

If Word + PIN disappears too early, the product becomes fragile. Keeping it available is what makes this version safe to ship.

## Current product shape

Right now, ChatGPT is the first installed-plugin surface. That is deliberate.

We are using one concrete path to prove a broader pattern:

- VytalLink owns the handoff
- the app can remember installed plugins locally
- the user can recover when the "smart" flow falls back to the old one

If this pattern holds up, we can extend it later to more agents and more clients.

## Related documents

- [Plugin install + connect contract](./PLUGIN_INSTALL_CONNECT_CONTRACT.md)
- [Installed plugins v1 design plan](./plans/2026-03-30-vytallink-plugins-design.md)
