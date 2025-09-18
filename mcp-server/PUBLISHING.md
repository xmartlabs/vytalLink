# MCP Server Publishing Guide

We maintain two distribution paths for the MCP server:
- **npm package** (`@xmartlabs/vytallink-mcp-server`): public release for any client consuming the Node package.
- **Claude Desktop bundle** (`mcp-server.mcpb`): packaged artifact specifically for Claude Desktop.

Use the flow that matches your target, or run both when shipping a coordinated release.

## Shared Prerequisites
- Member of the `@xmartlabs` npm org with publish rights and 2FA enabled.
- Logged in via `npm whoami` (run `npm login` with an OTP if the session expired).
- Local environment on Node.js 18+ (matches production target) and a clean `main` branch.
- Access to a staging backend URL for a quick smoke test (set `VYTALLINK_BASE_URL`).

## npm Release Steps (general clients)
1. Sync the repo:
   ```bash
   git checkout main && git pull
   cd mcp-server
   ```
2. Install dependencies and run a lightweight smoke test (point to staging if needed):
   ```bash
   npm install
   VYTALLINK_BASE_URL=<backend-url> npm start # optional smoke test
   ```
   Stop the process after it confirms startup.
3. Decide the semantic bump (patch/minor/major) and update the version without auto-tagging:
   ```bash
   npm version <patch|minor|major> --no-git-tag-version
   ```
   Verify only `package.json` changed.
4. Inspect the npm publish payload:
   ```bash
   npm pack --dry-run
   ```
   Ensure only `vytalLink_mcp_server.js`, `README.md`, `LICENSE`, and `package.json` are included.
5. Publish to npm (fails if the version already exists or you are not authenticated):
   ```bash
   npm publish --access public
   ```
   Enter the OTP when prompted.
6. Confirm availability and copy the tarball URL for release notes:
   ```bash
   npm view @xmartlabs/vytallink-mcp-server version
   ```
7. Commit, tag, and push the release metadata:
   ```bash
   git commit -am "chore(mcp-server): release v<version>"
   git tag mcp-server-v<version>
   git push origin main --tags
   ```
8. Share the release (Slack, changelog, or GitHub release) and update any documentation that references the new version.

## Claude Desktop Bundle Steps (`.mcpb`)
1. Ensure you are on the desired commit (usually after completing the npm release steps) and dependencies are installed:
   ```bash
   git checkout main
   cd mcp-server
   npm install
   ```
2. Build the Claude Desktop bundle:
   ```bash
   npm run mcpb:package
   ```
   This generates `mcp-server.mcpb` in the repository root.
3. Verify the bundle contents when needed:
   ```bash
   unzip -l ../mcp-server.mcpb | head
   ```
   Confirm the manifest and server assets are present.
4. Distribute the `.mcpb` file alongside release notes or through the appropriate internal channel for Claude Desktop users.

## Troubleshooting
- **401 Unauthorized**: run `npm logout`, then `npm login` with valid org credentials and OTP.
- **Version already published**: revert the version bump, choose a higher semver, and repeat step 3.
- **Missing files**: adjust the `files` array in `package.json`, rerun `npm pack --dry-run`, and publish again.
