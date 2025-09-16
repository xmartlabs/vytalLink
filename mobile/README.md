# VytalLink Mobile App – Flutter + MCP

This Flutter app runs entirely on your device (Android or iOS), reads health metrics from Apple HealthKit or Google Health Connect, and exposes them through a local MCP HTTP server so any compatible client (Claude, Cursor, local LLMs, etc.) can query structured data.

## What you get

- `health` — Cross-platform health data access (HealthKit / Health Connect).
- Embedded `mcp_server` — Registers the `get_health_data` tool over HTTP.
- `flutter_bloc` + `freezed` — State and models for the main screen.
- `auto_route` — Simple navigation.
- `network_info_plus` + `wakelock_plus` — Show the device IP and keep the device awake while serving.
- Localization via `intl`.
- Local `design_system/` package — UI components plus the `design_system_gallery/` demo app.

## MCP server flow

The heart of the server lives in `lib/core/source/mcp_server.dart` (`HealthMcpServerService`). It starts an HTTP MCP endpoint and registers one tool:

- **Name**: `get_health_data`
- **Input**: `{ type: string, start: ISO8601 string, end: ISO8601 string }`
- **Behavior**: validates permissions, reads data via the `health` package, returns JSON.

Example payload:
- `type`: `STEPS`
- `start`: `2025-01-01T00:00:00Z`
- `end`: `2025-01-02T00:00:00Z`

## Run the app

1. **Requirements**
   - Flutter 3.32+ (use FVM with the version in `.fvmrc`).
   - A physical device with health data is recommended.
   - Android: install “Health Connect by Android” from the Play Store.

2. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

3. **Launch**
   ```bash
   fvm flutter run
   ```

4. **Start the MCP server**
   - On the Home screen tap **Start**. The app shows the IP, port, and endpoint (e.g. `http://<ip>:<port>/<endpoint>`).

5. **Connect from a client (example: Cursor)**
   - Add an MCP HTTP provider with that URL, e.g. `http://192.168.1.10:8080/mcp`.
   - Call `get_health_data` with parameters like:
     - `type`: `STEPS`
     - `start`: `2025-01-01T00:00:00Z`
     - `end`: `2025-01-02T00:00:00Z`

### Cursor MCP config example

```json
{
  "mcpServers": {
    "MCP Mobile": {
      "type": "streamable-http",
      "url": "http://192.168.1.1:8080/mcp",
      "note": "For streamable HTTP connections, add this URL directly in your MCP client"
    }
  }
}
```

## How it is wired

`HomeCubit` (`lib/ui/home/home_cubit.dart`) builds the configuration (host/IP, port, endpoint), runs `start()`/`stop()` on the MCP service, and exposes state to the UI. Contract summary:

- **Input**: `{ type, start, end }`
- **Output**: `{ ok: boolean, data?: any, error?: { message, code? } }`

## Navigation

`auto_route` defines a Home screen that shows server status, IP/endpoint, and Start/Stop controls.

## Permissions

- **iOS (HealthKit)**: the first read prompts for permissions. Accept the requested types.
- **Android (Health Connect)**:
  - Install the Health Connect app.
  - Link your data sources (Fitbit, Google Fit, etc.).
  - Grant read permissions when prompted by this app.
  - Ensure the sources are syncing data into Health Connect.
- **General**: network and health scopes are declared in the manifests, but the user still needs to approve them at runtime.

## Firebase configuration

1. Place the binaries into `secrets/`:
   - `google-services.json` for Android.
   - `GoogleService-Info.plist` for iOS (both dev and prod variants).

2. Generate the artifacts:
   ```bash
   ./scripts/build_binaries.sh
   ```

## Where things live

- `lib/core/source/mcp_server.dart` — MCP service and tool definition.
- `lib/ui/home/` — Screen that controls the server.
- `android/app/src/main/AndroidManifest.xml` — Permissions (ACCESS_NETWORK_STATE, Health Connect, etc.).
- `secrets/` — Secrets synced outside of version control.
- `environments/` — Versioned environment templates (e.g., `default.env`).
- `design_system/` — UI library plus the `design_system_gallery/` demo.
- `scripts/` — Setup and CI tasks (including the `install/` helpers).
- `fastlane/` — Mobile delivery pipelines.

Made with ❤️ by Xmartlabs.

## Contributing
- Open a pull request for improvements or bug fixes.
- File an issue for feature requests or problems.
- Tell us on X if you enjoy using VytalLink!

## License
```
Copyright (c) 2025 Xmartlabs SRL

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
```
