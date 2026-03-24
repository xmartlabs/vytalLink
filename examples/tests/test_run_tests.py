import importlib.util
import io
import json
import subprocess
import tempfile
import unittest
from pathlib import Path
from contextlib import redirect_stdout
from unittest.mock import patch


MODULE_PATH = Path(__file__).with_name("run_tests.py")
SPEC = importlib.util.spec_from_file_location("run_tests_module", MODULE_PATH)
run_tests = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(run_tests)


class WriteReportTests(unittest.TestCase):
    def test_write_report_creates_text_report_with_test_output(self):
        result = run_tests.TestResult(
            name="TS › readiness",
            passed=False,
            duration=1.5,
            stdout="stdout details",
            stderr="stderr details",
            exit_code=1,
            failure_reason="response too short",
        )

        with tempfile.TemporaryDirectory() as tmpdir:
            reports_dir = Path(tmpdir)

            report_path = run_tests.write_report([result], reports_dir=reports_dir)

            self.assertTrue(report_path.exists())
            self.assertEqual(report_path.parent, reports_dir)

            content = report_path.read_text()
            self.assertIn("INTEGRATION REPORT", content)
            self.assertIn("TS › readiness", content)
            self.assertIn("stdout details", content)
            self.assertIn("stderr details", content)
            self.assertIn("response too short", content)

    def test_write_report_reuses_existing_report_path_for_live_updates(self):
        first_result = run_tests.TestResult(
            name="TS › readiness",
            passed=True,
            duration=1.5,
            stdout="first stdout",
            stderr="",
            exit_code=0,
        )
        second_result = run_tests.TestResult(
            name="TS › sleep",
            passed=False,
            duration=2.0,
            stdout="second stdout",
            stderr="second stderr",
            exit_code=1,
            failure_reason="response too short",
        )

        with tempfile.TemporaryDirectory() as tmpdir:
            reports_dir = Path(tmpdir)
            fixed_now = run_tests.datetime(2026, 3, 20, 12, 30, 45)

            with patch.object(run_tests, "datetime") as mock_datetime:
                mock_datetime.now.return_value = fixed_now
                mock_datetime.strftime = run_tests.datetime.strftime
                report_path = run_tests.write_report(
                    [first_result],
                    reports_dir=reports_dir,
                    status="running",
                    total_tests=2,
                )

            updated_path = run_tests.write_report(
                [first_result, second_result],
                reports_dir=reports_dir,
                report_path=report_path,
                status="completed",
                total_tests=2,
            )

            self.assertEqual(updated_path, report_path)
            self.assertEqual(list(reports_dir.glob("integration-report-*.txt")), [report_path])

            content = report_path.read_text()
            self.assertIn("Status: COMPLETED", content)
            self.assertIn("Progress: 2/2 completed", content)
            self.assertIn("TS › readiness", content)
            self.assertIn("TS › sleep", content)

    def test_build_text_report_shows_running_progress(self):
        result = run_tests.TestResult(
            name="TS › readiness",
            passed=True,
            duration=1.5,
            stdout="stdout details",
            stderr="",
            exit_code=0,
        )

        content = run_tests.build_text_report(
            [result],
            status="running",
            total_tests=3,
        )

        self.assertIn("Status: RUNNING", content)
        self.assertIn("Progress: 1/3 completed", content)
        self.assertIn("Result: 1/1 tests passed", content)

    def test_print_report_uses_english_result_label(self):
        result = run_tests.TestResult(
            name="TS › readiness",
            passed=True,
            duration=1.5,
            stdout="stdout details",
            stderr="",
            exit_code=0,
        )

        buffer = io.StringIO()
        with redirect_stdout(buffer):
            run_tests.print_report([result])

        output = buffer.getvalue()
        self.assertIn("Result:", output)
        self.assertNotIn("Resultado", output)


class CheckOutputTests(unittest.TestCase):
    def test_check_output_fails_when_stderr_contains_tool_failure(self):
        stdout = "Meaningful analysis output\n" * 10
        stderr = "[MCP] Tool call failed: get_health_metrics — MCP error -32602"

        passed, reason, _, _ = run_tests.check_output(
            stdout=stdout,
            stderr=stderr,
            exit_code=0,
            test_name="TS › readiness",
        )

        self.assertFalse(passed)
        self.assertIn("tool failure", reason.lower())

    def test_check_output_fails_when_execution_summary_is_degraded(self):
        stdout = "Meaningful analysis output\n" * 10
        stderr = (
            "logs before\n"
            f"{run_tests.EXECUTION_SUMMARY_PREFIX}"
            + json.dumps(
                {
                    "tool_calls": 4,
                    "tool_failures": 1,
                    "successful_data_calls": 0,
                    "degraded": True,
                    "auth_ok": True,
                }
            )
        )

        passed, reason, _, _ = run_tests.check_output(
            stdout=stdout,
            stderr=stderr,
            exit_code=0,
            test_name="TS › readiness",
        )

        self.assertFalse(passed)
        self.assertIn("degraded", reason.lower())

    def test_check_output_passes_with_clean_execution_summary(self):
        stdout = "Meaningful analysis output\n" * 10
        stderr = (
            f"{run_tests.EXECUTION_SUMMARY_PREFIX}"
            + json.dumps(
                {
                    "tool_calls": 4,
                    "tool_failures": 0,
                    "successful_data_calls": 2,
                    "degraded": False,
                    "auth_ok": True,
                }
            )
        )

        passed, reason, _, _ = run_tests.check_output(
            stdout=stdout,
            stderr=stderr,
            exit_code=0,
            test_name="TS › readiness",
        )

        self.assertTrue(passed)
        self.assertEqual(reason, "")

    def test_parse_execution_trace_returns_last_trace(self):
        stderr = "\n".join(
            [
                "logs before",
                f"{run_tests.EXECUTION_TRACE_PREFIX}{json.dumps({'event': 'model_request_start', 'step': 1})}",
                f"{run_tests.EXECUTION_TRACE_PREFIX}{json.dumps({'event': 'tool_end', 'tool': 'get_health_metrics'})}",
            ]
        )

        trace = run_tests.parse_execution_trace("", stderr)

        self.assertEqual(trace, {"event": "tool_end", "tool": "get_health_metrics"})


class RunTestTimeoutTests(unittest.TestCase):
    def test_run_test_preserves_partial_output_and_last_trace_on_timeout(self):
        timeout_error = subprocess.TimeoutExpired(
            cmd=["python", "fake.py"],
            timeout=run_tests.TIMEOUT,
            output="partial stdout",
            stderr=(
                "partial stderr\n"
                f"{run_tests.EXECUTION_TRACE_PREFIX}"
                + json.dumps({"event": "model_request_start", "step": 2})
            ),
        )

        with patch.object(run_tests.subprocess, "run", side_effect=timeout_error):
            result = run_tests.run_test(
                name="TS › chat",
                cmd=["python", "fake.py"],
                cwd=Path.cwd(),
                stdin_text="",
                env={},
            )

        self.assertFalse(result.passed)
        self.assertEqual(result.stdout, "partial stdout")
        self.assertIn("partial stderr", result.stderr)
        self.assertEqual(result.last_trace, {"event": "model_request_start", "step": 2})
        self.assertIn("last trace: model_request_start (step=2)", result.failure_reason)


if __name__ == "__main__":
    unittest.main()
