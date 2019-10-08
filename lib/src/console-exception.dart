// console-exception.dart

// Library-specific exception that helps consuming classes separate out issues
// from the library from those that might otherwise be thrown.

/// An exception thrown by the `dart_console` package.
///
/// Refer to the message for specifics on the issue.
class ConsoleException implements Exception {
  final String msg;

  const ConsoleException([this.msg]);

  @override
  String toString() => msg ?? 'ConsoleException';
}
