// main.dart 파일
import 'dart:async';

import 'package:app/store/Profile/profile_image.dart';
import 'package:app/store/diary/skin_picture_store.dart';
import 'package:app/store/notification/noti.dart';
import 'package:app/utils/time_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart'; // Flutter Provider import
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:app/config/app_routes.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// store
import 'package:app/store/user.dart';
import 'package:app/store/diary/hash_tag.dart';
import 'package:app/store/diary/memo.dart';
import 'package:app/store/diary/my_skin_state.dart';
import 'package:app/components/notification/fcm.dart';
import 'package:app/store/router.dart';
import 'package:app/store/diary/diary_store.dart';
// firestore
import 'package:app/components/notification/firestore.dart';

// firebase
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:app/firebase_options.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// 스타일
import 'package:app/common/style/app_colors.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("Handling a background message title : ${message.notification?.title}");
  print("Handling a background message body : ${message.notification?.body}");
  // print("좀 보자 : ${message.data['id']}");

  fireStoreInit(
    notification: {
      "title": message.notification?.title,
      "body": message.notification?.body,
    },
    data: {"id": message.data['id']},
    type: message.data['type'],
    time: message.data['time'],
    token: message.data['token'],
  );
}

final InAppLocalhostServer localhostServer =
    InAppLocalhostServer(documentRoot: 'assets');

StreamController<String> streamController = StreamController.broadcast();

Future<void> main() async {
  tz.initializeTimeZones();
  WidgetsFlutterBinding.ensureInitialized();
  TimeUtil.setLocalMessages();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    await localhostServer.start();
  }

  if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
    await InAppWebViewController.setWebContentsDebuggingEnabled(kDebugMode);
  }
  var token = await FirebaseMessaging.instance.getToken();

  print("token : ${token ?? 'token NULL!'}");

  /// FCM
  fcmInit();
  await dotenv.load(fileName: '.env');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User()), // 유저정보 및 토큰 관리 Provider
        ChangeNotifierProvider.value(value: HashTag()),
        ChangeNotifierProvider.value(value: Memo()),
        ChangeNotifierProvider.value(value: MySkinData()),
        ChangeNotifierProvider.value(value: Noti()),
        ChangeNotifierProvider.value(value: MySkinPictures()),
        ChangeNotifierProvider.value(value: DiaryProvider()),
        ChangeNotifierProvider.value(value: MainRouter()),
        ChangeNotifierProvider.value(
          value: ProfileImage(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late RemoteMessage foregroundMessage;
  // 토큰 받아오기
  void getMyDeviceToken() async {
    final token = await FirebaseMessaging.instance.getToken();

    print("내 디바이스 토큰: $token");
  }

  // FCM 초기 세팅
  @override
  void initState() {
    getMyDeviceToken();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      RemoteNotification? notification = message.notification;

      if (notification != null) {
        FlutterLocalNotificationsPlugin().show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              "high_importance_notification",
              importance: Importance.max,
            ),
          ),
        );

        setState(() {
          foregroundMessage = message;
          print('Foreground 메세지 수신 : $foregroundMessage');
          print('${foregroundMessage.notification?.title}');
          print('${foregroundMessage.notification?.body}');
          print('id ${foregroundMessage.data['id']}');
          print('type ${foregroundMessage.data['type']}');
          print('time ${foregroundMessage.data['time']}');

          fireStoreInit(
            notification: {
              "title": message.notification?.title,
              "body": message.notification?.body,
            },
            data: {"id": message.data['id']},
            type: message.data['type'],
            time: message.data['time'],
            token: message.data['token'],
          );
        });
      }
    });

    void handleNotificationMessage(RemoteMessage message) {
      print('새로운 onMessageOpenedApp 이벤트가 발생했습니다!');
      print('메시지 데이터: ${message.data}');
      print('터치했습니다.');

      // 클릭된 알림의 데이터를 확인하여 페이지를 결정하고 해당 페이지로 이동
      if (message.data['type'] == 'community') {
        print("백그라운드 이동 한번");
        navigatorKey.currentState?.pushNamed(
          AppRoutes.detail,
          arguments: {'postId': message.data['id'].toString()},
        );
      } else {
        final router = Provider.of<MainRouter>(context, listen: false);
        // 타겟 탭의 인덱스를 설정합니다.
        router.setIndex(0); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
        // MainPage로 이동합니다.
        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.main,
          ModalRoute.withName('/'),
        );
      }
    }

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      handleNotificationMessage(message);
    });
    super.initState();
  }

  @override
  void dispose() {
    streamController.close();
    super.dispose();
  }
  // FCM 초기 세팅

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // 한국 표준 시간으로 설정
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
      ],
      theme: ThemeData(
        fontFamily: 'NotoSansKR',
        scaffoldBackgroundColor: AppColors.white,
        brightness: Brightness.light,
      ),
      initialRoute: AppRoutes.splash, // 최초 접속 페이지는 로그인 페이지
      routes: AppRoutes.pages,
    );
  }
}
