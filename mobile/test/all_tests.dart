import 'integration/health_data_flow_test.dart' as health_data_flow_test;
import 'unit/core/health/health_data_aggregator_sleep_dates_test.dart'
    as health_data_aggregator_sleep_dates_test;
import 'unit/core/health/health_sleep_session_normalizer_adjustment_test.dart'
    as health_sleep_session_normalizer_adjustment_test;
import 'unit/core/model/health_data_point_test.dart' as health_data_point_test;
import 'unit/core/model/health_data_request_test.dart'
    as health_data_request_test;
import 'unit/core/model/health_data_response_test.dart'
    as health_data_response_test;
import 'unit/core/model/workout_summary_data_test.dart'
    as workout_summary_data_test;
import 'unit/core/service/health_data_manager_test.dart'
    as health_data_manager_test;
import 'unit/core/source/mcp_server_test.dart' as mcp_server_test;
import 'unit/ui/home/home_cubit_test.dart' as home_cubit_test;

void main() {
  // Health data tests
  health_data_aggregator_sleep_dates_test.main();
  health_sleep_session_normalizer_adjustment_test.main();
  health_data_manager_test.main();
  workout_summary_data_test.main();

  // MCP server tests
  mcp_server_test.main();

  // Model tests
  health_data_point_test.main();
  health_data_request_test.main();
  health_data_response_test.main();

  // UI tests
  home_cubit_test.main();

  // Integration tests
  health_data_flow_test.main();
}
