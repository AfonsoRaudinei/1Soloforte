import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:soloforte_app/core/services/logger_service.dart';

class PushNotificationService {
  static final PushNotificationService _instance =
      PushNotificationService._internal();

  factory PushNotificationService() {
    return _instance;
  }

  PushNotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    // Request permission (iOS/Web)
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      LoggerService.i('User granted permission', tag: 'NOTIF');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      LoggerService.i('User granted provisional permission', tag: 'NOTIF');
    } else {
      LoggerService.w(
        'User declined or has not accepted permission',
        tag: 'NOTIF',
      );
      return;
    }

    // Get FCM Token
    String? token = await _firebaseMessaging.getToken();
    LoggerService.d('FCM Token: $token', tag: 'NOTIF');

    // Setup Local Notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      LoggerService.d('Got a message whilst in the foreground!', tag: 'NOTIF');
      LoggerService.d('Message data: ${message.data}', tag: 'NOTIF');

      if (message.notification != null) {
        LoggerService.d(
          'Message also contained a notification: ${message.notification?.title}',
          tag: 'NOTIF',
        );
        _showLocalNotification(message);
      }
    });
  }

  void _showLocalNotification(RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'channel_id',
            'channel_name',
            channelDescription: 'channel_description',
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }
}
