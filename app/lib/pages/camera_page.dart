import 'package:app/common/default_layout/default_layout.dart';
import 'package:flutter/material.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '카메라',
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Text('카메라'),
          ),
        ),
      ),
    );
  }
}
