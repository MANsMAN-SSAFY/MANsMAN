import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:flutter/material.dart';

class DefaultLayout extends StatelessWidget {
  final Color? backgroundColor;
  final Color? appBarBackgroundColor;
  final Widget child;
  final String? title;
  final Color titleColor;
  final List<Widget>? actions;
  final Widget? bottomNavigationBar;
  const DefaultLayout(
      {super.key,
      required this.child,
      this.backgroundColor,
      this.title,
      this.titleColor = AppColors.black,
      this.actions,
      this.bottomNavigationBar,
      this.appBarBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: backgroundColor ?? AppColors.white,
      appBar: renderAppBar(),
      body: child,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  AppBar? renderAppBar() {
    if (title == null) {
      return null;
    } else {
      return AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: appBarBackgroundColor ?? AppColors.white,
        foregroundColor: titleColor,
        title: Text(title!, style: AppTexts.header1),
        centerTitle: false,
        actions: actions,
      );
    }
  }
}
