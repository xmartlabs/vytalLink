# VytalLink Mobile App – Flutter + MCP

This Flutter app runs on your phone (Android or iOS), reads your health data from Apple HealthKit or Google Health Connect, and shares it with AI tools like Claude, Cursor, and ChatGPT when you ask questions.

## What's inside

- `health` — Reads health data from HealthKit (iOS) or Health Connect (Android)
- Embedded `mcp_server` — Shares your health data with AI tools via HTTP
- `flutter_bloc` + `freezed` — Manages app state and data models
- `auto_route` — Handles navigation between screens
- `network_info_plus` + `wakelock_plus` — Shows your device IP and keeps the screen awake
- Localization via `intl` — Multi-language support
- Local `design_system/` package — Custom UI components and demo app

## How the MCP server works

The main server code is in `lib/core/source/mcp_server.dart` (`HealthMcpServerService`). It starts an HTTP server and provides one tool:

- **Name**: `get_health_data`
- **Input**: `{ type: string, start: ISO8601 string, end: ISO8601 string }`
- **What it does**: Checks permissions, reads your health data, and returns it as JSON.

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

4. **Start the server**
   - On the Home screen tap **Get Word + PIN**. The app shows your connection details.

5. **Connect from your AI tool (example: Cursor)**
   - Add the MCP server URL shown in the app, e.g. `http://192.168.1.10:8080/mcp`
   - Ask questions about your health data - the AI will call `get_health_data` automatically

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

## How it's connected

`HomeCubit` (`lib/ui/home/home_cubit.dart`) handles the server setup (IP, port, endpoint), starts and stops the MCP service, and updates the UI. The API works like this:

- **Input**: `{ type, start, end }`
- **Output**: `{ ok: boolean, data?: any, error?: { message, code? } }`

## App navigation

`auto_route` sets up the Home screen where you can see server status, connection details, and start/stop controls.

## Health data permissions

- **iOS (HealthKit)**: The app will ask for health permissions when you first use it. Say yes to the data types you want to share.
- **Android (Health Connect)**:
  - Install the Health Connect app from Google Play
  - Connect your fitness apps (Fitbit, Google Fit, etc.)
  - Allow this app to read your health data when prompted
  - Make sure your fitness apps are syncing to Health Connect
- **Both platforms**: The app declares what permissions it needs, but you still control what gets approved.

## Firebase configuration

1. Place the binaries into `secrets/`:
   - `google-services.json` for Android.
   - `GoogleService-Info.plist` for iOS (both dev and prod variants).

2. Generate the artifacts:
   ```bash
   ./scripts/build_binaries.sh
   ```

## File structure

- `lib/core/source/mcp_server.dart` — The MCP server that shares your health data
- `lib/ui/home/` — Main screen where you control the server
- `android/app/src/main/AndroidManifest.xml` — App permissions for Android
- `secrets/` — Private config files (not in version control)
- `environments/` — Environment setup templates
- `design_system/` — Custom UI components and demo app
- `scripts/` — Build and setup scripts
- `fastlane/` — App store deployment tools

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
