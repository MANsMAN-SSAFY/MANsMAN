import 'package:app/common/default_layout/default_layout.dart';
import 'package:flutter/material.dart';

import 'package:app/components/camera/camera.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DefaultLayout(
      title: '카메라',
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(24),
          child: CameraComponent(),
        ),
      ),
    );
  }
}
