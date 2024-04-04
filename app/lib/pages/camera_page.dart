import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/config/app_routes.dart';
import 'package:flutter/material.dart';

import 'package:app/components/camera/camera.dart';

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '카메라',
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.serach);
          },
          icon: AppIcons.serach,
        ),
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.myprofile);
          },
          icon: MyProfileImage(),
        ),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: CameraComponent(),
      ),
    );
  }
}
