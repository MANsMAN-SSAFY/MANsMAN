import 'package:app/common/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:app/common/style/app_texts.dart';

class AppTextbutton extends StatefulWidget {
  final String category;
  const AppTextbutton({super.key, required this.category});

  @override
  State<AppTextbutton> createState() => _AppTextbuttonState();
}

class _AppTextbuttonState extends State<AppTextbutton> {
  // button 클릭시, 색 변경
  bool _isClicked = false;

  void _toggleButtonState() {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _isClicked
          ? BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.black,
                  width: 2,
                ),
              ),
            )
          : null,
      child: TextButton(
        style: ButtonStyle(
          overlayColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              return AppColors.white;
            },
          ),
          foregroundColor: MaterialStateProperty.resolveWith<Color>(
            (Set<MaterialState> states) {
              if (_isClicked) {
                return AppColors.black;
              } else {
                return AppColors.iconBlack.withOpacity(0.6);
              }
            },
          ),
        ),
        onPressed: () {
          _toggleButtonState();
        },
        child: Text(
          widget.category,
          style: AppTexts.body3,
        ),
      ),
    );
  }
}
