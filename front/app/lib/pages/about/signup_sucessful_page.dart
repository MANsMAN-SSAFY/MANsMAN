// 패키지
import 'package:flutter/material.dart';
import 'package:app/styles/app_colors.dart';

class SignupSucessfulPage extends StatelessWidget {
  const SignupSucessfulPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
            color: AppColors.blue,
            child: Center(child: Text('만나서 반가워요!', style: TextStyle(fontSize: 45, fontWeight: FontWeight.w700, color: AppColors.background),)),
          ),
    );
  }
}
