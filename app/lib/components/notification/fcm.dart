import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:app/config/app_routes.dart';

late final AndroidNotificationChannel channel;
late final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> fcmInit() async {
  // Android 버전 8 (API 26) 이상부터는 채널 설정이 필수
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    description:
        'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  var initialzationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  var initializationSettings =
      InitializationSettings(android: initialzationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) {
    navigatorKey.currentState?.pushNamed(AppRoutes.notifications);
  });

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  /// FCM 토큰 값
  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    return token;
  }
}

/// FCM Message 형태 설정
void flutterNotificationShow(RemoteMessage message) {
  flutterLocalNotificationsPlugin.show(
    message.hashCode,
    message.data['title'].toString(),
    message.data['body'].toString(),

    // message.notification?.title.toString(),
    // message.notification?.body.toString(),
    NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        icon: 'app_icon', // 알람 앱바 이미지
        largeIcon: const DrawableResourceAndroidBitmap(
            '@drawable/app_icon'), // 알람 내 이미지
      ),
    ),
  );
}
