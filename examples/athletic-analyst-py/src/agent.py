import sys
import time

import anthropic
from .mcp_bridge import McpBridge
from .system_prompt import build_system_prompt, AnalysisMode
from .execution_trace import ExecutionTracer
from .test_config import TEST_MODE

MODEL = "claude-sonnet-4-6"
MAX_STEPS = 15  # max tool-use iterations before giving up

client = anthropic.Anthropic()


def _sanitize_schema(schema: dict) -> dict:
    return {k: v for k, v in schema.items() if k not in ("oneOf", "anyOf", "allOf", "not")}


def _tools_from_bridge(bridge: McpBridge) -> list[dict]:
    tools = []
    for t in bridge.get_mcp_tools():
        raw_schema = t.inputSchema if hasattr(t, "inputSchema") else {"type": "object", "properties": {}}
        tool_def: dict = {
            "name": t.name,
            "description": t.description or "",
            "input_schema": _sanitize_schema(raw_schema),
        }
        tools.append(tool_def)
    return tools


async def run_agent(
    query: str,
    bridge: McpBridge,
    mode: AnalysisMode = "chat",
    history: list[dict] | None = None,
    tracer: ExecutionTracer | None = None,
) -> tuple[str, list[dict]]:
    if history is None:
        history = []

    tools = _tools_from_bridge(bridge)
    system = build_system_prompt(mode)
    messages: list[dict] = [*history, {"role": "user", "content": query}]

    for step in range(1, MAX_STEPS + 1):
        started_at = time.perf_counter()
        if tracer:
            tracer.trace("model_request_start", step=step, mode=mode)
        request_kwargs = {
            "model": MODEL,
            "max_tokens": 4096 if TEST_MODE else 8096,
            "system": system,
            "tools": tools,
            "messages": messages,
        }
        if TEST_MODE:
            request_kwargs["temperature"] = 0
        response = client.messages.create(**request_kwargs)
        if tracer:
            tracer.trace(
                "model_request_end",
                step=step,
                mode=mode,
                duration_ms=round((time.perf_counter() - started_at) * 1000),
                stop_reason=response.stop_reason,
            )

        # Collect assistant content blocks
        assistant_content = response.content
        messages.append({"role": "assistant", "content": assistant_content})

        if response.stop_reason == "end_turn":
            # Extract text from final response
            text = "\n".join(
                block.text for block in assistant_content if hasattr(block, "text")
            )
            if tracer:
                tracer.trace(
                    "final_response_ready",
                    step=step,
                    mode=mode,
                    text_length=len(text),
                )
            return text, messages

        if response.stop_reason == "tool_use":
            tool_results = []
            for block in assistant_content:
                if block.type == "tool_use":
                    print(f"[Tool] {block.name}", file=sys.stderr, flush=True)
                    result = await bridge.call_tool(block.name, block.input)
                    tool_results.append({
                        "type": "tool_result",
                        "tool_use_id": block.id,
                        "content": result["content"],
                        "is_error": result["is_error"],
                    })
            messages.append({"role": "user", "content": tool_results})
        else:
            bridge.mark_degraded()
            # Unexpected stop reason — return what we have
            text = "\n".join(
                block.text for block in assistant_content if hasattr(block, "text")
            )
            if tracer:
                tracer.trace(
                    "final_response_ready",
                    step=step,
                    mode=mode,
                    text_length=len(text),
                    degraded=True,
                )
            return text, messages

    # Exhausted max steps
    bridge.mark_degraded()
    if tracer:
        tracer.trace(
            "final_response_ready",
            mode=mode,
            degraded=True,
            reason="max_steps_reached",
        )
    return "Max steps reached without a final response.", messages
