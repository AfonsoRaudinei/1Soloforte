import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soloforte_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

final analyticsServiceProvider = Provider<AnalyticsService>((ref) {
  return AnalyticsService(ref);
});

class AnalyticsService {
  final Ref _ref;
  final Map<String, DateTime> _flowStartTimes = {};

  AnalyticsService(this._ref);

  bool get _isDemo {
    final authState = _ref.read(authStateProvider).value;
    return authState?.isDemo ?? false;
  }

  void startFlow(String flowName) {
    _flowStartTimes[flowName] = DateTime.now();
    logEvent('${flowName}_started', {'flow': flowName});
  }

  void logEvent(String eventName, [Map<String, dynamic>? properties]) {
    final props = properties ?? {};
    props['isDemo'] = _isDemo;
    props['timestamp'] = DateTime.now().toIso8601String();

    LoggerService.i(
      'ANALYTICS EVENT: $eventName | Props: $props',
      tag: 'ANALYTICS',
    );
  }

  void endFlow(String flowName, {String? result}) {
    final startTime = _flowStartTimes.remove(flowName);
    if (startTime == null) return;

    final duration = DateTime.now().difference(startTime);
    final props = {
      'duration_ms': duration.inMilliseconds,
      'duration_sec': duration.inSeconds,
      'result': result ?? 'completed',
    };

    logEvent('${flowName}_completed', props);
  }
}
