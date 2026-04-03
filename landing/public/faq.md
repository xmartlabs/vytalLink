# Frequently Asked Questions

Answers about setup, privacy, supported platforms, and more

### What does VytalLink do?

VytalLink connects your fitness tracker and health apps to AI assistants like ChatGPT and Claude. You can ask questions about your sleep, workouts, steps, heart rate, and get clear answers.

### Where do I chat?

You chat in ChatGPT on the web or in Claude Desktop on your computer. VytalLink doesn't have its own chat - it just connects your data to your AI assistant.

### Can I use ChatGPT on mobile?

Yes, from the VytalLink app. After connecting, tap "Start Chatting" and it opens the ChatGPT GPT in a built-in browser. That keeps VytalLink running in the foreground so your data keeps flowing. Opening the standalone ChatGPT app instead will break the connection.

### Do I need to keep the app open?

Yes. Keep the VytalLink app open while you chat so it can share your data with your AI assistant. Close the app and your AI can't get new data.

### How do I connect? What are “Word + PIN”?

- Tap “Get Word + PIN” in the app to generate temporary credentials for your current session.
- When ChatGPT or your MCP client asks, paste the Word and PIN to authenticate the bridge.
- These credentials expire; generate new ones anytime.

### Does VytalLink store my health data?

Your phone remains the source of truth. VytalLink is designed to relay only the health data needed for an active session, and not to keep a separate cloud copy of your metrics after that session ends.

### Who receives my data during a session?

You choose who to share your data with during each session. Once shared, the data is subject to the recipient’s policies:

- ChatGPT sessions are subject to OpenAI’s policies and the settings or plan that apply to your account.
- Claude Desktop sessions are subject to Anthropic’s policies.
- For MCP clients (Cursor, VS Code, etc.), data flows to the provider behind that client.

Review the provider’s terms before sharing. VytalLink does not sell or repurpose your health data.

### Which devices and platforms are supported?

- **iOS:** Apple Health (Apple Watch and many third‑party wearables that sync to Health).
- **Android:** Health Connect (support varies by device/app; we’re expanding coverage).

If your wearable syncs to your phone’s health platform, VytalLink can make that data conversational.

### Do I need MCP to get started?

No. The fastest path is ChatGPT (no desktop setup). MCP is available for desktop workflows and power users.

### What kind of questions can I ask?

- “Analyze my sleep last month vs. the previous one. Any recommendations?”
- “How did deep sleep change on strength days vs. cardio?”
- “Chart my heart rate over the last month and highlight trends.”
- “Are my steps up this month, and how did resting HR respond?”

### Why might results vary?

AI answers depend on the model and your prompts. Try concrete time ranges, comparisons, or goals. We recommend verifying any critical insights and consulting professionals for medical decisions.

### How do I revoke access or disconnect?

Stop the connection in the mobile app or simply close the app to pause the bridge. Since credentials expire and the relay is stateless, access ends when the session does. You can generate new credentials at any time.

### Do I need to register to use the app?

No account is required to start using VytalLink. The app is designed to work without a sign-up flow, so you can connect your health data without creating a separate VytalLink account.

### What is MCP?

MCP stands for Model Context Protocol. It’s a standard that allows desktop clients like Claude Desktop, Cursor, or VS Code to interact with your health data securely and efficiently. MCP clients provide advanced workflows for power users.

### Which client should I use?

- **ChatGPT:** Best for quick, conversational insights. No desktop setup required.
- **Claude Desktop:** Ideal for users who prefer Anthropic’s AI and desktop workflows.
- **Other MCP clients:** Use these for specific integrations or advanced setups.

Choose the client that aligns with your workflow and preferences.

### Troubleshooting

- **Authentication failed:** generate a fresh Word + PIN and try again.
- **No data visible:** ensure the app has health permissions and stays open.
- **MCP server not found:** confirm the MCP server/package is installed or the Claude bundle is enabled; restart the client.
- **Connection lost:** check network connectivity and restart the session.

### Disclaimers

VytalLink does not provide medical advice, diagnosis, or treatment. For medical questions, consult a qualified professional.

### What is the difference between ChatGPT and MCP clients?

ChatGPT is ideal for quick, conversational insights without any desktop setup. MCP clients, like Claude Desktop or VS Code, are designed for advanced workflows and professional use cases.

### What happens if I close the app during a session?

If you close the app, the connection to your AI assistant is paused, and no new data will be relayed. To resume, simply reopen the app and restart the session.

### Can I use VytalLink offline?

No, VytalLink requires an active internet connection to securely relay your health data to your AI assistant.

### What data does VytalLink access from my phone?

VytalLink accesses only the health metrics you approve, such as sleep, workouts, steps, and heart rate. You have full control over what data is shared during each session.

### How is my privacy protected?

VytalLink is designed to keep your health data on your phone until you choose to share it with a connected assistant. Only the information needed for the current session is relayed, and you can stop sharing by ending the session or closing the app.

### Why don’t I see all my data, like sleep details?

1. Your wearable might not sync all data to Apple Health (iOS) or Health Connect (Android). Ensure your device is properly connected and syncing.
2. Some wearables only share limited data. For example, they might log a sleep session but not provide detailed sleep stages (like deep or REM sleep).

### Can I use VytalLink with multiple AI clients simultaneously?

Yes, you can connect to multiple AI clients simultaneously. However, we recommend maintaining a single active connection for simplicity and to avoid potential data conflicts.

### What MCP tools does VytalLink expose?

- `direct_login` — authenticates the user with their Word + PIN. No browser, no redirect.
- `get_summary` — returns a snapshot of steps, sleep, heart rate, and more for any date range.
- `get_health_metrics` — queries a specific metric by time range and aggregation (raw, hourly, or daily).

Full parameter reference, schemas, and response types in the [API Reference](https://api.vytallink.xmartlabs.com/docs/mcp).

### How does the user connect to my agent?

The user opens the VytalLink app and taps to get a Word + PIN, then enters those credentials inside your agent. Your agent calls `direct_login` with the Word and PIN to establish the session. The user must keep the VytalLink app open for the connection to stay active.

### What languages and SDKs are supported?

Any language with an MCP client SDK works. The [examples repo](https://github.com/xmartlabs/vytalLink/tree/main/examples) includes TypeScript and Python agents. You can also start from the [Health Kit Template](https://github.com/xmartlabs/vytallink-health-kit), a Python starter with CLI, Jupyter notebooks, and an observability stack.

### Why does my agent stop getting data when the user switches apps?

The VytalLink app must be active in the foreground to stream data. If the user backgrounds or closes the app, the data connection pauses until they return and reopen it. There is no background data mode.

### How should I handle large time ranges?

The OS may throttle or kill long-running calls on large date windows. Break requests into smaller windows (a week at a time works well) and merge the results in your agent.

### Is the API production-ready?

Not yet. The backend works well for prototyping and testing, but it is not hardened for production traffic. Use it at your own risk and expect possible breaking changes.
