# VytalLink — Frequently Asked Questions (FAQ)

This document consolidates common questions for users and reviewers. It’s the single source of truth for messaging we’ll surface across the landing site and the mobile app.

## What does VytalLink do?
VytalLink turns your wearable and phone‑tracked health metrics (sleep, workouts, steps, heart rate, and more) into a secure, AI‑ready stream so you can ask questions and get clear recommendations from ChatGPT or other MCP clients.

## Where do I chat?
Chats happen in ChatGPT. You can use the in-app browser or hop to the web, and power users can still lean on MCP clients like Claude Desktop. VytalLink doesn't include a native chat UI yet.

## Can I use ChatGPT on mobile?
Yes. VytalLink opens ChatGPT in a secure in-app browser. Keep the app in the foreground so the bridge keeps streaming.

## Do I need to keep the app open?
Yes. While you chat, keep the VytalLink app open so it can relay the data you approved to your AI assistant. Closing the app pauses the bridge and stops new insights.

## How do I connect? What are “Word + PIN”?
- Tap “Get Word + PIN” in the app to generate temporary credentials for your current session.
- When ChatGPT or your MCP client asks, paste the Word and PIN to authenticate the bridge.
- These credentials expire; generate new ones anytime.

## Does VytalLink store my health data?
No. Your phone is the source of truth. The relay is stateless and does not persist health data. Only the specific fields you approve per connection are streamed to your chosen AI provider.

## Who receives my data during a session?
- You choose who to share your data with during each session. Once shared, the data is subject to the recipient’s policies:
  - ChatGPT sessions are subject to OpenAI’s policies. Note: Our GPT integration is configured to not use your data for training.
  - Claude Desktop sessions are subject to Anthropic’s policies.
  - For MCP clients (Cursor, VS Code, etc.), data flows to the provider behind that client.
Review the provider’s terms before sharing. VytalLink does not sell or repurpose your health data.

## Which devices and platforms are supported?
- iOS: Apple Health (Apple Watch and many third‑party wearables that sync to Health).
- Android: Health Connect (support varies by device/app; we’re expanding coverage).
If your wearable syncs to your phone’s health platform, VytalLink can make that data conversational.

## Do I need MCP to get started?
No. The fastest path is ChatGPT, whether you're on your phone or a computer. MCP stays available for deeper workflows and power users.

## What kind of questions can I ask?
Examples:
- “Analyze my sleep last month vs. the previous one. Any recommendations?”
- “How did deep sleep change on strength days vs. cardio?”
- “Chart my heart rate over the last month and highlight trends.”
- “Are my steps up this month, and how did resting HR respond?”

## Why might results vary?
AI answers depend on the model and your prompts. Try concrete time ranges, comparisons, or goals. We recommend verifying any critical insights and consulting professionals for medical decisions.

## How do I revoke access or disconnect?
Stop the connection in the mobile app or simply close the app to pause the bridge. Since credentials expire and the relay is stateless, access ends when the session does. You can generate new credentials at any time.

## Do I need to register to use the app?
No. VytalLink is completely anonymous and does not store any user data. You can use the app without creating an account.

## What is MCP?
MCP stands for Model Context Protocol. It’s a standard that allows desktop clients like Claude Desktop, Cursor, or VS Code to interact with your health data securely and efficiently. MCP clients provide advanced workflows for power users.

## Which client should I use?
It depends on your needs:
- **ChatGPT**: Best for quick, conversational insights on your phone or computer.
- **Claude Desktop**: Ideal for users who prefer Anthropic’s AI and desktop workflows.
- **Other MCP clients**: Use these for specific integrations or advanced setups.
Choose the client that aligns with your workflow and preferences.

## Troubleshooting
- Authentication failed: generate a fresh Word + PIN and try again.
- No data visible: ensure the app has health permissions and stays open.
- MCP server not found: confirm the MCP server/package is installed or the Claude bundle is enabled; restart the client.
- Connection lost: check network connectivity and restart the session.

## Disclaimers
VytalLink does not provide medical advice, diagnosis, or treatment. For medical questions, consult a qualified professional.

## What is the difference between ChatGPT and MCP clients?
ChatGPT is ideal for quick, conversational insights on any screen. MCP clients, like Claude Desktop or VS Code, are built for advanced workflows and professional use cases.

## What happens if I close the app during a session?
If you close the app, the connection to your AI assistant is paused, and no new data will be relayed. To resume, simply reopen the app and restart the session.

## Can I use VytalLink offline?
No, VytalLink requires an active internet connection to securely relay your health data to your AI assistant.

## What data does VytalLink access from my phone?
VytalLink accesses only the health metrics you approve, such as sleep, workouts, steps, and heart rate. You have full control over what data is shared during each session.

## How is my privacy protected?
Your privacy is our priority. VytalLink uses encryption to secure your data and operates as a stateless relay, meaning no data is stored. You control what is shared and can disconnect at any time.

## Why don’t I see all my data, like sleep details?
There are two common reasons:
1. Your wearable might not sync all data to Apple Health (iOS) or Health Connect (Android). Ensure your device is properly connected and syncing.
2. Some wearables only share limited data. For example, they might log a sleep session but not provide detailed sleep stages (like deep or REM sleep).

## Can I use VytalLink with multiple AI clients simultaneously?
Yes, you can connect to multiple AI clients simultaneously. However, we recommend maintaining a single active connection for simplicity and to avoid potential data conflicts.
