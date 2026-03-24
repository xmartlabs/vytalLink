import { TEST_MODE } from "./test-config.js";

export const EXECUTION_TRACE_PREFIX = "EXECUTION_TRACE: ";

export type ExecutionTraceEvent = {
  event: string;
  timestamp: string;
  elapsed_ms: number;
  [key: string]: unknown;
};

export type ExecutionTracer = {
  trace: (event: string, details?: Record<string, unknown>) => void;
};

export function createExecutionTracer(): ExecutionTracer {
  const start = Date.now();

  return {
    trace(event: string, details: Record<string, unknown> = {}): void {
      if (!TEST_MODE) return;

      const payload: ExecutionTraceEvent = {
        event,
        timestamp: new Date().toISOString(),
        elapsed_ms: Date.now() - start,
        ...details,
      };

      console.error(`${EXECUTION_TRACE_PREFIX}${JSON.stringify(payload)}`);
    },
  };
}
