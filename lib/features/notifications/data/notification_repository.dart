import 'dart:convert';
import 'package:soloforte_app/core/services/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/notification_model.dart';

class NotificationRepository {
  static const String _notificationsKey = 'soloforte_notifications';

  // Carregar notificações
  Future<List<NotificationModel>> loadNotifications() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_notificationsKey);

      if (jsonString == null) {
        // Retornar notificações mockadas para desenvolvimento
        return _getMockNotifications();
      }

      final decoded = jsonDecode(jsonString) as List;
      return decoded
          .cast<Map<String, dynamic>>()
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      LoggerService.e(
        'Erro ao carregar notificações',
        error: e,
        tag: 'NOTIFICATIONS',
      );
      return _getMockNotifications();
    }
  }

  // Salvar notificações
  Future<void> saveNotifications(List<NotificationModel> notifications) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = notifications.map((n) => n.toJson()).toList();
      await prefs.setString(_notificationsKey, jsonEncode(jsonList));
    } catch (e) {
      LoggerService.e(
        'Erro ao salvar notificações',
        error: e,
        tag: 'NOTIFICATIONS',
      );
    }
  }

  // Marcar como lida
  Future<void> markAsRead(String notificationId) async {
    final notifications = await loadNotifications();
    final updated = notifications.map((n) {
      if (n.id == notificationId) {
        return n.copyWith(isRead: true);
      }
      return n;
    }).toList();
    await saveNotifications(updated);
  }

  // Marcar todas como lidas
  Future<void> markAllAsRead() async {
    final notifications = await loadNotifications();
    final updated = notifications.map((n) => n.copyWith(isRead: true)).toList();
    await saveNotifications(updated);
  }

  // Adicionar notificação
  Future<void> addNotification(NotificationModel notification) async {
    final notifications = await loadNotifications();
    notifications.insert(0, notification);

    // Manter apenas últimas 100 notificações
    if (notifications.length > 100) {
      notifications.removeRange(100, notifications.length);
    }

    await saveNotifications(notifications);
  }

  // Limpar todas
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_notificationsKey);
  }

  // Notificações mockadas para desenvolvimento
  List<NotificationModel> _getMockNotifications() {
    return [
      NotificationModel(
        id: '1',
        title: 'Bem-vindo ao SoloForte!',
        message: 'Explore todas as funcionalidades do app',
        type: NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      ),
      NotificationModel(
        id: '2',
        title: 'Alerta de Clima',
        message: 'Previsão de chuva para amanhã',
        type: NotificationType.warning,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        actionRoute: '/clima',
      ),
      NotificationModel(
        id: '3',
        title: 'Novo Relatório Disponível',
        message: 'Relatório de NDVI da Fazenda Esperança',
        type: NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
        actionRoute: '/relatorios',
      ),
      NotificationModel(
        id: '4',
        title: 'Praga Detectada',
        message: 'Possível infestação no Talhão 3',
        type: NotificationType.error,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        actionRoute: '/pragas',
      ),
    ];
  }
}
