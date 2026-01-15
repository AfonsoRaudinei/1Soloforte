import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class AuditService {
  final SupabaseClient _supabase;

  AuditService({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  /// Log a critical event to `audit_logs`
  Future<void> log(
    String userId,
    String action, {
    Map<String, dynamic>? context,
  }) async {
    try {
      await _supabase.from('audit_logs').insert({
        'user_id': userId,
        'action': action,
        'context_json': context ?? {},
        // created_at is auto-generated
      });
    } catch (e) {
      debugPrint('Audit Log Failed: $e'); // Fail safe, don't crash app
    }
  }

  /// Log a rate-limited action attempt to `rate_limit_events`
  Future<void> logRateLimitEvent(String? userId, String action) async {
    if (userId == null) {
      return; // Can't log without user_id if table requires it
    }
    try {
      await _supabase.from('rate_limit_events').insert({
        'user_id': userId,
        'action': action,
        'occurred_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      // Ignore errors (fire and forget)
      debugPrint('Rate Limit Event Log Failed: $e');
    }
  }
}
