import 'package:freezed_annotation/freezed_annotation.dart';

enum StatisticType {
  @JsonValue('SUM')
  sum,

  @JsonValue('AVERAGE')
  average;
}
