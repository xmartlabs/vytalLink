
import 'unit/core/health/health_data_aggregator_test.dart'
    as health_data_aggregator_test;
import 'unit/core/health/health_data_mapper_test.dart'
    as health_data_mapper_test;
import 'unit/core/health/health_permissions_guard_test.dart'
    as health_permissions_guard_test;
import 'unit/core/health/health_sleep_session_normalizer_test.dart'
    as health_sleep_session_normalizer_test;

import 'unit/core/service/health_data_manager_test.dart'
    as health_data_manager_test;

import 'unit/core/source/mcp_server_test.dart' as mcp_server_test;

import 'unit/core/model/health_data_point_test.dart' as health_data_point_test;
import 'unit/core/model/health_data_request_test.dart'
    as health_data_request_test;
import 'unit/core/model/health_data_response_test.dart'
    as health_data_response_test;

import 'unit/ui/home/home_cubit_test.dart' as home_cubit_test;

import 'integration/health_data_flow_test.dart' as health_data_flow_test;

void main() {
  health_data_aggregator_test.main();
  health_data_mapper_test.main();
  health_permissions_guard_test.main();
  health_sleep_session_normalizer_test.main();
  health_data_manager_test.main();

  mcp_server_test.main();

  health_data_point_test.main();
  health_data_request_test.main();
  health_data_response_test.main();

  home_cubit_test.main();

  health_data_flow_test.main();
}
