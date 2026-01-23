import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:workmanager/workmanager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'dart:convert';

/// Serviço para gerenciar background jobs e notificações de relatórios
class ReportSchedulerService {
  static const String _taskName = 'reportGenerationTask';
  static const String _uniqueName = 'soloforte_report_scheduler';

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Inicializa o serviço de agendamento
  Future<void> initialize() async {
    await _initializeNotifications();
    await _initializeWorkManager();
  }

  /// Inicializa notificações locais
  Future<void> _initializeNotifications() async {
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Solicitar permissões no iOS
    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
  }

  /// Inicializa WorkManager
  Future<void> _initializeWorkManager() async {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  }

  /// Agenda verificação periódica de relatórios
  Future<void> schedulePeriodicCheck() async {
    await Workmanager().registerPeriodicTask(
      _uniqueName,
      _taskName,
      frequency: const Duration(hours: 1), // Verifica a cada hora
      constraints: Constraints(networkType: NetworkType.connected),
    );
  }

  /// Cancela todos os agendamentos
  Future<void> cancelAllSchedules() async {
    await Workmanager().cancelAll();
  }

  /// Envia notificação de relatório pronto
  Future<void> showReportReadyNotification({
    required String title,
    required String reportTitle,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'report_channel',
      'Relatórios',
      channelDescription: 'Notificações de relatórios agendados',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      reportTitle,
      details,
      payload: 'report_ready',
    );
  }

  /// Envia notificação de erro
  Future<void> showErrorNotification({
    required String title,
    required String message,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'error_channel',
      'Erros',
      channelDescription: 'Notificações de erros',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _notificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      message,
      details,
      payload: 'error',
    );
  }

  /// Callback quando notificação é tocada
  void _onNotificationTapped(NotificationResponse response) {
    // TODO: Navegar para tela de relatórios
    LoggerService.i('Notification tapped: ${response.payload}', tag: 'REPORTS');
  }
}

/// Callback do WorkManager (deve ser função top-level)
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      await _checkAndGenerateScheduledReports();
      return Future.value(true);
    } catch (e) {
      LoggerService.e('Error in background task', error: e, tag: 'REPORTS');
      return Future.value(false);
    }
  });
}

/// Verifica e gera relatórios agendados
Future<void> _checkAndGenerateScheduledReports() async {
  final prefs = await SharedPreferences.getInstance();
  final savedJson = prefs.getString('report_history');

  if (savedJson == null) return;

  try {
    final Map<String, dynamic> data = json.decode(savedJson);
    final schedules =
        (data['schedules'] as List?)
            ?.map((item) => item as Map<String, dynamic>)
            .toList() ??
        [];

    final now = DateTime.now();
    final scheduler = ReportSchedulerService();

    for (final scheduleData in schedules) {
      final isActive = scheduleData['isActive'] as bool? ?? false;
      if (!isActive) continue;

      final nextRunStr = scheduleData['nextRunAt'] as String?;
      if (nextRunStr == null) continue;

      final nextRun = DateTime.parse(nextRunStr);

      // Se passou do horário, gerar relatório
      if (now.isAfter(nextRun)) {
        final title = scheduleData['title'] as String? ?? 'Relatório';

        // TODO: Implementar geração real do relatório
        // await _generateReport(scheduleData);

        // Enviar notificação
        await scheduler.showReportReadyNotification(
          title: 'Relatório Gerado',
          reportTitle: title,
        );

        // TODO: Atualizar nextRunAt no SharedPreferences
        // TODO: Enviar email se configurado
      }
    }
  } catch (e) {
    LoggerService.e(
      'Error checking scheduled reports',
      error: e,
      tag: 'REPORTS',
    );
  }
}

/// Singleton do serviço
final reportSchedulerService = ReportSchedulerService();
