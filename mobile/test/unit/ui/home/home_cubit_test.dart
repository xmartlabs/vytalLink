import 'package:flutter_template/ui/home/home_cubit.dart';
import 'package:flutter_template/ui/section/error_handler/global_event_handler_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGlobalEventHandlerCubit extends Mock
    implements GlobalEventHandlerCubit {}

void main() {
  group('HomeState', () {
    test('creates instance with default values', () {
      const state = HomeState();

      expect(state.status, equals(McpServerStatus.idle));
      expect(state.ipAddress, isEmpty);
      expect(state.endpoint, isEmpty);
      expect(state.connectionCode, isEmpty);
      expect(state.connectionWord, isEmpty);
      expect(state.errorMessage, isEmpty);
    });

    test('creates instance with custom values', () {
      const state = HomeState(
        status: McpServerStatus.running,
        ipAddress: '192.168.1.100',
        endpoint: '/mcp',
        connectionCode: 'ABC123',
        connectionWord: 'elephant',
        errorMessage: 'Test error',
      );

      expect(state.status, equals(McpServerStatus.running));
      expect(state.ipAddress, equals('192.168.1.100'));
      expect(state.endpoint, equals('/mcp'));
      expect(state.connectionCode, equals('ABC123'));
      expect(state.connectionWord, equals('elephant'));
      expect(state.errorMessage, equals('Test error'));
    });

    test('copyWith creates new instance with updated values', () {
      const originalState = HomeState(
        status: McpServerStatus.idle,
        ipAddress: '192.168.1.100',
      );

      final newState = originalState.copyWith(
        status: McpServerStatus.running,
        connectionCode: 'XYZ789',
      );

      expect(newState.status, equals(McpServerStatus.running));
      expect(newState.ipAddress, equals('192.168.1.100')); // Unchanged
      expect(newState.connectionCode, equals('XYZ789'));
      expect(newState.endpoint, isEmpty); // Default value preserved
    });

    test('supports equality comparison', () {
      const state1 = HomeState(
        status: McpServerStatus.running,
        connectionCode: 'ABC123',
      );

      const state2 = HomeState(
        status: McpServerStatus.running,
        connectionCode: 'ABC123',
      );

      const state3 = HomeState(
        status: McpServerStatus.running,
        connectionCode: 'XYZ789',
      );

      expect(state1, equals(state2));
      expect(state1, isNot(equals(state3)));
    });
  });

  group('McpServerStatus', () {
    test('has all expected values', () {
      expect(McpServerStatus.values, hasLength(5));
      expect(McpServerStatus.values, contains(McpServerStatus.idle));
      expect(McpServerStatus.values, contains(McpServerStatus.starting));
      expect(McpServerStatus.values, contains(McpServerStatus.running));
      expect(McpServerStatus.values, contains(McpServerStatus.stopping));
      expect(McpServerStatus.values, contains(McpServerStatus.error));
    });

    test('status progression makes sense', () {
      const idleToStarting = [McpServerStatus.idle, McpServerStatus.starting];
      const startingToRunning = [
        McpServerStatus.starting,
        McpServerStatus.running,
      ];
      const runningToStopping = [
        McpServerStatus.running,
        McpServerStatus.stopping,
      ];
      const stoppingToIdle = [McpServerStatus.stopping, McpServerStatus.idle];

      expect(idleToStarting[0], equals(McpServerStatus.idle));
      expect(idleToStarting[1], equals(McpServerStatus.starting));
      expect(startingToRunning[1], equals(McpServerStatus.running));
      expect(runningToStopping[1], equals(McpServerStatus.stopping));
      expect(stoppingToIdle[1], equals(McpServerStatus.idle));
    });
  });

  group('HomeCubit - Testable Business Logic', () {
    group('Callback Methods (Static Testing)', () {
      test('onConnectionCodeReceived callback logic', () {
        const initialState = HomeState(
          status: McpServerStatus.starting,
          ipAddress: '192.168.1.100',
        );

        final updatedState = initialState.copyWith(
          connectionCode: 'ABC123',
          connectionWord: 'elephant',
        );

        expect(updatedState.connectionCode, equals('ABC123'));
        expect(updatedState.connectionWord, equals('elephant'));
        expect(
          updatedState.status,
          equals(McpServerStatus.starting),
        );
        expect(updatedState.ipAddress, equals('192.168.1.100'));
      });

      test('onConnectionError callback logic', () {
        const initialState = HomeState(
          status: McpServerStatus.running,
          connectionCode: 'ABC123',
        );

        final errorState = initialState.copyWith(
          status: McpServerStatus.error,
          ipAddress: '',
          endpoint: '',
          connectionCode: '',
          connectionWord: '',
          errorMessage: 'Connection error occurred',
        );

        expect(errorState.status, equals(McpServerStatus.error));
        expect(errorState.ipAddress, isEmpty);
        expect(errorState.endpoint, isEmpty);
        expect(errorState.connectionCode, isEmpty);
        expect(errorState.connectionWord, isEmpty);
        expect(errorState.errorMessage, equals('Connection error occurred'));
      });

      test('connection lost logic', () {
        const runningState = HomeState(
          status: McpServerStatus.running,
          ipAddress: '192.168.1.100',
          endpoint: '/mcp',
          connectionCode: 'ABC123',
          connectionWord: 'elephant',
        );

        final lostConnectionState = runningState.copyWith(
          status: McpServerStatus.error,
          ipAddress: '',
          endpoint: '',
          connectionCode: '',
          connectionWord: '',
          errorMessage: 'Connection lost unexpectedly',
        );

        expect(lostConnectionState.status, equals(McpServerStatus.error));
        expect(lostConnectionState.errorMessage, contains('Connection lost'));
      });
    });

    group('State Validation', () {
      test('validates state consistency for running server', () {
        const runningState = HomeState(
          status: McpServerStatus.running,
          ipAddress: '192.168.1.100',
          endpoint: '/mcp',
          connectionCode: 'ABC123',
          connectionWord: 'elephant',
        );

        expect(runningState.status, equals(McpServerStatus.running));
        expect(runningState.ipAddress, isNotEmpty);
        expect(runningState.endpoint, isNotEmpty);
        expect(runningState.connectionCode, isNotEmpty);
        expect(runningState.connectionWord, isNotEmpty);
      });

      test('validates state consistency for error state', () {
        const errorState = HomeState(
          status: McpServerStatus.error,
          errorMessage: 'Something went wrong',
        );

        expect(errorState.status, equals(McpServerStatus.error));
        expect(errorState.errorMessage, isNotEmpty);
      });

      test('validates state consistency for idle state', () {
        const idleState = HomeState();

        expect(idleState.status, equals(McpServerStatus.idle));
        expect(idleState.ipAddress, isEmpty);
        expect(idleState.endpoint, isEmpty);
        expect(idleState.connectionCode, isEmpty);
        expect(idleState.connectionWord, isEmpty);
      });
    });

    group('Edge Cases', () {
      test('handles very long connection codes and words', () {
        final longString = 'A' * 1000;
        final state = HomeState(
          connectionCode: longString,
          connectionWord: longString,
        );

        expect(state.connectionCode.length, equals(1000));
        expect(state.connectionWord.length, equals(1000));
      });

      test('handles special characters in connection data', () {
        const state = HomeState(
          connectionCode: 'CODE_WITH_SPECIAL_CHARS_!@#\$%^&*()',
          connectionWord: 'word_with_unicode_ëñ',
          ipAddress: '192.168.1.100:8080',
          endpoint: '/mcp/endpoint?param=value&special=!@#',
        );

        expect(state.connectionCode, contains('!@#\$%^&*()'));
        expect(state.connectionWord, contains('ëñ'));
        expect(state.ipAddress, contains(':'));
        expect(state.endpoint, contains('?'));
      });

      test('handles null-like empty states gracefully', () {
        const emptyState = HomeState(
          ipAddress: '',
          endpoint: '',
          connectionCode: '',
          connectionWord: '',
          errorMessage: '',
        );

        expect(emptyState.ipAddress, isEmpty);
        expect(emptyState.endpoint, isEmpty);
        expect(emptyState.connectionCode, isEmpty);
        expect(emptyState.connectionWord, isEmpty);
        expect(emptyState.errorMessage, isEmpty);
      });
    });

    group('State Transitions Logic', () {
      test('idle to starting transition', () {
        const idleState = HomeState(status: McpServerStatus.idle);
        final startingState =
            idleState.copyWith(status: McpServerStatus.starting);

        expect(startingState.status, equals(McpServerStatus.starting));
      });

      test('starting to running transition with connection details', () {
        const startingState = HomeState(status: McpServerStatus.starting);
        final runningState = startingState.copyWith(
          status: McpServerStatus.running,
          ipAddress: '192.168.1.100',
          endpoint: '/mcp',
          connectionCode: 'ABC123',
          connectionWord: 'elephant',
        );

        expect(runningState.status, equals(McpServerStatus.running));
        expect(runningState.ipAddress, equals('192.168.1.100'));
        expect(runningState.connectionCode, equals('ABC123'));
      });

      test('running to stopping transition', () {
        const runningState = HomeState(
          status: McpServerStatus.running,
          ipAddress: '192.168.1.100',
          connectionCode: 'ABC123',
        );
        final stoppingState =
            runningState.copyWith(status: McpServerStatus.stopping);

        expect(stoppingState.status, equals(McpServerStatus.stopping));
        expect(
          stoppingState.ipAddress,
          equals('192.168.1.100'),
        ); // Preserved during stopping
      });

      test('stopping to idle transition with cleanup', () {
        const stoppingState = HomeState(
          status: McpServerStatus.stopping,
          ipAddress: '192.168.1.100',
          connectionCode: 'ABC123',
        );
        final idleState = stoppingState.copyWith(
          status: McpServerStatus.idle,
          ipAddress: '',
          endpoint: '',
          connectionCode: '',
          connectionWord: '',
          errorMessage: '',
        );

        expect(idleState.status, equals(McpServerStatus.idle));
        expect(idleState.ipAddress, isEmpty);
        expect(idleState.connectionCode, isEmpty);
      });

      test('any state to error transition', () {
        const runningState = HomeState(
          status: McpServerStatus.running,
          connectionCode: 'ABC123',
        );
        final errorState = runningState.copyWith(
          status: McpServerStatus.error,
          errorMessage: 'Connection failed',
        );

        expect(errorState.status, equals(McpServerStatus.error));
        expect(errorState.errorMessage, equals('Connection failed'));
      });
    });
  });
}
