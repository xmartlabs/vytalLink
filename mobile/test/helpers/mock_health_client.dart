import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

class MockHealth extends Mock implements Health {}


class MockNumericHealthValue extends Mock implements NumericHealthValue {
  @override
  final num numericValue;

  MockNumericHealthValue(this.numericValue);
}
