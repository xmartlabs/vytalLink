import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

class MockHealthValue extends Mock implements HealthValue {
  final String? _stringValue;
  MockHealthValue([this._stringValue]);

  @override
  String toString() => _stringValue ?? 'MockHealthValue';
}

class TestHealthValue extends Mock implements HealthValue {
  final String stringValue;
  TestHealthValue(this.stringValue);

  @override
  String toString() => stringValue;
}
