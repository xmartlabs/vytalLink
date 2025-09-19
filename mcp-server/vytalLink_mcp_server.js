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
import { readFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import path from 'node:path';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const packageJsonPath = path.join(__dirname, 'package.json');
let MCP_VERSION = 'unknown';

try {
  const packageContents = readFileSync(packageJsonPath, 'utf-8');
  const packageJson = JSON.parse(packageContents);
  MCP_VERSION = packageJson.version ?? MCP_VERSION;
} catch (versionError) {
  console.error('Failed to read MCP version from package.json:', versionError);
}

const MCP_DISTRIBUTION = process.env.VYTALLINK_MCP_DIST || 'npm';

const BASE_URL = process.env.VYTALLINK_BASE_URL || 'https://vytallink.local.xmartlabs.com';
const API_BASE_URL = `${BASE_URL}/mcp/call`;
const TOOLS_URL = `${BASE_URL}/mcp/tools`;

console.error('MCP Server starting...');
console.error(`Backend URL: ${BASE_URL}`);
console.error(`MCP Version: ${MCP_VERSION} (${MCP_DISTRIBUTION})`);

process.stdin.setEncoding('utf8');

let buffer = '';
let authToken = null;
let versionWarning = null;
let versionWarningShown = false;

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
      params: {
        ...(request.params || {}),
        clientVersion: MCP_VERSION,
        clientDistribution: MCP_DISTRIBUTION,
      }
    };
    
    const response = await fetch(API_BASE_URL, {
      method: "POST",
      headers: withVersionHeaders({
        "Content-Type": "application/json",
      }),
      body: JSON.stringify(requestBody),
    });
    
    const result = captureClientWarning(await parseBackendResponse(response));
    
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
        message: fetchError instanceof BackendError ? fetchError.message : "Backend server unavailable",
        data: fetchError instanceof BackendError ? fetchError.detail : fetchError.message
      }
    };
    console.log(JSON.stringify(errorResponse));
  }
}

async function handleToolsList(request) {
  try {
    const toolsResponse = await fetch(TOOLS_URL, {
      headers: withVersionHeaders(),
    });
    const toolsData = captureClientWarning(await parseBackendResponse(toolsResponse));
    
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
      clientVersion: MCP_VERSION,
      clientDistribution: MCP_DISTRIBUTION,
    },
  };
  
  const response = await fetch(API_BASE_URL, {
    method: "POST",
    headers: withVersionHeaders(headers),
    body: JSON.stringify(requestBody),
  });
  
  return await parseBackendResponse(response);
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
    const authorizeResult = captureClientWarning(
      await callBackendTool("oauth_authorize", {
        code: authCode,
        state: "random_state"
      }, headers)
    );
    
    // Extract and store the auth token
    if (authorizeResult.content && authorizeResult.content[0] && authorizeResult.content[0].text) {
      await extractAuthToken(authorizeResult.content[0].text);
    }
    
    // Return the authorize result
    return {
      jsonrpc: "2.0",
      id: request.id,
      result: appendWarningToResult(authorizeResult),
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

    const result = captureClientWarning(
      await callBackendTool(effectiveName, args, headers)
    );

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
    
    const decoratedResult = appendWarningToResult(result);

    const mcpResponse = {
      jsonrpc: "2.0",
      id: request.id,
      result: decoratedResult,
    };
    console.log(JSON.stringify(mcpResponse));
  } catch (fetchError) {
    console.error('Error calling tool:', fetchError);
    
    const errorResponse = {
      jsonrpc: "2.0",
      id: request.id,
      error: {
        code: -32603,
        message: fetchError instanceof BackendError ? fetchError.message : "Failed to call tool",
        data: fetchError instanceof BackendError ? fetchError.detail : fetchError.message
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

function formatWarningMessage(warning) {
  if (!warning) {
    return '';
  }
  return `⚠️ ${warning.message} (minimum ${warning.minimumVersion}, latest ${warning.latestVersion}). Download: ${warning.downloadUrl}`;
}

function captureClientWarning(payload) {
  if (!payload || typeof payload !== 'object') {
    return payload;
  }

  const warning = payload.clientWarning;
  if (!warning) {
    return payload;
  }

  const warningSignature = JSON.stringify(warning);
  const currentSignature = versionWarning ? JSON.stringify(versionWarning) : null;

  versionWarning = warning;
  versionWarningShown = false;

  if (warningSignature !== currentSignature) {
    console.error(formatWarningMessage(warning));
  }

  delete payload.clientWarning;
  return payload;
}

function appendWarningToResult(result) {
  if (!versionWarning || versionWarningShown) {
    return result;
  }

  if (!result || typeof result !== 'object') {
    return result;
  }

  if (result.isOutdated) {
    versionWarningShown = true;
    return result;
  }

  if (!Array.isArray(result.content)) {
    result.content = [];
  }

  result.content.push({ type: 'text', text: formatWarningMessage(versionWarning) });
  versionWarningShown = true;
  return result;
}

function withVersionHeaders(headers = {}) {
  return {
    ...headers,
    'X-Vytallink-MCP-Version': MCP_VERSION,
    'X-Vytallink-MCP-Dist': MCP_DISTRIBUTION,
  };
}

class BackendError extends Error {
  constructor(message, detail) {
    super(message);
    this.name = 'BackendError';
    this.detail = detail;
  }
}

async function parseBackendResponse(response) {
  let payload = null;
  try {
    payload = await response.json();
  } catch (parseError) {
    console.error('Failed to parse backend response as JSON:', parseError);
  }

  if (!response.ok) {
    const detail = payload?.detail ?? payload;
    const message =
      (detail && (detail.message || detail.error)) ||
      `Backend responded with status ${response.status}`;
    throw new BackendError(message, detail);
  }

  return payload;
}
