import 'package:flutter/material.dart';
import 'package:app/components/toolbar.dart';
import 'package:app/components/notification/notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: Toolbar(title: '알람'),
      body: NotificationComponent(),
    );
  }
}
