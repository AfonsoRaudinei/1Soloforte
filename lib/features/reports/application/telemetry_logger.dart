import 'package:soloforte_app/core/services/logger_service.dart';

class TelemetryLogger {
  static final Set<String> _seen = <String>{};

  static void logOnce(String event, {Map<String, String>? context}) {
    final contextEntries = context?.entries.toList() ?? const [];
    contextEntries.sort((a, b) => a.key.compareTo(b.key));
    final contextString = contextEntries
        .map((entry) => '${entry.key}=${entry.value}')
        .join(',');
    final key = contextString.isEmpty ? event : '$event|$contextString';

    if (!_seen.add(key)) return;

    final message = contextString.isEmpty
        ? '[telemetry] $event'
        : '[telemetry] $event {$contextString}';
    LoggerService.i(message, tag: 'TELEMETRY');
  }
}
