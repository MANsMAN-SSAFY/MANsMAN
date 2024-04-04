import 'package:app/common/default_layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:app/components/notification/notification.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<dynamic> notiList = [];

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  void fetchNotifications() async {
    String? token = await FirebaseMessaging.instance.getToken();
    var snapshot = await FirebaseFirestore.instance
        .collection("noti")
        .where("token", isEqualTo: token)
        .get();

    setState(() {
      notiList = snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '알림',
      child: FutureBuilder<String?>(
        future: FirebaseMessaging.instance.getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터가 아직 준비되지 않은 경우 로딩 표시
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // 에러가 발생한 경우
            return Center(child: Text('오류: ${snapshot.error}'));
          } else {
            // 데이터를 정상적으로 받은 경우
            final token = snapshot.data;
            return NotificationComponent(token: token!);
          }
        },
      ),
    );
  }
}
