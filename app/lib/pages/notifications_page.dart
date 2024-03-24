import 'package:app/common/default_layout/default_layout.dart';
import 'package:flutter/material.dart';
import 'package:app/components/notification/notification.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '알림',
      child: NotificationComponent(),
    );
  }
}
