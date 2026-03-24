"""Test infrastructure — centralizes test-mode flags and helpers.

Active only when ATHLETIC_ANALYST_TEST_MODE=1 (used by the integration test runner).
"""

import json
import os
import sys

TEST_MODE = os.getenv("ATHLETIC_ANALYST_TEST_MODE") == "1"

EXECUTION_SUMMARY_PREFIX = "EXECUTION_SUMMARY: "


def emit_test_summary(summary: dict) -> None:
    if not TEST_MODE:
        return
    print(
        f"{EXECUTION_SUMMARY_PREFIX}{json.dumps(summary)}",
        file=sys.stderr,
        flush=True,
    )
