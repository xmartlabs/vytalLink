# VytalLink Mobile App - Unit Testing Suite

This directory contains a comprehensive unit testing suite for the VytalLink mobile application's core functionalities.

## 📋 Overview

The VytalLink mobile app is a Flutter application that collects health data from Apple HealthKit/Google Health Connect and exposes it through an MCP-compatible WebSocket server. This testing suite ensures the reliability and robustness of all core components.

## 🧪 Test Structure

```
test/
├── unit/                           # Unit tests organized by module
│   ├── core/
│   │   ├── health/                # Health data processing components
│   │   │   ├── health_data_aggregator_test.dart
│   │   │   ├── health_data_mapper_test.dart
│   │   │   └── health_permissions_guard_test.dart
│   │   ├── service/               # Core services
│   │   │   └── health_data_manager_test.dart
│   │   ├── source/                # External integrations
│   │   │   └── mcp_server_test.dart
│   │   └── model/                 # Data models and serialization
│   │       ├── health_data_point_test.dart
│   │       ├── health_data_request_test.dart
│   │       └── health_data_response_test.dart
│   ├── ui/                        # UI and state management
│   │   └── home/
│   │       └── home_cubit_test.dart
│   └── di/                        # Dependency injection
│       └── di_provider_test.dart
├── integration/                    # Integration tests
│   └── health_data_flow_test.dart
├── helpers/                       # Test utilities and mocks
│   ├── mock_health_client.dart
│   ├── mock_websocket.dart
│   └── test_data_factory.dart
├── test_utils.dart                # Common test utilities
├── simple_test.dart              # Basic framework verification
├── all_tests.dart                # Test runner
└── README.md                     # This file
```

## 🎯 Test Coverage Areas

### **Core Business Logic (Priority 1)**

#### **HealthDataAggregator**

- ✅ Time segment generation (hourly, daily, weekly, monthly)
- ✅ Instantaneous data aggregation (heart rate, blood pressure)
- ✅ Cumulative data aggregation (steps, distance, calories)
- ✅ Sessional data aggregation (workouts, sleep sessions)
- ✅ Durational data aggregation (sleep duration)
- ✅ Source-based vs unified aggregation
- ✅ Edge cases: overlapping periods, timezone handling, empty data

#### **HealthDataManager**

- ✅ Health data request processing flow
- ✅ Time range validation (start < end, no future dates)
- ✅ Permission checking and error handling
- ✅ Data aggregation flow control
- ✅ Integration with multiple health data sources
- ✅ Error handling for missing permissions and invalid data

#### **HealthDataMapper**

- ✅ Health data transformation between platform formats
- ✅ Numeric, workout, and nutrition value mapping
- ✅ Source ID extraction with fallback logic
- ✅ Date formatting to ISO8601 strings
- ✅ Handling of various health data types and units

### **Communication Layer (Priority 2)**

#### **HealthMcpServerService**

- ✅ WebSocket connection management and lifecycle
- ✅ Message parsing and routing
- ✅ Health data request message handling
- ✅ Connection code message processing
- ✅ Error message generation and handling
- ✅ Callback mechanism testing

#### **HealthPermissionsGuard**

- ✅ Platform-specific permission handling (Android/iOS)
- ✅ Health Connect availability checking
- ✅ Permission request flow and validation
- ✅ History authorization handling
- ✅ Error handling for permission denial scenarios

### **State Management (Priority 3)**

#### **HomeCubit**

- ✅ Initial state setup and network configuration
- ✅ Server start/stop lifecycle management
- ✅ Permission checking and request flow
- ✅ Connection monitoring and error detection
- ✅ State transitions and error recovery
- ✅ Resource management (timers, wakelocks)

### **Data Models (Priority 4)**

#### **Model Serialization Tests**

- ✅ JSON serialization/deserialization for all models
- ✅ HealthDataRequest validation and edge cases
- ✅ HealthDataResponse with various data types
- ✅ AppHealthDataPoint polymorphism (raw vs aggregated)
- ✅ Error response handling
- ✅ Round-trip serialization integrity

## 🛠 Test Infrastructure

### **Dependencies Used**

- `flutter_test` - Core Flutter testing framework
- `bloc_test` - BLoC/Cubit testing utilities
- `mocktail` - Advanced mocking framework
- `integration_test` - Integration testing support

### **Mock Objects & Test Doubles**

- **MockHealth** - Health plugin mock for testing health data access
- **MockHealthDataPoint** - Health data point mock with configurable values
- **TestWebSocketChannel** - WebSocket simulation for MCP server testing
- **TestDataFactory** - Factory for creating consistent test data
- **MockHealthValue variants** - Different health value type mocks

### **Test Utilities**

- **TestUtils** - Common utility functions for async testing, date handling
- **HealthDataMatchers** - Custom matchers for health data validation
- **WebSocketTestMessageFactory** - Factory for WebSocket test messages

## 🚀 Running Tests

### Run All Tests

```bash
flutter test
```

### Run Specific Test Files

```bash
flutter test test/unit/core/health/health_data_aggregator_test.dart
flutter test test/unit/core/service/health_data_manager_test.dart
flutter test test/integration/health_data_flow_test.dart
```

### Run Tests with Coverage

```bash
flutter test --coverage
```

### Run Simple Framework Test

```bash
flutter test test/simple_test.dart
```

### Run All Tests via Test Runner

```bash
flutter test test/all_tests.dart
```

## 📊 Test Coverage Goals

- **Target Overall Coverage**: 85%+
- **Core Business Logic**: 95%+ (HealthDataManager, HealthDataAggregator)
- **Communication Layer**: 90%+ (MCP Server, Permissions)
- **State Management**: 85%+ (Cubits, State Objects)
- **Data Models**: 90%+ (Serialization, Validation)

## 🔍 Key Testing Scenarios

### **Complex Aggregation Logic**

- Multi-source data aggregation with different time intervals
- Overlapping time ranges and proportional allocation
- Cross-day data aggregation with proper time zone handling
- Empty time segments and boundary conditions

### **Error Handling & Recovery**

- Permission denied scenarios and graceful degradation
- Network disconnection and reconnection handling
- Invalid data format processing and sanitization
- Health Connect unavailability and fallback behavior

### **Real-World Edge Cases**

- Large datasets (1000+ data points) and performance
- Malformed health data and error recovery
- Concurrent request handling and race conditions
- Memory management and resource cleanup

## 🧩 Integration Testing

The integration tests verify end-to-end data flow:

1. **Health Data Collection** → **Processing** → **Aggregation** → **MCP Response**
2. **Permission Management** → **Data Access** → **Transformation** → **Serialization**
3. **WebSocket Communication** → **Message Handling** → **Error Recovery**

### Important: Mock-Based vs Real On-Device Tests

The tests in `test/integration/` (run by `scripts/integration_test.sh`) are
**mock-based flow tests**, not real hardware integration tests. They use
simulated health data and do not connect to a real device, Apple HealthKit, or
Google Health Connect.

Specifically:
- `health_data_flow_test.dart` uses a mocked `health` plugin — no HealthKit or
  Health Connect permissions are requested or exercised.
- These tests can run in any CI environment without a physical device.

For real on-device validation (i.e., reading actual data from HealthKit or
Health Connect), a physical iOS or Android device is required. Such tests
cannot be automated in standard CI pipelines without dedicated hardware runners
and are not currently part of this suite.

## 📝 Adding New Tests

### For New Components

1. Create test file following naming convention: `component_name_test.dart`
2. Add to appropriate directory under `test/unit/`
3. Use existing mocks and test utilities where possible
4. Follow the established test structure and naming patterns

### For New Features

1. Add integration test scenarios in `health_data_flow_test.dart`
2. Create feature-specific mocks if needed in `test/helpers/`
3. Update `all_tests.dart` to include new test files
4. Ensure test coverage meets project standards

## 🔧 Troubleshooting

### Common Issues

- **Mock conflicts**: Ensure mock registration in setUp() methods
- **Async test timeouts**: Use `TestUtils.waitForCondition()` for complex async operations
- **State pollution**: Reset mocks and state in tearDown() methods
- **Platform differences**: Use platform-specific test conditions where needed

### Test Debugging

- Use `debugger()` statements for breakpoints
- Add verbose logging with `print()` statements
- Run single tests in isolation to identify issues
- Check mock verification calls for interaction testing

## 📈 Future Enhancements

- [ ] Performance benchmarking tests
- [ ] Fuzz testing for data validation
- [ ] Golden file tests for UI components
- [ ] End-to-end testing with real health data
- [ ] Continuous integration pipeline integration
- [ ] Test report generation and metrics tracking

---

## 🎯 Testing Philosophy

This testing suite follows these key principles:

1. **Comprehensive Coverage** - Test all critical paths and edge cases
2. **Fast Feedback** - Tests should run quickly and provide immediate feedback
3. **Reliable & Deterministic** - Tests should produce consistent results
4. **Maintainable** - Test code should be clean and easy to understand
5. **Realistic** - Tests should simulate real-world usage scenarios

The goal is to ensure VytalLink's core health data processing pipeline is robust, reliable, and ready for production use across different platforms and edge cases.
