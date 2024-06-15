// 패키지
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/components/Modal/new_nickname_modal.dart';
import 'package:app/pages/login/login_page.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/components/myProfile_image.dart';
import 'package:app/common/style/app_icons.dart';
import 'package:app/common/style/app_strings.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../components/new_profile_modal.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isloading = true;
  Map<String, dynamic>? result;

  Future<Map<String, dynamic>> getProfile() async {
    print('여기 통과');
    final storage = FlutterSecureStorage();
    final Dio dio = Dio();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    String apiUrl = 'https://j10e106.p.ssafy.io/api/members/profiles';
    try {
      final response = await dio.get(
        apiUrl,
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
      );
      print('여기는 통과하나');
      result = response.data as Map<String, dynamic>;
      print(result);
      setState(() {
        result = response.data as Map<String, dynamic>;
        isloading = false;
      });
      return response.data;
    } on DioException catch (e) {
      // 에러 핸들링
      print("Error occurred while fetching search results: ${e.message}");
      return {};
    }
  }

  @override
  void initState() {
    super.initState();
    getProfile();
  }

  @override
  Widget build(BuildContext context) {
    // User 프로바이더에서 프로필 정보 가져오기
    final userProvider = Provider.of<User>(context);
    final imgUrl = userProvider.profile?['imgUrl'];
    final email = result?['email'];
    final nickname = result?['nickname'];
    final privacy = result?['privacy'];
    final birthday = result?['birthday'];
    final faceShape;
    if (result != null &&
        result?['report'] != null &&
        result?['report']['faceShape'] != null) {
      faceShape = result?['report']['faceShape'];
    } else {
      faceShape = null;
    }
    final skinType;
    if (result != null &&
        result?['report'] != null &&
        result?['report']['skinType'] != null) {
      skinType = result?['report']['skinType'];
    } else {
      skinType = null;
    }
    final createdAt = userProvider.profile?['createdAt'];
    DateTime? provider_createdAt;
    if (createdAt != null) {
      provider_createdAt = DateTime.parse(createdAt);
    } else {
      provider_createdAt = DateTime.now();
    }
    // 현재 날짜의 'yyyy-MM-dd' 형식을 구합니다.
    DateTime today = DateTime.now();
    // 현재 날짜에서 시간 부분을 제거합니다(날짜만 사용).
    DateTime todayDateOnly = DateTime(today.year, today.month, today.day);

    // providerString 날짜에서 시간 부분을 제거합니다(날짜만 사용).
    DateTime providerDateOnly = DateTime(provider_createdAt.year,
        provider_createdAt.month, provider_createdAt.day);

    // 두 날짜의 차이를 계산합니다.
    Duration difference = todayDateOnly.difference(providerDateOnly);

    // 두 날짜에다가 더하기 1
    Duration differencePlusOne = difference + Duration(days: 1);

    final Map<String, String> translatedTypes = {
      "NORMAL": "복합성",
      "OILY": "지성",
      "DRY": "건성"
    };

    return DefaultLayout(
      title: '설정',
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 8,
                      bottom: 8,
                    ),
                    child: MyProfileImage(
                      size: 150,
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: AppColors.blue,
                              borderRadius: BorderRadius.all(
                                Radius.circular(100),
                              ),
                            ),
                            child: AppIcons.camera2),
                        onPressed: () async {
                          final result = await showModalBottomSheet<bool>(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (context) => NewProfileModal(),
                          );
                          if (result == true) {
                            await getProfile(); // 프로필 정보를 다시 불러오는 메서드 호출
                            // UI를 갱신하기 위해 setState를 호출할 수 있습니다.
                            setState(() {});
                          }
                          ;
                        },
                      )),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '${nickname}님,',
                        style: AppTexts.body2,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppStrings.setting_string1,
                        style: AppTexts.body3,
                      ),
                      Text(
                        ' ${differencePlusOne.inDays}',
                        style: AppTexts.body2,
                      ),
                      Text(
                        AppStrings.setting_string2,
                        style: AppTexts.body3,
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                AppStrings.information,
                style: AppTexts.body1,
              ),
              SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.nickname,
                    style: AppTexts.body3,
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // 패딩을 0으로 설정
                      tapTargetSize: MaterialTapTargetSize
                          .shrinkWrap, // 버튼의 탭 크기를 내용에 맞게 조절
                    ),
                    onPressed: () async {
                      // showModalBottomSheet의 결과를 기다립니다.
                      final result = await showModalBottomSheet<bool>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: AppColors.white,
                        builder: (context) => NewNicknameModal(),
                      );

                      // 닉네임 변경 모달에서 true를 반환했다면, 프로필 정보를 새로고침합니다.
                      if (result == true) {
                        await getProfile(); // 프로필 정보를 다시 불러오는 메서드 호출
                        // UI를 갱신하기 위해 setState를 호출할 수 있습니다.
                        setState(() {});
                      }
                    },
                    child: Text(
                      '$nickname',
                      style: AppTexts.body2.copyWith(color: AppColors.blue),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.email,
                    style: AppTexts.body3,
                  ),
                  Text(
                    '$email',
                    style: AppTexts.body2,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.birth,
                    style: AppTexts.body3,
                  ),
                  Text(
                    '$birthday',
                    style: AppTexts.body2,
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.isPrivate,
                    style: AppTexts.body3,
                  ),
                  CupertinoSwitch(
                    activeColor: AppColors.blue,
                    value: privacy ?? false,
                    onChanged: (bool value) {
                      _updatePrivacySetting(value);
                      getProfile();
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.faceshape,
                    style: AppTexts.body3,
                  ),
                  skinType != null
                      ? Text(
                          "${translatedTypes[skinType]}",
                          style: AppTexts.body2,
                        )
                      : Text(' '),
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.skinType,
                    style: AppTexts.body3,
                  ),
                  faceShape != null
                      ? Text(
                          '$faceShape',
                          style: AppTexts.body2,
                        )
                      : Text(''),
                ],
              ),
              SizedBox(
                height: 40,
              ),
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.black.withOpacity(0.4),
              ),
              SizedBox(
                height: 16,
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.black,
                    backgroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () {
                    showCupertinoModalPopup<void>(
                      context: context,
                      builder: (BuildContext context) => CupertinoAlertDialog(
                        title: const Text('알림'),
                        content: const Text(
                          '로그아웃하시겠습니까?',
                        ),
                        actions: <CupertinoDialogAction>[
                          CupertinoDialogAction(
                            isDefaultAction: true,
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              '아니오',
                              style: TextStyle(
                                  color: AppColors.iconBlack.withOpacity(0.6)),
                            ),
                          ),
                          CupertinoDialogAction(
                            isDestructiveAction: true,
                            onPressed: () async {
                              final dio = Dio();
                              final storage = FlutterSecureStorage();
                              print("버튼 클릭됨33333333");
                              final refreshToken =
                                  await storage.read(key: 'REFRESH_TOKEN_KEY');
                              final accessToken =
                                  await storage.read(key: 'ACCESS_TOKEN_KEY');
                              try {
                                // API 호출 예시 (실제 API 호출 코드로 대체해야 함)
                                final response = await dio.post(
                                  'https://j10e106.p.ssafy.io/api/auth/logout',
                                  options: Options(
                                    headers: {
                                      'Authorization': 'Bearer $accessToken'
                                    },
                                  ),
                                  data: {
                                    // 서버가 요구하는 요청 본문 형식에 맞추어 privacy 설정값을 전달
                                    'refreshToken': refreshToken,
                                  },
                                );
                                print('잉');
                                print(response.data.toString());
                                print('꿍');
                                // API 호출 성공 시 상태 업데이트
                                if (response.statusCode == 200) {
                                  print('뀨');
                                  print(storage);
                                  await storage.deleteAll();
                                  print(storage);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (builder) => LoginPage(),
                                    ),
                                  );
                                  print(response.data);
                                } else {
                                  // 응답이 예상과 다를 경우의 오류 처리
                                  _showError('로그아웃 안됨.');
                                  _showError('로그아웃 실패: ${response.statusCode}');
                                }
                              } catch (e) {
                                // 네트워크 요청 실패 등의 예외 처리
                                _showError('로그아웃 실패: $e');
                              }
                            },
                            child: Text('예'),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(AppStrings.logout),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // 비동기 메소드 정의

  Future<void> _updatePrivacySetting(bool newValue) async {
    print('호출함');
    final dio = Dio();
    final storage = FlutterSecureStorage();
    print("버튼 클릭됨33333333");
    final refreshToken = await storage.read(key: 'REFRESH_TOKEN_KEY');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    try {
      // API 호출 예시 (실제 API 호출 코드로 대체해야 함)
      final response = await dio.patch(
        'https://j10e106.p.ssafy.io/api/members/privacies',
        options: Options(
          headers: {'Authorization': 'Bearer $accessToken'},
        ),
        data: {
          // 서버가 요구하는 요청 본문 형식에 맞추어 privacy 설정값을 전달
          'privacy': newValue,
        },
      );

      // API 호출 성공 시 상태 업데이트
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['privacy'] != null) {
        final userProvider = Provider.of<User>(context, listen: false);
        userProvider.updatePrivacy(newValue);
        print(response.data);
      } else {
        // 응답이 예상과 다를 경우의 오류 처리
        _showError('Privacy setting update failed.');
      }
    } catch (e) {
      // 네트워크 요청 실패 등의 예외 처리
      _showError(e.toString());
    }
  }

// 에러 메시지를 표시하는 메소드 (예시)
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
