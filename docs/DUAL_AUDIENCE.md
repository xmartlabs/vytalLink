# Dual-Audience Messaging Guide

VytalLink's UI copy speaks to two audiences at once. Every string a user reads should make sense to both.

## The two audiences

### Direct users

People who use vytalLink with ChatGPT, Claude Desktop, Cursor, VS Code, or another MCP client. They chose to install vytalLink because they want to ask an AI about their health data.

**Example:** Maria installs vytalLink, opens Claude Desktop, pastes her Word + PIN, and asks "How did my sleep change this month?"

### Referred users

People who installed vytalLink because another app told them to. A developer built something on top of vytalLink (a sleep trend analyzer, a coaching app, a recovery tracker) and that app needs the user's health data. The user may not know what MCP is and does not care.

**Example:** Juan builds a training trend app. His user, Pedro, sees "Install vytalLink and enter your Word + PIN" inside Juan's app. Pedro installs vytalLink, generates credentials, and goes back to Juan's app.

## Copy rules

### When to name specific apps

Use "ChatGPT" or "Claude" by name when the string is on a screen dedicated to that integration (the ChatGPT setup guide, the Claude Desktop bundle section). These screens only serve direct users.

### When to stay generic

On shared screens (home, onboarding, toasts, server status), use generic language that covers both audiences:

| Instead of | Write |
|------------|-------|
| "Open ChatGPT" | "Open your AI app or the one that sent you here" |
| "Paste into ChatGPT" | "Enter them in your AI app" |
| "Your MCP client" | "Your AI app" or just name the action |
| "Your AI assistant" | "Your AI app" (shorter, less formal) |

When listing apps on shared screens, include the third-party case:
- "ChatGPT, Claude, or the app that sent you here"
- "ChatGPT, Claude, or another app"

### What to avoid

- **Don't assume the user knows what MCP is.** On shared screens, never use "MCP" without context. On the MCP setup page it's fine because that audience self-selected.
- **Don't assume the user has a "personal AI."** Referred users think of vytalLink as a requirement for another app, not as their own AI tool. "Your AI" can confuse them.
- **Don't use promotional language.** "Get insights", "like a pro", "without giving up your privacy" sound like ad copy. State what happens, not how great it is.
- **Don't use em dashes as sentence connectors.** Prefer a period, colon, or comma. Use an em dash only when it genuinely improves flow, and keep usage sparing (see `docs/HUMAN_FIRST_WRITING.md`).

## Where each audience is addressed

| Location | Persists? | Audience coverage |
|----------|-----------|-------------------|
| Home banner (`HomeValuePropHeader`) | Until dismissed | Both: subtitle names ChatGPT/Claude + "an app that sent you here" |
| Onboarding welcome page | One-time | Both: description says "ChatGPT, Claude, or another app" |
| Onboarding bridge page | One-time | Referred users primarily, direct users self-select past it |
| ChatGPT integration screens | Persistent | Direct users only (ChatGPT-specific) |
| MCP setup page | Persistent | Direct users + developers. Includes redirect for referred users |

## Reference

The landing site already follows this pattern:
> "Use it with ChatGPT or Claude for personal health insights, or build it into your own agent so your users can connect their data."

See also: `docs/HUMAN_FIRST_WRITING.md` for tone and style guidelines.
