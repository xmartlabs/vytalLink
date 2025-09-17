enum BackendMessageType {
  healthDataRequest('health_data_request'),
  connectionCode('connection_code'),
  unknown('unknown');

  const BackendMessageType(this.value);

  final String value;

  static BackendMessageType fromString(String value) =>
      BackendMessageType.values.firstWhere(
        (type) => type.value == value,
        orElse: () => BackendMessageType.unknown,
      );
}
