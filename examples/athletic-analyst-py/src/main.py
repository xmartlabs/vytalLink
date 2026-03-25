import argparse
import asyncio
from pathlib import Path

from dotenv import load_dotenv

from .mcp_bridge import McpBridge
from .agent import run_agent
from .system_prompt import VALID_MODES, AnalysisMode
from .execution_trace import ExecutionTracer
from .test_config import emit_test_summary

load_dotenv(Path(__file__).parent.parent / ".env")

ANALYSIS_QUERIES: dict[str, str] = {
    "readiness": "Analyze my daily readiness to train today.",
    "overview": "Give me a health overview for the last 7 days.",
    "training": "Analyze my training load and injury risk.",
    "sleep": "Analyze my sleep quality and patterns over the past 14 days.",
    "chat": "",
}


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Athletic Performance Analyst")
    parser.add_argument(
        "--mode",
        choices=VALID_MODES,
        default="chat",
        help="Analysis mode (default: chat)",
    )
    parser.add_argument("--query", help="Custom query (overrides default for mode)")
    return parser.parse_args()


def prompt_credentials() -> tuple[str, str]:
    print("VytalLink credentials (from the mobile app):")
    word = input("  Word: ").strip()
    code = input("  PIN:  ").strip()
    print()
    return word, code


def build_query_with_credentials(query: str, word: str, code: str) -> str:
    return f'My VytalLink credentials: word="{word}", code="{code}". {query}'


async def main() -> None:
    args = parse_args()
    mode: AnalysisMode = args.mode
    tracer = ExecutionTracer()

    print("\n=== Athletic Performance Analyst ===")
    print(f"Mode: {mode}\n")

    word, code = prompt_credentials()

    bridge = McpBridge(tracer)
    await bridge.connect()

    try:
        if mode != "chat":
            base_query = args.query or ANALYSIS_QUERIES[mode]
            query = build_query_with_credentials(base_query, word, code)
            print("Analyzing... (this may take a moment)\n")
            text, _ = await run_agent(query, bridge, mode, tracer=tracer)
            print(text)
        else:
            history: list[dict] = []

            print("Interactive mode. Type your question (or 'exit' to quit).\n")

            # Seed history with a silent login so the model authenticates on first tool call
            login_message = build_query_with_credentials(
                "Please authenticate with VytalLink before answering my questions.",
                word,
                code,
            )
            tracer.trace("login_seed_start", mode=mode)
            _, auth_messages = await run_agent(
                login_message,
                bridge,
                mode,
                history,
                tracer,
            )
            tracer.trace("login_seed_end", mode=mode)
            history = auth_messages

            while True:
                try:
                    user_input = input("You: ").strip()
                except (EOFError, KeyboardInterrupt):
                    break
                tracer.trace("chat_input_received", characters=len(user_input))
                if user_input.lower() in ("exit", "quit"):
                    break
                if not user_input:
                    continue

                print("\nAnalyzing...\n")
                text, history = await run_agent(user_input, bridge, mode, history, tracer)
                print(f"\nAnalyst: {text}\n")
    finally:
        emit_test_summary(bridge.get_execution_summary())
        await bridge.close()


if __name__ == "__main__":
    asyncio.run(main())
