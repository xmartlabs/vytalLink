# VytalLink Monorepo

VytalLink brings your personal health metrics to life by collecting Apple HealthKit or Google Health Connect data and exposing it through an MCP-compatible interface, so any AI assistant can query it securely from your own device. Learn more at [vytallink.xmartlabs.com](https://vytallink.xmartlabs.com/).

This monorepo hosts every piece of the product experience:

- **[mobile/](mobile/)** — Flutter application that runs on device and exposes the embedded MCP server.
- **[landing/](landing/)** — Static marketing site deployed to Firebase Hosting.
- **[mcp-server/](mcp-server/)** — Standalone MCP server (Node.js) intended to run outside the mobile app.
- **[docs/](docs/)** — Shared documentation (coding standards, contribution guides, etc.).

Each folder contains its own README with the detailed setup. This document only summarizes the repository layout.

## Global prerequisites

- Flutter + FVM (see `.fvmrc`).
- Node.js with your preferred package manager (npm, pnpm) for the web/Node portions.
- Firebase CLI if you plan to deploy the landing or use hosting commands.

## Documentation

- Coding standards: [`docs/CODE_STANDARDS.md`](docs/CODE_STANDARDS.md).
- Add any new repository-wide guides under [`docs/`](docs/).

## Contributing

1. Create a descriptive branch.
2. Run the checks for every package/app you touched.
3. Open a pull request referencing the relevant issues or tickets.

## License

MIT License. See individual project READMEs for any additional notes.

Made with ❤️ by [Xmartlabs](https://xmartlabs.com/).
