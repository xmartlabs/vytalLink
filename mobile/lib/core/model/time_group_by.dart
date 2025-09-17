import 'package:freezed_annotation/freezed_annotation.dart';

enum TimeGroupBy {
  @JsonValue('HOUR')
  hour,

  @JsonValue('DAY')
  day,

  @JsonValue('WEEK')
  week,

  @JsonValue('MONTH')
  month;
}
