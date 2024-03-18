import 'package:flutter/material.dart';
import 'package:app/components/toolbar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Toolbar(title: '알람'),
      body: Padding(
        padding: const EdgeInsets.all(24),
      ),
    );
  }
}
