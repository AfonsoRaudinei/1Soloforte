import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:soloforte_app/core/services/security_service.dart';

class SupportRepository {
  final SupabaseClient _supabase;

  SupportRepository({SupabaseClient? supabase})
    : _supabase = supabase ?? Supabase.instance.client;

  Future<void> sendSupportMessage({
    required String userId,
    required String subject,
    required String message,
  }) async {
    // Rate Limit: 5 messages per hour to prevent spam
    await SecurityService().validateAction(
      'support_message',
      userId: userId,
      limit: 5,
      window: const Duration(hours: 1),
    );

    try {
      await _supabase.from('support_messages').insert({
        'user_id': userId,
        'subject': subject,
        'message': message,
        'status': 'open',
      });

      // Audit Log
      await SecurityService().logSecurityEvent(userId, 'support_sent', {
        'subject': subject,
      });
    } catch (e) {
      throw Exception('Erro ao enviar mensagem: $e');
    }
  }
}
