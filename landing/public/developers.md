# Build a Health Data Agent in 5 Minutes

Developers integrate the VytalLink MCP once. End users connect through the VytalLink app with Word + PIN, then use your agent to read wearable data.

Why VytalLink

__

### Zero Mobile Dev

No custom app, no HealthKit entitlements, no platform accounts. Just install VytalLink and connect.

__

### All Major Wearables

Apple Health (iOS) and Health Connect (Android) cover most devices that sync to the phone.

__

### Real-Time Streaming

Live metrics while the VytalLink app is active. No polling, no delay.

__

### Privacy by Design

Health data never leaves the device. No cloud copy, nothing stored server-side.

## Get Started in a Few Simple Steps

See the full connection flow first, then wire the MCP tools below.

How it works

  1. Developer integrates the VytalLink MCP once
  2. User gets Word + PIN in VytalLink
  3. User connects the developer's agent with Word + PIN
  4. Agent queries health data through VytalLink



__Developer's agent __VytalLink app __User __Gets Word + PIN here __Asks the agent questions

1

### Integrate the VytalLink server

Start with the minimal setup below, or browse the [examples repo](https://github.com/xmartlabs/vytalLink/tree/main/examples) for complete TypeScript and Python agents.

__

**Recommended: Health Kit Template**

The fastest path to a solid foundation. Ships with a working agent setup, CLI, Jupyter notebooks, readiness reporting, and built-in observability. Ready for production from day one.

[ View on GitHub __](https://github.com/xmartlabs/vytallink-health-kit)

agent.ts agent.py

__
    
    
    import { Client } from "@modelcontextprotocol/sdk/client/index.js";
    import { StdioClientTransport } from "@modelcontextprotocol/sdk/client/stdio.js";
    
    // 1. Create client and transport
    const client = new Client({ name: "my-agent", version: "1.0.0" });
    const transport = new StdioClientTransport({
      command: "npx",
      args: ["@xmartlabs/vytallink-mcp-server"],
    });
    
    // 2. Connect and discover tools
    await client.connect(transport);
    const { tools } = await client.listTools();
    console.log(`Connected: ${tools.length} tools available`);

agent.ts agent.py

__
    
    
    from mcp import ClientSession, StdioServerParameters
    from mcp.client.stdio import stdio_client
    
    # 1. Connect to VytalLink MCP server
    server_params = StdioServerParameters(
        command="npx",
        args=["@xmartlabs/vytallink-mcp-server"],
    )
    
    async with stdio_client(server_params) as (read, write):
        async with ClientSession(read, write) as session:
            await session.initialize()

2

### Link the user

Send your users the VytalLink app link. The user first opens VytalLink, gets a **Word + PIN** , then goes into your agent and uses those credentials there while VytalLink stays open as the bridge.

__Share this link with your users [ __Download App](https://vytallink.xmartlabs.com/app)

`https://vytallink.xmartlabs.com/app` __Copy

Your agent calls `direct_login` with the user's Word and PIN:

agent.ts agent.py

__
    
    
    await client.callTool({
      name: "direct_login",
      arguments: { word: "island", code: "828930" },
    });

agent.ts agent.py

__
    
    
    await session.call_tool(
        "direct_login",
        arguments={"word": "island", "code": "828930"},
    )

3

### Start querying data

Once the user is linked, your agent can start making MCP queries right away. Here's an example that requests the last 7 days of heart rate data:

agent.ts agent.py

__
    
    
    const result = await client.callTool({
      name: "get_health_metrics",
      arguments: {
        metric_type: "HEART_RATE",
        start_date: "2025-01-01",
        end_date: "2025-01-07",
        aggregation: "DAILY",
      },
    });
    
    console.log(result.content);

agent.ts agent.py

__
    
    
    result = await session.call_tool(
        "get_health_metrics",
        arguments={
            "metric_type": "HEART_RATE",
            "start_date": "2025-01-01",
            "end_date": "2025-01-07",
            "aggregation": "DAILY",
        },
    )
    
    print(result.content)

## Good to Know

Read this before you start integrating

__

Runtime

### App Must Stay Open

The VytalLink app needs to be active in the foreground to stream data. If the user backgrounds or closes the app, the data connection pauses until they return.

__

Performance

### Send Data in Batches

When querying large time ranges, the OS may throttle or kill long-running calls. Break requests into smaller date windows and merge the results in your agent.

__

Beta

### API is Experimental

The backend API works well for prototyping and testing, but it is not yet hardened for production traffic. Use it at your own risk and expect possible breaking changes.

## MCP Tools Reference

Three tools your agent can call after connecting

### direct_login

Logs in with the user's Word + PIN. No browser, no redirect. One tool call.

### get_summary

Returns a snapshot across steps, sleep, heart rate, and more for any date range.

### get_health_metrics

Query any metric by time range and aggregation: raw, hourly, or daily.

__ Full parameter reference, schemas, and response types in the [ API Reference __](https://api.vytallink.xmartlabs.com/docs/mcp)