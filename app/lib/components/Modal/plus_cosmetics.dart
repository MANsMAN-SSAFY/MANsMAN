import 'package:app/common/component/app_elevated_button.dart';
import 'package:app/common/component/app_normal_text_field.dart';
import 'package:app/common/component/app_text_field.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/config/app_routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PlusCosmetics extends StatefulWidget {
  const PlusCosmetics({super.key});

  @override
  State<PlusCosmetics> createState() => _NewNicknameModalState();
}

class _NewNicknameModalState extends State<PlusCosmetics> {
  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // 키보드가 열릴 때 바닥 부분의 높이를 동적으로 얻기 위해 MediaQuery를 사용
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    // 닉네임 입력받을 변수
    String nickname = '';

    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      width: double.infinity,
      padding: EdgeInsets.only(top: 24, left: 24, right: 24,  bottom: bottomPadding + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '구매한 또는 사용한 제품을 등록해주세요',
            style: AppTexts.body1,
          ),
          SizedBox(
            height: 16,
          ),
          AppNormalTextField(
            onChange: (value){},
            autocorrect: true, // 자동 완성 기능
            enableSuggestions: true,
            autofocus: false,
            suffixIcon: AppIcons.serach,
            hint: '화장품 검색',
          ),
          SizedBox(
            height: 16,
          ),
          AppElevatedButton(
            onPressed: () {Navigator.pop(context);},
            // async {
            //   print(nickname);
            //   final storage = FlutterSecureStorage();
            //
            //   final refreshToken = await storage.read(key: 'REFRESH_TOKEN_KEY');
            //   final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
            //
            //   if (nickname != null) {
            //     try {
            //
            //       Map<String, dynamic> nicknameData = {
            //         "nickname": nickname,
            //       };
            //
            //       final response = await dio.patch(
            //           '$Ip/members/nicknames', options: Options(headers: {'authorization': 'Bearer $accessToken'},),
            //           data: nicknameData);
            //
            //       Navigator.of(context).pushNamedAndRemoveUntil(
            //           AppRoutes.main, (route) => false);
            //
            //       print("nickname successful: ${response.data}");
            //     } catch (e) {
            //       ScaffoldMessenger.of(context).showSnackBar(
            //         SnackBar(content: Text('닉네임 저장 실패: $e')),
            //       );
            //     }
            //   };
            // },
            name: '등록',
          ),
        ],
      ),
    );
  }
}
