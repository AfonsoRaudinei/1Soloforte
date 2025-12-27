import 'dart:developer' as developer;

class LoggerService {
  static void i(String message, {String? tag}) {
    developer.log(message, name: tag ?? 'INFO', level: 800);
  }

  static void w(String message, {String? tag, Object? error}) {
    developer.log(message, name: tag ?? 'WARN', level: 900, error: error);
  }

  static void e(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    developer.log(
      message,
      name: tag ?? 'ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
