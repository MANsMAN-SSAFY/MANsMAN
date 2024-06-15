import 'package:app/common/component/app_elevated_button.dart';
import 'package:app/common/component/app_normal_text_field.dart';
import 'package:app/common/component/app_text_field.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class NewNicknameModal extends StatefulWidget {
  const NewNicknameModal({super.key});

  @override
  State<NewNicknameModal> createState() => _NewNicknameModalState();
}

class _NewNicknameModalState extends State<NewNicknameModal> {
  // 닉네임 입력받을 변수
  String? nickname = '';

  @override
  Widget build(BuildContext context) {
    final dio = Dio();

    // 키보드가 열릴 때 바닥 부분의 높이를 동적으로 얻기 위해 MediaQuery를 사용
    double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
// 사용자 정보를 Provider로부터 가져옴
    final userProvider = Provider.of<User>(context, listen: false);
    var provider_nickname = userProvider.profile?['nickname'];
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      width: double.infinity,
      padding: EdgeInsets.only(
          top: 24, left: 24, right: 24, bottom: bottomPadding + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '닉네임을 입력해주세요',
            style: AppTexts.body1,
          ),
          SizedBox(
            height: 16,
          ),
          AppNormalTextField(
            hint: provider_nickname == null ?'닉네임' : '$provider_nickname',
            onChange: (value) {
              setState(() {
                print("버튼 클릭됨");
                nickname = value;
                print(1111111);
                print(nickname);
              });
            },
          ),
          SizedBox(
            height: 16,
          ),
          AppElevatedButton(
            onPressed: () async {
              print("버튼 클릭됨2222222");
              print(nickname);
              final storage = FlutterSecureStorage();
              print("버튼 클릭됨33333333");
              final refreshToken = await storage.read(key: 'REFRESH_TOKEN_KEY');
              final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');

              if (nickname != null) {
                try {
                  Map<String, dynamic> nicknameData = {
                    "nickname": nickname,
                  };
                  print(nicknameData);
                  final response =
                  await dio.patch('https://j10e106.p.ssafy.io/api/members/nicknames',
                      options: Options(
                        headers: {'Authorization': 'Bearer $accessToken'},
                      ),
                      data: nicknameData);
                  print('통신완료');
                  final userProvider =
                  Provider.of<User>(context, listen: false);
                  userProvider.updateNickname(nickname!);
                  print("nickname successful: ${response.data}");
                  Navigator.pop(context, true);
                } on DioException catch (e) {
                  // DioException을 DioError로 수정
                  final response = e.response;
                  if (response != null) {
                    print("Server responded with: ${response.data}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('닉네임 저장 실패: ${response.data}')),
                    );
                  } else {
                    print("Error occurred: ${e.message}");
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('닉네임 저장 실패: ${e.message}'),
                      ),
                    );
                  }
                } catch (e) {
                  print("닉네임 저장 실패: $e");
                }
              }
            },
            name: '확인',
          ),
        ],
      ),
    );
  }
}
