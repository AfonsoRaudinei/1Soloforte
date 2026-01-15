import 'dart:async';
import 'package:soloforte_app/core/services/audit_service.dart';
import 'package:soloforte_app/core/services/rate_limiter_service.dart';

class SecurityService {
  final AuditService _auditService;

  // Singleton pattern for shared state
  static final SecurityService _instance = SecurityService._internal();

  factory SecurityService() {
    return _instance;
  }

  SecurityService._internal() : _auditService = AuditService();

  final Map<String, RateLimiter> _limiters = {};

  Future<void> validateAction(
    String action, {
    String? userId,
    int limit = 5,
    Duration window = const Duration(minutes: 1),
  }) async {
    // Get or create limiter for this specific action type
    if (!_limiters.containsKey(action)) {
      _limiters[action] = RateLimiter(window: window, maxRequests: limit);
    }

    final limiter = _limiters[action]!;

    // Throttle throws exception if limit exceeded
    await limiter.throttle(userId ?? 'global', () async {
      // Log event if successful (allowed)
      if (userId != null && userId != 'global') {
        // Log to Supabase rate_limit_events
        // We fire and forget to not block UI
        _auditService.logRateLimitEvent(userId, action);
      }
    });
  }

  Future<void> logSecurityEvent(
    String userId,
    String action, [
    Map<String, dynamic>? context,
  ]) async {
    await _auditService.log(userId, action, context: context);
  }
}
