import 'package:freezed_annotation/freezed_annotation.dart';

enum StatisticType {
  @JsonValue('COUNT')
  count,

  @JsonValue('AVERAGE')
  average;
}
