#!/usr/bin/env node

/**
 * VytalLink MCP Server Proxy
 * 
 * This server acts as a proxy between MCP clients (like Claude Desktop) and the 
 * backend API. It implements the MCP protocol while delegating all
 * tool definitions and business logic to the backend endpoints.
 * 
 * Architecture:
 * - Tool definitions: Fetched from GET /mcp/tools (single source of truth)
 * - Tool execution: Forwarded to POST /mcp/call
 * - No duplication: All tools defined only in the backend
 */

import fetch from 'node-fetch';

const BASE_URL = process.env.VYTALLINK_BASE_URL || 'https://vytallink.local.xmartlabs.com';
const API_BASE_URL = `${BASE_URL}/mcp/call`;
const TOOLS_URL = `${BASE_URL}/mcp/tools`;

console.error('MCP Server starting...');
console.error(`Backend URL: ${BASE_URL}`);

process.stdin.setEncoding('utf8');

let buffer = '';
let authToken = null;

process.stdin.on('data', (chunk) => {
  buffer += chunk;
  
  try {
    const lines = buffer.split('\n');
    buffer = lines.pop() || ''; // Keep incomplete line in buffer
    
    for (const line of lines) {
      if (line.trim()) {
        const request = JSON.parse(line);
        handleRequest(request);
      }
    }
  } catch (error) {
    // Continue reading for incomplete JSON
  }
});

process.stdin.on('end', () => {
  console.error('MCP Server shutting down...');
  process.exit(0);
});

async function handleRequest(request) {
  console.error(`Processing request: ${request.method}`);
  
  try {
    if (request.method === "initialize") {
      await handleInitialize(request);
    } else if (request.method === "notifications/initialized") {
      // This is a notification, no response needed
      console.error('Received initialized notification');
    } else if (request.method === "tools/list") {
      await handleToolsList(request);
    } else if (request.method === "tools/call") {
      await handleToolsCall(request);
    } else if (request.method === "prompts/list") {
      await handlePromptsList(request);
    } else if (request.method === "resources/list") {
      await handleResourcesList(request);
    } else {
      console.error(`Unknown method: ${request.method}`);
      
      // Only send error response if request has an ID (not a notification)
      if (request.id !== undefined) {
        const errorResponse = {
          jsonrpc: "2.0",
          id: request.id,
          error: {
            code: -32601,
            message: "Method not found",
            data: `Unknown method: ${request.method}`
          }
        };
        console.log(JSON.stringify(errorResponse));
      }
    }
  } catch (error) {
    console.error('Error processing request:', error);
    
    // Only send error response if request has an ID (not a notification)
    if (request.id !== undefined) {
      console.log(JSON.stringify({
        jsonrpc: "2.0",
        id: request.id,
        error: {
          code: -32603,
          message: "Internal error",
          data: error.message,
        },
      }));
    }
  }
}

async function handleInitialize(request) {
  try {
    const requestBody = {
      method: "initialize",
      params: request.params || {}
    };
    
    const response = await fetch(API_BASE_URL, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(requestBody),
    });
    
    const result = await response.json();
    
    const initResponse = {
      jsonrpc: "2.0",
      id: request.id,
      result: result,
    };
    console.log(JSON.stringify(initResponse));
  } catch (fetchError) {
    console.error('Error calling initialize endpoint:', fetchError);
    
    const errorResponse = {
      jsonrpc: "2.0",
      id: request.id,
      error: {
        code: -32603,
        message: "Backend server unavailable",
        data: fetchError.message
      }
    };
    console.log(JSON.stringify(errorResponse));
  }
}

async function handleToolsList(request) {
  try {
    const toolsResponse = await fetch(TOOLS_URL);
    const toolsData = await toolsResponse.json();
    
    const response = {
      jsonrpc: "2.0",
      id: request.id,
      result: {
        tools: toolsData.tools
      },
    };
    console.log(JSON.stringify(response));
  } catch (fetchError) {
    console.error('Error fetching tools from backend endpoint:', fetchError);  
    
    const errorResponse = {
      jsonrpc: "2.0",
      id: request.id,
      error: {
        code: -32603,
        message: "Failed to fetch tools from server",
        data: fetchError.message
      }
    };
    console.log(JSON.stringify(errorResponse));
  }
}

async function extractAuthToken(text) {
  const tokenMatch = text.match(/Access Token: ([a-zA-Z0-9_-]+)/);
  if (tokenMatch) {
    authToken = tokenMatch[1];
    console.error(`Auth token extracted and stored: ${authToken.substring(0, 16)}...`);
    return tokenMatch[1];
  }
  return null;
}

async function callBackendTool(name, args, headers) {
  const requestBody = {
    method: "call_tool",
    params: {
      name: name,
      arguments: args,
    },
  };
  
  const response = await fetch(API_BASE_URL, {
    method: "POST",
    headers: headers,
    body: JSON.stringify(requestBody),
  });
  
  return await response.json();
}

async function handleOAuthLoginFlow(request, result) {
  const text = result.content[0].text;
  const authCodeMatch = text.match(/OAuth Code: ([a-zA-Z0-9_-]+)/);
  
  if (!authCodeMatch) {
    return null; // No auth code found, return original result
  }
  
  const authCode = authCodeMatch[1];
  console.error(`OAuth login successful, automatically authorizing with code: ${authCode.substring(0, 16)}...`);
  
  try {
    const headers = {
      "Content-Type": "application/json",
    };
    
    // Call oauth_authorize automatically
    const authorizeResult = await callBackendTool("oauth_authorize", {
      code: authCode,
      state: "random_state"
    }, headers);
    
    // Extract and store the auth token
    if (authorizeResult.content && authorizeResult.content[0] && authorizeResult.content[0].text) {
      await extractAuthToken(authorizeResult.content[0].text);
    }
    
    // Return the authorize result
    return {
      jsonrpc: "2.0",
      id: request.id,
      result: authorizeResult,
    };
  } catch (authorizeError) {
    console.error('Error during automatic oauth_authorize:', authorizeError);
    return null; // Fall back to original result
  }
}

async function handleToolsCall(request) {
  const { name, arguments: args } = request.params;
  
  console.error(`Calling tool: ${name} with args:`, args);
  
  const headers = {
    "Content-Type": "application/json",
  };
  
  if (authToken) {
    headers["Authorization"] = `Bearer ${authToken}`;
    console.error(`Using auth token: ${authToken.substring(0, 16)}...`);
  } else {
    console.error('No auth token available - request will be unauthenticated');
  }
  
  try {
    // Prefer direct token flow when possible
    let effectiveName = name;
    if (name === "oauth_login") {
      // If the client asked for oauth_login, try the streamlined direct_login instead
      if (args && args.word && args.code) {
        console.error("Redirecting oauth_login to direct_login for streamlined auth");
        effectiveName = "direct_login";
      }
    }

    const result = await callBackendTool(effectiveName, args, headers);

    // Handle oauth_login success - automatically call oauth_authorize
    if (name === "oauth_login" && effectiveName === "oauth_login" && result.content && result.content[0] && result.content[0].text) {
      const autoAuthResponse = await handleOAuthLoginFlow(request, result);
      if (autoAuthResponse) {
        console.log(JSON.stringify(autoAuthResponse));
        return;
      }
    }

    // Extract auth token for direct flows
    if ((effectiveName === "oauth_authorize" || effectiveName === "direct_login") && result.content && result.content[0] && result.content[0].text) {
      await extractAuthToken(result.content[0].text);
    }
    
    const mcpResponse = {
      jsonrpc: "2.0",
      id: request.id,
      result: result,
    };
    console.log(JSON.stringify(mcpResponse));
  } catch (fetchError) {
    console.error('Error calling tool:', fetchError);
    
    const errorResponse = {
      jsonrpc: "2.0",
      id: request.id,
      error: {
        code: -32603,
        message: "Failed to call tool",
        data: fetchError.message
      }
    };
    console.log(JSON.stringify(errorResponse));
  }
}

async function handlePromptsList(request) {
  // Return empty prompts list since this server doesn't provide prompts
  const response = {
    jsonrpc: "2.0",
    id: request.id,
    result: {
      prompts: []
    }
  };
  console.log(JSON.stringify(response));
}

async function handleResourcesList(request) {
  // Return empty resources list since this server doesn't provide resources
  const response = {
    jsonrpc: "2.0",
    id: request.id,
    result: {
      resources: []
    }
  };
  console.log(JSON.stringify(response));
}

console.error('MCP Server ready, waiting for requests...');
