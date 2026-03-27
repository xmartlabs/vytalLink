extension DateTimeExtensions on DateTime {
  /// Returns the earlier of two DateTime instances
  DateTime min(DateTime other) => isBefore(other) ? this : other;

  /// Returns the later of two DateTime instances
  DateTime max(DateTime other) => isAfter(other) ? this : other;
}
