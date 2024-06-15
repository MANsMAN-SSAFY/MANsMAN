import 'package:app/common/style/app_colors.dart';
import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final String name;
  const AppElevatedButton({
    super.key,
    this.onPressed,
    required this.name,
    this.foregroundColor = AppColors.white,
    this.backgroundColor = AppColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: foregroundColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
        child: Text(
          name,
          style: TextStyle(fontSize: 17),
        ),
      ),
    );
  }
}
