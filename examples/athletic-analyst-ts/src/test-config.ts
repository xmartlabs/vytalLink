/**
 * Test infrastructure — centralizes test-mode flags and helpers.
 * Active only when ATHLETIC_ANALYST_TEST_MODE=1 (used by the integration test runner).
 */

import type { ExecutionSummary } from "./mcp-bridge.js";

export const TEST_MODE = process.env.ATHLETIC_ANALYST_TEST_MODE === "1";

export const EXECUTION_SUMMARY_PREFIX = "EXECUTION_SUMMARY: ";

export function emitTestSummary(summary: ExecutionSummary): void {
  if (!TEST_MODE) return;
  console.error(`${EXECUTION_SUMMARY_PREFIX}${JSON.stringify(summary)}`);
}
