import asyncio
import contextlib
import json
import os
import sys
import time
from mcp import ClientSession, StdioServerParameters
from mcp.client.stdio import stdio_client

from .execution_trace import ExecutionTracer

DATA_TOOL_NAMES = {"get_health_metrics", "get_summary"}
AUTH_TOOL_NAMES = {"direct_login", "oauth_login", "oauth_authorize"}
CONNECT_RETRIES = 3
CONNECT_RETRY_DELAY_SECONDS = 2


def build_mcp_environment() -> dict[str, str]:
    env = dict(os.environ)
    should_forward_custom_base_url = (
        os.getenv("ATHLETIC_ANALYST_FORWARD_VYTALLINK_BASE_URL") == "1"
    )
    if not should_forward_custom_base_url:
        env.pop("VYTALLINK_BASE_URL", None)
    return env


def _is_retryable_connect_error(error: Exception) -> bool:
    message = str(error)
    return any(
        marker in message
        for marker in (
            "Backend server unavailable",
            "ECONNREFUSED",
            "fetch failed",
            "request to ",
        )
    )


def _structured_success(result) -> bool | None:
    structured = getattr(result, "structuredContent", None)
    if isinstance(structured, dict) and "success" in structured:
        return bool(structured["success"])
    return None


class McpBridge:
    def __init__(self, tracer: ExecutionTracer | None = None):
        self._session: ClientSession | None = None
        self._tools: list = []
        self._exit_stack = None
        self._tracer = tracer
        self._execution_summary = {
            "tool_calls": 0,
            "tool_failures": 0,
            "successful_data_calls": 0,
            "degraded": False,
            "auth_ok": False,
        }

    async def connect(self) -> None:
        last_error: Exception | None = None

        for attempt in range(1, CONNECT_RETRIES + 1):
            self._exit_stack = contextlib.AsyncExitStack()
            await self._exit_stack.__aenter__()
            self._session = None

            if self._tracer:
                self._tracer.trace("bridge_connect_start", attempt=attempt)

            try:
                server_params = StdioServerParameters(
                    command="npx",
                    args=["@xmartlabs/vytallink-mcp-server"],
                    env=build_mcp_environment(),
                )

                stdio_transport = await self._exit_stack.enter_async_context(
                    stdio_client(server_params)
                )
                read_stream, write_stream = stdio_transport
                self._session = await self._exit_stack.enter_async_context(
                    ClientSession(read_stream, write_stream)
                )

                await self._session.initialize()
                result = await self._session.list_tools()
                self._tools = result.tools
                if self._tracer:
                    self._tracer.trace(
                        "bridge_connect_end",
                        attempt=attempt,
                        tools_loaded=len(self._tools),
                    )
                print(f"[MCP] Connected — {len(self._tools)} tools loaded", file=sys.stderr, flush=True)
                return
            except Exception as error:
                last_error = error
                if self._tracer:
                    self._tracer.trace(
                        "bridge_connect_retry",
                        attempt=attempt,
                        error=str(error),
                    )
                await self.close()
                if attempt >= CONNECT_RETRIES or not _is_retryable_connect_error(error):
                    raise
                print(
                    f"[MCP] Connection attempt {attempt} failed: {error}. Retrying...",
                    file=sys.stderr,
                    flush=True,
                )
                await asyncio.sleep(CONNECT_RETRY_DELAY_SECONDS)

        if last_error is not None:
            raise last_error

    async def close(self) -> None:
        if self._exit_stack:
            await self._exit_stack.aclose()
            self._exit_stack = None
            self._session = None

    def get_mcp_tools(self) -> list:
        return self._tools

    def get_execution_summary(self) -> dict:
        return dict(self._execution_summary)

    def mark_degraded(self) -> None:
        self._execution_summary["degraded"] = True

    async def call_tool(self, name: str, args: dict) -> dict:
        self._execution_summary["tool_calls"] += 1
        if self._tracer:
            self._tracer.trace("tool_start", tool=name)
        started_at = time.perf_counter()
        if not self._session:
            self._execution_summary["tool_failures"] += 1
            self._execution_summary["degraded"] = True
            return {"content": "Error: MCP session not connected", "is_error": True}
        try:
            result = await self._session.call_tool(name, args)
            tool_reported_error = bool(getattr(result, "isError", False))
            if not result.content:
                if self._tracer:
                    self._tracer.trace(
                        "tool_end",
                        tool=name,
                        duration_ms=round((time.perf_counter() - started_at) * 1000),
                        is_error=tool_reported_error,
                    )
                if tool_reported_error:
                    self._execution_summary["tool_failures"] += 1
                    self._execution_summary["degraded"] = True
                return {"content": "No data returned", "is_error": tool_reported_error}
            parts = []
            for block in result.content:
                if hasattr(block, "text"):
                    parts.append(block.text)
                else:
                    parts.append(json.dumps(block.__dict__))
            rendered_content = "\n".join(parts)
            structured_success = _structured_success(result)
            if tool_reported_error:
                self._execution_summary["tool_failures"] += 1
                self._execution_summary["degraded"] = True
            elif name in DATA_TOOL_NAMES:
                self._execution_summary["successful_data_calls"] += 1
            if not tool_reported_error and name in AUTH_TOOL_NAMES and (
                structured_success is None or structured_success
            ):
                self._execution_summary["auth_ok"] = True
            if self._tracer:
                self._tracer.trace(
                    "tool_end",
                    tool=name,
                    duration_ms=round((time.perf_counter() - started_at) * 1000),
                    is_error=tool_reported_error,
                )
            return {"content": rendered_content, "is_error": tool_reported_error}
        except Exception as e:
            msg = str(e)
            self._execution_summary["tool_failures"] += 1
            self._execution_summary["degraded"] = True
            if self._tracer:
                self._tracer.trace(
                    "tool_end",
                    tool=name,
                    duration_ms=round((time.perf_counter() - started_at) * 1000),
                    is_error=True,
                    error=msg,
                )
            print(f"[MCP] Tool call failed: {name} — {msg}", file=sys.stderr, flush=True)
            return {"content": f"Error calling tool {name}: {msg}", "is_error": True}
