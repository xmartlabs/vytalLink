# MCP Mobile Connection: Android and iOS (current state)

Scope: this document covers the mobile client connection/retry behavior only. Server-side architecture is out of scope.

This document describes how the MCP flow (connection to the server) works on Android and iOS in the current project state.

## Overview
- Transport: WebSocket against `Config.wsUrl` (from env).
- Messaging: JSON (health data requests + connection codes).
- Orchestration: `HealthMcpServerService` coordinates connection, retries, UI state, and dispatch to `HealthDataManager`.

## Android

### Foreground service
- Library: `flutter_foreground_task`.
- Key file: `mobile/lib/core/service/mcp_background_service.dart`.
- Purpose: keep the WebSocket alive when the app is backgrounded and show a persistent notification.

### Connection and retries
- Manager: `HealthMcpConnectionManager`.
- Retries: at most 2 automatic retries, fixed interval capped at 2s.
- Successful connection: considered established only after receiving a backend `ConnectionCode` (not merely opening the socket).
- On failure (timeout or no code): disconnect and stop the service; no infinite retries.

### Idle timeout (auto‑stop)
- If no messages are received from the backend for 15 minutes:
  - The background task closes the connection.
  - The foreground service stops (notification removed).
  - The UI transitions to Idle.

### UI states
- `starting`: user pressed “Connect”; up to 2 retries are in progress.
- `running`: a `ConnectionCode` was received and the session is active.
- `reconnecting`: the session was active and the socket dropped; up to 2 quick retries.
- `error`: retries exhausted or timeout; user must press “Connect” again.
- `idle/stopping`: transient start/stop states.

### Error handling
- Error notifications to the UI are throttled.
- During initial connect failures, show a single error after retries are exhausted and stop the service.

## iOS

### No background WebSocket
- iOS does not keep a persistent WebSocket in background.
- On iOS `McpBackgroundService.isForegroundServiceAvailable == false`, so the app uses a **foreground-only** connection.
- Manager: `HealthMcpConnectionManager` (main process), with the same 2 retries and success criterion (requires `ConnectionCode`).

### UI states
- Same as Android when the app is foregrounded.
- In background the connection is not kept; no automatic reconnection.

### Implications
- To pair or respond on-demand, the app must be in foreground.
- No persistent notification or background task.

## Configuration
- WS URL: `WS_URL` (env), see `mobile/environments/*`.
- Retries: `maxRetries = 2` (manager).
- Backoff: 2s base / 2s max on Android foreground task and fallback.
- Android idle timeout: 15 minutes without backend messages (configured in the foreground task).

## Test scenarios
- Server down at start: “Starting…”, 2 retries, then “Error”; button returns to “Start”.
- Active session drops: “Reconnecting”, 2 retries, then “Error”.
- Android idle 15 min: notification stops and UI goes to Idle.
- iOS: works only in foreground; no background reconnection.

## Next steps (iOS, optional)
- Background wake with silent push + BGTask to perform a short HTTP pull (no persistent WS).
- REST endpoints on the server for queueing requests and delivering results.
