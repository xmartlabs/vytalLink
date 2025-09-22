
// Unit Tests - Core Health
import 'unit/core/health/health_data_aggregator_test.dart'
    as health_data_aggregator_test;
import 'unit/core/health/health_data_mapper_test.dart'
    as health_data_mapper_test;
import 'unit/core/health/health_permissions_guard_test.dart'
    as health_permissions_guard_test;
import 'unit/core/health/health_sleep_session_normalizer_test.dart'
    as health_sleep_session_normalizer_test;

// Unit Tests - Core Service
import 'unit/core/service/health_data_manager_test.dart'
    as health_data_manager_test;

// Unit Tests - Core Source
import 'unit/core/source/mcp_server_test.dart' as mcp_server_test;

// Unit Tests - Core Models
import 'unit/core/model/health_data_point_test.dart' as health_data_point_test;
import 'unit/core/model/health_data_request_test.dart'
    as health_data_request_test;
import 'unit/core/model/health_data_response_test.dart'
    as health_data_response_test;

// Unit Tests - UI
import 'unit/ui/home/home_cubit_test.dart' as home_cubit_test;

// Integration Tests
import 'integration/health_data_flow_test.dart' as health_data_flow_test;

void main() {
  // Core Health Tests
  health_data_aggregator_test.main();
  health_data_mapper_test.main();
  health_permissions_guard_test.main();
  health_sleep_session_normalizer_test.main();
  // Core Service Tests
  health_data_manager_test.main();

  // Core Source Tests
  mcp_server_test.main();

  // Core Model Tests
  health_data_point_test.main();
  health_data_request_test.main();
  health_data_response_test.main();

  // UI Tests
  home_cubit_test.main();

  // Integration Tests
  health_data_flow_test.main();
}
