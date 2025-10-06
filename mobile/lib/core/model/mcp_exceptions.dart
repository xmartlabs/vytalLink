class HealthMcpServerException implements Exception {
  const HealthMcpServerException(this.message, [this.cause]);

  final String message;
  final dynamic cause;

  @override
  String toString() => 'HealthMcpServerException: $message'
      '${cause != null ? ' (Cause: $cause)' : ''}';
}

class HealthPermissionException extends HealthMcpServerException {
  const HealthPermissionException(super.message, [super.cause]);
}

class HealthDataUnavailableException extends HealthMcpServerException {
  const HealthDataUnavailableException(super.message, [super.cause]);
}
