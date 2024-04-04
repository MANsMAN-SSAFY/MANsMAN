// 패키지
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/components/signup_text_field.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/common/style/app_colors.dart';
import 'package:app/components/selectedDate.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/utils/validate.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  // api 통신
  final dio = Dio();
  final storage = FlutterSecureStorage(); // token 저장소
  // 각 요소를 보여주는 변수
  final int index = 0;
  // 생년월일 변수
  DateTime birthday = DateTime.now();
  // 이메일 변수
  var emailController = TextEditingController();
  // 비밀번호 변수
  var passwordController = TextEditingController();
  // 비밀번호 다시 입력받는 변수
  var checkPasswordController = TextEditingController();
  // 이메일 검증 에러
  String? emailError;
  // 패스워드 검증 에러
  String? passwordError;
  // 패스워드 확인 에러
  String? checkPasswordError;
  // 비밀번호 필드 활성화
  bool isPasswordEnabled = false;
  // 비밀번호 확인 필드 활성화
  bool isCheckedPasswordEnabled = false;

  // FocusNode 인스턴스 생성
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _checkPasswordFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // 리스너를 추가하여 TextEditingController의 값 변화를 감지
    emailController.addListener(validateEmailField);
    passwordController.addListener(validatePasswordField);
    checkPasswordController.addListener(validateCheckPasswordField);
  }

  void validateEmailField() {
    setState(() {
      emailError = validateEmail(emailController.text);
      // 이메일 유효성 검사를 통과하면(isPasswordEnabled가 true가 되면) 비밀번호 필드 활성화
      isPasswordEnabled = emailError == null;
      // 비밀번호 필드 활성화 상태가 변경될 때, 비밀번호 확인 필드도 동일하게 적용
      isCheckedPasswordEnabled = isPasswordEnabled;
    });
  }

  void validatePasswordField() {
    setState(() {
      passwordError = validatePassword(passwordController.text);
    });
  }

  void validateCheckPasswordField() {
    setState(() {
      if (passwordController.text == checkPasswordController.text) {
        setState(() {
          checkPasswordError = null;
        });

        // 날짜 선택기 호출 전 모든 포커스 해제
        // FocusScope.of(context).unfocus();
        //
        // selectDateCupertino(
        //   context,
        //   birthday,
        //       (newDate) {
        //     setState(() {
        //       birthday = newDate;
        //     });
        //   },
        // );
      } else {
        checkPasswordError = '비밀번호가 다릅니다';
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    checkPasswordController.dispose();
    // 사용이 끝난 후 FocusNode 리소스 해제
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _checkPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: GestureDetector(
        onTap: () {
          // 화면의 다른 부분을 탭할 때 키보드 숨기기
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 70),
                  child: Text(
                    '이메일을 알려주세요',
                    style: AppTexts.body1.copyWith(color: AppColors.iconBlack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SignupTextField(
                      hint: 'example@ssafy.kr',
                      focusNode: _emailFocus,
                      onSubmitted: (_) {
                        // 사용자가 입력을 마치면 비밀번호 입력 필드로 포커스 이동
                        FocusScope.of(context).requestFocus(_passwordFocus);
                      },
                      controller: emailController,
                      error: emailError,
                      obscureText: false),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '비밀번호를 입력해주세요',
                    style: AppTexts.body1.copyWith(color: AppColors.iconBlack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SignupTextField(
                      hint: '(영문, 숫자, 특수문자 포함 8~20자)',
                      focusNode: _passwordFocus,
                      onSubmitted: (_) {
                        // 비밀번호 확인 입력 필드로 포커스 이동
                        FocusScope.of(context)
                            .requestFocus(_checkPasswordFocus);
                      },
                      controller: passwordController,
                      error: passwordError,
                      limit: 20,
                      enabled: isPasswordEnabled),
                ),
                // Password requirements can be visualized differently if needed
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Text(
                    '비밀번호를 다시 입력해주세요',
                    style: AppTexts.body1.copyWith(color: AppColors.iconBlack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: SignupTextField(
                    hint: '(영문, 숫자, 특수문자 포함 8~20자)',
                    focusNode: _checkPasswordFocus,
                    controller: checkPasswordController,
                    error: checkPasswordError,
                    limit: 20,
                    enabled: isCheckedPasswordEnabled,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Text(
                    '생년월일을 입력해주세요',
                    style: AppTexts.body1.copyWith(color: AppColors.iconBlack),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      selectDateCupertino(context, birthday,
                          (DateTime newDate) {
                        setState(() {
                          birthday = newDate;
                        });
                      });
                      // 달력 선택기 닫힘 후 포커스 제거
                      FocusScope.of(context).requestFocus(FocusNode());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.tag.withOpacity(0.3),
                        borderRadius: BorderRadius.all(
                          Radius.circular(12),
                        ),
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.input_border,
                            width: 1.0,
                          ),
                        ),
                      ),
                      child: Text(
                        birthday != null
                            ? birthday.toString().split(' ')[0]
                            : '생일을 알려주세요',
                        style: AppTexts.body1,
                      ),
                    ),
                  ),
                ),
                Expanded(child: Container()),
                SizedBox(
                  height: 48,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (emailError == null && passwordError == null) {
                        try {
                          Map<String, dynamic> signupData = {
                            "email": emailController.text,
                            "password": passwordController.text,
                            "birthday": birthday.toString().split(' ')[0],
                            "notificationToken":
                                await FirebaseMessaging.instance.getToken(),
                          };

                          final response = await dio.post(
                              'https://j10e106.p.ssafy.io/api/auth/signup',
                              data: signupData);

                          // 자동로그인하는 로직 추가

                          final refreshToken =
                              response.data['tokenResponseDto']['refreshToken'];
                          final accessToken =
                              response.data['tokenResponseDto']['accessToken'];
                          final accessTokenExpiresIn = response
                              .data['tokenResponseDto']['accessTokenExpiresIn'];

                          await storage.write(
                              key: 'ACCESS_TOKEN_KEY', value: accessToken);
                          await storage.write(
                              key: 'REFRESH_TOKEN_KEY', value: refreshToken);
                          await storage.write(key: 'password', value: passwordController.text);
                          await storage.write(key: 'email', value: emailController.text);
                          final userProvider =
                              Provider.of<User>(context, listen: false);
                          userProvider.updateUser({
                            'accessTokenExpiresIn': accessTokenExpiresIn,
                          }, response.data['profileResponseDto']);

                          Navigator.of(context).pushNamedAndRemoveUntil(
                              AppRoutes.main, (route) => false);

                          print("Signup successful: ${response.data}");
                        } catch (e) {
                          print('가입 실패: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('가입 실패: $e')),
                          );
                        }
                      }
                      ;
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.white,
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    child: Text('회원가입'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
