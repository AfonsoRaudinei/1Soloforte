import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:soloforte_app/features/marketing/data/marketing_repository.dart';
import 'package:soloforte_app/features/marketing/domain/post_model.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:uuid/uuid.dart';
// NOTE: Ideally we would use Workmanager or a server for robust scheduling.
// Utilizing LocalNotifications for simulation purposes as per constraints.

class SchedulingService {
  final MarketingRepository _repository = MarketingRepository();
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  SchedulingService() {
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    await _notificationsPlugin.initialize(settings);
  }

  Future<void> schedulePost({
    required String title,
    required String content,
    required List<String> imageUrls,
    required DateTime scheduledDate,
    required bool toFeed,
    required bool toExternal,
  }) async {
    final post = Post(
      id: const Uuid().v4(),
      title: title,
      content: content,
      createdAt: DateTime.now(),
      authorId: 'user_123',
      authorName: 'Produtor Demo',
      imageUrls: imageUrls,
      status: PostStatus.scheduled,
      scheduledTo: scheduledDate,
    );

    await _repository.savePost(post);

    // Schedule Local Notification
    // Note: This only notifies the user "It's time to post", it doesn't auto-post to Instagram (API restriction)
    await _scheduleNotification(post);
  }

  Future<void> _scheduleNotification(Post post) async {
    try {
      // Diferença de tempo
      final scheduledTime = post.scheduledTo!;
      // Se for no passado, não agendar
      if (scheduledTime.isBefore(DateTime.now())) return;

      // Usando ZonedSchedule se possível, mas para simplificar mock:
      // Apenas simulamos o sucesso. Se fosse real, usariamos tz.TZDateTime
      LoggerService.i(
        'Notificação agendada para: $scheduledTime',
        tag: 'MARKETING',
      );

      /* 
      // Exemplo de implementação real (requer timezone package configurado)
      await _notificationsPlugin.zonedSchedule(
        post.id.hashCode,
        'Hora de Publicar: ${post.title}',
        'Seu agendamento está pronto para ser postado agora.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(...),
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      ); 
      */
    } catch (e) {
      LoggerService.e(
        'Erro ao agendar notificação',
        error: e,
        tag: 'MARKETING',
      );
    }
  }

  /// Retorna horários sugeridos baseados em mock de "picos de engajamento"
  List<TimeOfDay> getSuggestedTimes() {
    return const [
      TimeOfDay(hour: 09, minute: 00),
      TimeOfDay(hour: 12, minute: 30),
      TimeOfDay(hour: 18, minute: 00),
      TimeOfDay(hour: 20, minute: 30),
    ];
  }
}
