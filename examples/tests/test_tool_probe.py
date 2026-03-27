import sys
import unittest
from pathlib import Path


PY_SRC_DIR = (
    Path(__file__).resolve().parents[1] / "athletic-analyst-py"
)
if str(PY_SRC_DIR) not in sys.path:
    sys.path.insert(0, str(PY_SRC_DIR))

from src.tool_probe import check_tool_result  # noqa: E402


class CheckToolResultTests(unittest.TestCase):
    def test_rejects_error_json_even_with_prefixed_log_line(self):
        result = {
            "is_error": False,
            "content": (
                "Summary retrieved for 2026-02-25T00:00:00Z to "
                "2026-03-27T23:59:59Z.\n\n"
                "{\n"
                '  "success": false,\n'
                '  "start_time": "2026-02-25T00:00:00Z",\n'
                '  "end_time": "2026-03-27T23:59:59Z",\n'
                '  "results": [],\n'
                '  "error_message": "Invalid device response shape"\n'
                "}"
            ),
        }

        ok, reason = check_tool_result(result, "get_summary")

        self.assertFalse(ok)
        self.assertEqual(reason, "Invalid device response shape")


if __name__ == "__main__":
    unittest.main()
