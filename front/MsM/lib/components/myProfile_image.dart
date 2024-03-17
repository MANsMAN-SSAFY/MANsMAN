import 'package:flutter/material.dart';

class MyProfileImage extends StatelessWidget {
  final double size;
  const MyProfileImage({super.key, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.asset(
        'assets/images/wony.jpg',
        width: size,
        height: size,
        fit: BoxFit.cover,
      ),
    );
  }
}
