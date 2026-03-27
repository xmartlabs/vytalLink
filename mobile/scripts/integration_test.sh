#!/bin/bash
# NOTE: This script runs mock-based integration tests (no real device or HealthKit/Health Connect).
# These tests validate the data flow with simulated health data.
# For real on-device validation, see: TODO - add on-device test script

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

if [ "$#" -gt 0 ]; then
  TARGET_TEST="$1"
  shift
else
  TARGET_TEST="test/integration/health_data_flow_test.dart"
fi

cd "${PROJECT_ROOT}"
fvm flutter test "${TARGET_TEST}" "$@"
