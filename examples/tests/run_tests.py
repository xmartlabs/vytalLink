#!/usr/bin/env python3
"""
Integration test runner for athletic-analyst-ts and athletic-analyst-py.

Usage:
    python tests/run_tests.py <word> <pin>

Example:
    python tests/run_tests.py zebra 427418
"""

import sys
import subprocess
import time
import os
import json
from pathlib import Path
from dataclasses import dataclass
from datetime import datetime

ROOT = Path(__file__).parent.parent
TS_DIR = ROOT / "athletic-analyst-ts"
PY_DIR = ROOT / "athletic-analyst-py"
REPORTS_DIR = ROOT / "tests" / "reports"

TIMEOUT = 180  # seconds per test
EXECUTION_SUMMARY_PREFIX = "EXECUTION_SUMMARY: "
EXECUTION_TRACE_PREFIX = "EXECUTION_TRACE: "
MIN_RESPONSE_CHARS = 20

TOOL_FAILURE_PATTERNS = (
    "[MCP] Tool call failed",
    "Error calling tool ",
    'Structured content does not match the tool\'s output schema',
)

# ANSI colors
GREEN = "\033[92m"
RED = "\033[91m"
YELLOW = "\033[93m"
BOLD = "\033[1m"
RESET = "\033[0m"


@dataclass
class TestResult:
    name: str
    passed: bool
    duration: float
    stdout: str
    stderr: str
    exit_code: int
    failure_reason: str = ""
    execution_summary: dict | None = None
    last_trace: dict | None = None


def load_api_key() -> str:
    env_file = PY_DIR / ".env"
    if not env_file.exists():
        env_file = TS_DIR / ".env"
    if not env_file.exists():
        print(f"{RED}ERROR: No .env file found in athletic-analyst-py/ or athletic-analyst-ts/{RESET}")
        sys.exit(1)
    for line in env_file.read_text().splitlines():
        line = line.strip()
        if line.startswith("ANTHROPIC_API_KEY="):
            key = line.split("=", 1)[1].strip()
            if key:
                return key
    print(f"{RED}ERROR: ANTHROPIC_API_KEY not found in .env{RESET}")
    sys.exit(1)


def parse_execution_summary(*outputs: str) -> dict | None:
    return _parse_prefixed_json(EXECUTION_SUMMARY_PREFIX, *outputs)


def parse_execution_trace(*outputs: str) -> dict | None:
    return _parse_prefixed_json(EXECUTION_TRACE_PREFIX, *outputs)


def _parse_prefixed_json(prefix: str, *outputs: str) -> dict | None:
    for output in outputs:
        for line in reversed(output.splitlines()):
            if not line.startswith(prefix):
                continue
            raw_json = line[len(prefix):].strip()
            try:
                data = json.loads(raw_json)
            except json.JSONDecodeError:
                return None
            if isinstance(data, dict):
                return data
    return None


def summarize_execution_summary(summary: dict) -> str:
    return (
        f"tool_calls={summary.get('tool_calls', 0)}, "
        f"tool_failures={summary.get('tool_failures', 0)}, "
        f"successful_data_calls={summary.get('successful_data_calls', 0)}, "
        f"degraded={summary.get('degraded', False)}, "
        f"auth_ok={summary.get('auth_ok', False)}"
    )


def summarize_trace(trace: dict) -> str:
    event = trace.get("event", "unknown")
    details = []
    if "tool" in trace:
        details.append(f"tool={trace['tool']}")
    if "step" in trace:
        details.append(f"step={trace['step']}")
    if "stop_reason" in trace:
        details.append(f"stop_reason={trace['stop_reason']}")
    return f"{event}{' (' + ', '.join(details) + ')' if details else ''}"


def is_discover_test(test_name: str) -> bool:
    return test_name.endswith("discover")


def strip_non_response_lines(*outputs: str) -> str:
    combined = "\n".join(output for output in outputs if output)
    lines = [
        l for l in combined.splitlines()
        if l.strip()
        and not l.startswith(EXECUTION_SUMMARY_PREFIX)
        and not l.startswith(EXECUTION_TRACE_PREFIX)
        and not l.strip().startswith("===")
        and not l.strip().startswith("Mode:")
        and "Word:" not in l
        and "PIN:" not in l
        and "VytalLink credentials" not in l
        and l.strip() != "You:"
        and "Analyzing..." not in l
        and "Interactive mode" not in l
    ]
    return "\n".join(lines).strip()


def check_output(
    stdout: str,
    stderr: str,
    exit_code: int,
    test_name: str,
) -> tuple[bool, str, dict | None, dict | None]:
    if exit_code != 0:
        return False, f"exit code: {exit_code}", None, parse_execution_trace(stderr, stdout)

    combined_output = "\n".join(part for part in (stdout, stderr) if part)
    lowered_output = combined_output.lower()
    if "max steps reached" in lowered_output:
        return False, "max steps reached without a final response", None, parse_execution_trace(stderr, stdout)
    if "fatal error" in lowered_output:
        return False, "fatal error in output", None, parse_execution_trace(stderr, stdout)

    for pattern in TOOL_FAILURE_PATTERNS:
        if pattern in combined_output:
            return False, f"tool failure detected: {pattern}", None, parse_execution_trace(stderr, stdout)

    summary = parse_execution_summary(stdout, stderr)
    trace = parse_execution_trace(stderr, stdout)
    if not is_discover_test(test_name):
        if summary is None:
            return False, "missing execution summary in test mode", None, trace
        if summary.get("degraded"):
            return False, f"execution degraded ({summarize_execution_summary(summary)})", summary, trace
        if int(summary.get("tool_failures", 0)) > 0:
            return False, f"tool failures detected ({summarize_execution_summary(summary)})", summary, trace
        if not summary.get("auth_ok"):
            return False, f"authentication did not succeed ({summarize_execution_summary(summary)})", summary, trace
        if int(summary.get("successful_data_calls", 0)) <= 0:
            return False, f"no successful data tool calls ({summarize_execution_summary(summary)})", summary, trace

    content = strip_non_response_lines(stdout, stderr)
    if len(content) < MIN_RESPONSE_CHARS:
        return False, f"response too short ({len(content)} chars) — likely no analysis generated", summary, trace

    return True, "", summary, trace


def _coerce_output(value: str | bytes | None) -> str:
    if value is None:
        return ""
    if isinstance(value, bytes):
        return value.decode("utf-8", errors="replace")
    return value


def build_timeout_failure_reason(trace: dict | None) -> str:
    if not trace:
        return f"timeout after {TIMEOUT}s"
    return f"timeout after {TIMEOUT}s (last trace: {summarize_trace(trace)})"


def run_test(name: str, cmd: list[str], cwd: Path, stdin_text: str, env: dict) -> TestResult:
    start = time.time()
    try:
        result = subprocess.run(
            cmd,
            input=stdin_text,
            capture_output=True,
            text=True,
            cwd=cwd,
            env=env,
            timeout=TIMEOUT,
        )
        duration = time.time() - start
        passed, reason, summary, trace = check_output(
            stdout=result.stdout,
            stderr=result.stderr,
            exit_code=result.returncode,
            test_name=name,
        )
        return TestResult(
            name=name,
            passed=passed,
            duration=duration,
            stdout=result.stdout,
            stderr=result.stderr,
            exit_code=result.returncode,
            failure_reason=reason,
            execution_summary=summary,
            last_trace=trace,
        )
    except subprocess.TimeoutExpired as e:
        duration = time.time() - start
        stdout = _coerce_output(getattr(e, "stdout", None))
        stderr = _coerce_output(getattr(e, "stderr", None))
        trace = parse_execution_trace(stderr, stdout)
        return TestResult(
            name=name,
            passed=False,
            duration=duration,
            stdout=stdout,
            stderr=stderr,
            exit_code=-1,
            failure_reason=build_timeout_failure_reason(trace),
            last_trace=trace,
        )
    except Exception as e:
        duration = time.time() - start
        return TestResult(
            name=name,
            passed=False,
            duration=duration,
            stdout="",
            stderr="",
            exit_code=-1,
            failure_reason=str(e),
        )


def build_tests(word: str, pin: str) -> list[dict]:
    creds = f"{word}\n{pin}\n"
    chat_input = f"{word}\n{pin}\nHow many hours did I sleep last night? Answer in one sentence.\nexit\n"

    non_chat_modes = [
        ("readiness", "Quick readiness score today"),
        ("recovery",  "Brief recovery summary"),
        ("training",  "Training load summary"),
        ("sleep",     "Sleep quality summary"),
    ]

    tests = []

    # TS discover (no credentials needed)
    tests.append({
        "name": "TS › discover",
        "cmd": ["npm", "run", "discover"],
        "cwd": TS_DIR,
        "stdin": "",
    })

    # TS non-chat modes
    for mode, query in non_chat_modes:
        tests.append({
            "name": f"TS › {mode}",
            "cmd": ["npm", "run", "agent", "--", "--mode", mode, "--query", query],
            "cwd": TS_DIR,
            "stdin": creds,
        })

    # TS chat
    tests.append({
        "name": "TS › chat",
        "cmd": ["npm", "run", "agent", "--", "--mode", "chat"],
        "cwd": TS_DIR,
        "stdin": chat_input,
    })

    # PY non-chat modes
    for mode, query in non_chat_modes:
        tests.append({
            "name": f"PY › {mode}",
            "cmd": [sys.executable, "-m", "athletic-analyst-py.src.main", "--mode", mode, "--query", query],
            "cwd": ROOT,
            "stdin": creds,
        })

    # PY chat
    tests.append({
        "name": "PY › chat",
        "cmd": [sys.executable, "-m", "athletic-analyst-py.src.main", "--mode", "chat"],
        "cwd": ROOT,
        "stdin": chat_input,
    })

    return tests


def print_progress(index: int, total: int, name: str, result: TestResult):
    status = f"{GREEN}✓{RESET}" if result.passed else f"{RED}✗{RESET}"
    label = f"[{index}/{total}] {name}"
    duration = f"{result.duration:.1f}s"
    reason = f"  {YELLOW}({result.failure_reason}){RESET}" if not result.passed else ""
    print(f"  {status} {label:<35} {duration}{reason}")


def print_report(results: list[TestResult]):
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    passed = [r for r in results if r.passed]

    print()
    print(f"{BOLD}{'═' * 50}{RESET}")
    print(f"{BOLD}  INTEGRATION REPORT — {now}{RESET}")
    print(f"{BOLD}{'═' * 50}{RESET}")
    print()

    for r in results:
        icon = f"{GREEN}✓ PASS{RESET}" if r.passed else f"{RED}✗ FAIL{RESET}"
        print(f"  {icon}  {r.name:<30} ({r.duration:.1f}s)")
        if not r.passed:
            print(f"         {YELLOW}→ {r.failure_reason}{RESET}")
            if r.stderr.strip():
                last_lines = r.stderr.strip().splitlines()[-5:]
                for line in last_lines:
                    print(f"           {line}")
        print()

    total = len(results)
    n_passed = len(passed)
    color = GREEN if n_passed == total else (YELLOW if n_passed > 0 else RED)
    print(f"{BOLD}  Result: {color}{n_passed}/{total} tests passed{RESET}{BOLD}{RESET}")
    print(f"{BOLD}{'═' * 50}{RESET}")
    print()


def build_text_report(
    results: list[TestResult],
    status: str = "completed",
    total_tests: int | None = None,
) -> str:
    now = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    passed = [r for r in results if r.passed]
    total = len(results)
    n_passed = len(passed)
    expected_total = total_tests if total_tests is not None else total
    normalized_status = status.upper()

    lines = [
        "=" * 50,
        f"INTEGRATION REPORT - {now}",
        "=" * 50,
        f"Status: {normalized_status}",
        f"Progress: {total}/{expected_total} completed",
        "",
    ]

    for r in results:
        icon = "PASS" if r.passed else "FAIL"
        lines.append(f"{icon}  {r.name} ({r.duration:.1f}s)")
        if not r.passed and r.failure_reason:
            lines.append(f"Reason: {r.failure_reason}")
        if r.execution_summary is not None:
            lines.append(f"Execution summary: {json.dumps(r.execution_summary, sort_keys=True)}")
        if r.last_trace is not None:
            lines.append(f"Last trace: {json.dumps(r.last_trace, sort_keys=True)}")
        lines.append(f"Exit code: {r.exit_code}")
        lines.append("STDOUT:")
        lines.append(r.stdout.rstrip() or "<empty>")
        lines.append("STDERR:")
        lines.append(r.stderr.rstrip() or "<empty>")
        lines.append("")

    lines.append(f"Result: {n_passed}/{total} tests passed")
    lines.append("=" * 50)
    lines.append("")
    return "\n".join(lines)


def write_report(
    results: list[TestResult],
    reports_dir: Path = REPORTS_DIR,
    report_path: Path | None = None,
    status: str = "completed",
    total_tests: int | None = None,
) -> Path:
    reports_dir.mkdir(parents=True, exist_ok=True)
    if report_path is None:
        timestamp = datetime.now().strftime("%Y%m%d-%H%M%S")
        report_path = reports_dir / f"integration-report-{timestamp}.txt"
    report_path.write_text(
        build_text_report(
            results,
            status=status,
            total_tests=total_tests,
        )
    )
    return report_path


def main():
    if len(sys.argv) != 3:
        print("Usage: python tests/run_tests.py <word> <pin>")
        sys.exit(1)

    word = sys.argv[1]
    pin = sys.argv[2]

    api_key = load_api_key()
    env = {
        **os.environ,
        "ANTHROPIC_API_KEY": api_key,
        "ATHLETIC_ANALYST_TEST_MODE": "1",
    }

    tests = build_tests(word, pin)
    total = len(tests)

    print(f"\n{BOLD}Running {total} tests...{RESET}\n")

    results = []
    report_path = write_report(results, status="running", total_tests=total)
    print(f"Live report: {report_path}")

    for i, t in enumerate(tests, 1):
        print(f"  [{i}/{total}] {t['name']} ...", end="", flush=True)
        result = run_test(
            name=t["name"],
            cmd=t["cmd"],
            cwd=t["cwd"],
            stdin_text=t["stdin"],
            env=env,
        )
        results.append(result)
        write_report(results, report_path=report_path, status="running", total_tests=total)
        status = f"{GREEN}✓{RESET}" if result.passed else f"{RED}✗{RESET}"
        reason = f"  {YELLOW}({result.failure_reason}){RESET}" if not result.passed else ""
        print(f"\r  {status} [{i}/{total}] {t['name']:<35} {result.duration:.1f}s{reason}")

    write_report(results, report_path=report_path, status="completed", total_tests=total)
    print_report(results)

    all_passed = all(r.passed for r in results)
    sys.exit(0 if all_passed else 1)


if __name__ == "__main__":
    main()
