import 'package:flutter_test/flutter_test.dart';
import 'package:soloforte_app/features/notifications/data/notification_repository.dart';
import 'package:soloforte_app/features/notifications/domain/notification_model.dart';
import '../../test_setup.dart';

void main() {
  group('NotificationRepository', () {
    late NotificationRepository repository;

    setUpAll(() => setupTestEnvironment());

    setUp(() {
      repository = NotificationRepository();
    });

    test('loadNotifications returns mock data on first load', () async {
      // Act
      final notifications = await repository.loadNotifications();

      // Assert
      expect(notifications, isNotEmpty);
      expect(notifications.length, greaterThan(0));
    });

    test('saveNotifications persists data', () async {
      // Arrange
      final testNotifications = [
        NotificationModel(
          id: 'test-1',
          title: 'Test Notification',
          message: 'Test message',
          type: NotificationType.info,
          timestamp: DateTime.now(),
          isRead: false,
        ),
      ];

      // Act
      await repository.saveNotifications(testNotifications);
      final loaded = await repository.loadNotifications();

      // Assert
      expect(loaded.length, equals(testNotifications.length));
      expect(loaded.first.title, equals('Test Notification'));
    });

    test('loadNotifications handles errors gracefully', () async {
      // Act & Assert - should not throw
      expect(() => repository.loadNotifications(), returnsNormally);
    });

    test('notifications have all required fields', () async {
      // Act
      final notifications = await repository.loadNotifications();
      final first = notifications.first;

      // Assert
      expect(first.id, isNotNull);
      expect(first.title, isNotEmpty);
      expect(first.message, isNotEmpty);
      expect(first.type, isNotNull);
      expect(first.timestamp, isNotNull);
    });
  });
}
