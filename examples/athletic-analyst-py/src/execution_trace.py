from __future__ import annotations

import json
import sys
import time
from datetime import datetime, UTC

from .test_config import TEST_MODE

EXECUTION_TRACE_PREFIX = "EXECUTION_TRACE: "


class ExecutionTracer:
    def __init__(self) -> None:
        self._enabled = TEST_MODE
        self._started_at = time.perf_counter()

    def trace(self, event: str, **details: object) -> None:
        if not self._enabled:
            return

        payload = {
            "event": event,
            "timestamp": datetime.now(UTC).isoformat().replace("+00:00", "Z"),
            "elapsed_ms": round((time.perf_counter() - self._started_at) * 1000),
            **details,
        }
        print(f"{EXECUTION_TRACE_PREFIX}{json.dumps(payload)}", file=sys.stderr, flush=True)
