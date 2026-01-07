import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/notification_repository.dart';
import '../../domain/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository();
});

final notificationsProvider =
    StateNotifierProvider<
      NotificationsNotifier,
      AsyncValue<List<NotificationModel>>
    >((ref) {
      final repository = ref.watch(notificationRepositoryProvider);
      return NotificationsNotifier(repository);
    });

final unreadCountProvider = Provider<int>((ref) {
  return ref
      .watch(notificationsProvider)
      .when(
        data: (notifications) => notifications.where((n) => !n.isRead).length,
        loading: () => 0,
        error: (_, __) => 0,
      );
});

class NotificationsNotifier
    extends StateNotifier<AsyncValue<List<NotificationModel>>> {
  final NotificationRepository _repository;

  NotificationsNotifier(this._repository) : super(const AsyncValue.loading()) {
    loadNotifications();
  }

  Future<void> loadNotifications() async {
    state = const AsyncValue.loading();
    try {
      final notifications = await _repository.loadNotifications();
      state = AsyncValue.data(notifications);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> markAsRead(String notificationId) async {
    // 1. Optimistic Update: Atualiza a lista localmente
    state.whenData((notifications) {
      final updatedList = notifications
          .map((n) => n.id == notificationId ? n.copyWith(isRead: true) : n)
          .toList();
      state = AsyncValue.data(updatedList);
    });

    // 2. Persiste em background (falhas podem ser tratadas revertendo)
    try {
      await _repository.markAsRead(notificationId);
      // Não recarregamos tudo aqui para evitar flickering,
      // pois já confiamos na atualização local.
    } catch (e) {
      // Em caso de erro, recarregamos para garantir consistência
      loadNotifications();
    }
  }

  Future<void> markAllAsRead() async {
    // 1. Optimistic Update
    state.whenData((notifications) {
      final updatedList = notifications
          .map((n) => n.copyWith(isRead: true))
          .toList();
      state = AsyncValue.data(updatedList);
    });

    try {
      await _repository.markAllAsRead();
    } catch (e) {
      loadNotifications();
    }
  }

  Future<void> addNotification(NotificationModel notification) async {
    await _repository.addNotification(notification);
    await loadNotifications();
  }

  Future<void> clearAll() async {
    await _repository.clearAll();
    state = const AsyncValue.data([]);
  }
}
