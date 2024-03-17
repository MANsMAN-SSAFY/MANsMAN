import 'package:flutter/material.dart';
import 'package:msm/components/toolbar.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(child: Text('카메라'),),
      ),
    );
  }
}