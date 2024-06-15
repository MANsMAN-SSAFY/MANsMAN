import 'package:app/common/component/app_elevated_button.dart';
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/pages/login/signup_page.dart';
import 'package:app/pages/main_page.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:app/common/component/app_text_field.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_strings.dart';
import 'package:app/utils/validate.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:app/store/diary/skin_picture_store.dart';

class LoginPage extends StatefulWidget {
  static String get routeName => 'login';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var email = ''; // 이메일 입력 값
  var password = ''; // 패스워드 입력 값
  String? emailError; // 이메일 에러
  String? passwordError; // 패스워드 에러

  // api 통신
  final dio = Dio();
  final storage = const FlutterSecureStorage(); // token 저장소

  @override
  Widget build(BuildContext context) {
    final double bottomPadding = MediaQuery.of(context).viewInsets.bottom;
    return DefaultLayout(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        }, // 키보드 외의 화면을 누르면, 키보드가 꺼짐.
        child: SafeArea(
          // 화면이 노치에 가져지지 않게 조정
          top: true,
          bottom: false,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: bottomPadding,
              ),
              child: Center(
                child: ConstrainedBox(
                  // ConstrainedBox를 추가하여 최소 높이를 지정
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context)
                        .size
                        .height, // Padding 값을 고려한 화면 높이
                  ),
                  child: IntrinsicHeight(
                    // IntrinsicHeight를 사용하여 Column의 높이를 조정
                    child: Column(
                      // mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const _Title(),
                        const _SubTitle(),
                        const SizedBox(height: 40),
                        AppTextField(
                          onChange: (String value) {
                            setState(() {
                              email = value;
                            });
                          },
                          autofocus: false,
                          autocorrect: false,
                          enableSuggestions: false,
                          hint: AppStrings.email,
                          errorText: (emailError != null) ? emailError! : null,
                        ),
                        const SizedBox(height: 16),
                        AppTextField(
                          onChange: (String value) {
                            setState(() {
                              password = value;
                            });
                          },
                          onSubmitted: (String value) {
                            // 키보드를 자동으로 내림
                            FocusScope.of(context).unfocus();
                          },
                          obscureText: true,
                          autocorrect: false,
                          enableSuggestions: false,
                          hint: AppStrings.password,
                          errorText:
                              (passwordError != null) ? passwordError! : null,
                          limit: 20,
                        ),
                        const SizedBox(height: 10),
                        AppElevatedButton(
                          backgroundColor:
                              email.isNotEmpty && password.isNotEmpty
                                  ? AppColors.blue
                                  : AppColors.input_border,
                          onPressed: email.isNotEmpty && password.isNotEmpty
                              ? () async {
                                  setState(() {
                                    emailError = validateEmail(email);
                                    passwordError = validatePassword(password);
                                  });

                                  // 검증 실패 시 SnackBar 표시
                                  if (emailError != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(emailError!)),
                                    );
                                    return; // 함수 종료
                                  }

                                  if (passwordError != null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(passwordError!)),
                                    );
                                    return; // 함수 종료
                                  }

                                  if (emailError == null &&
                                      passwordError == null) {
                                    try {
                                      Map<String, dynamic> loginData = {
                                        "email": email,
                                        "password": password,
                                        "notificationToken":
                                            await FirebaseMessaging.instance
                                                .getToken(),
                                      };

                                      final response = await dio.post(
                                          'https://j10e106.p.ssafy.io/api/auth/login',
                                          data: loginData);
                                      final nickname = response.data['profileResponseDto']['nickname'];
                                      final refreshToken =
                                          response.data['tokenResponseDto']
                                              ['refreshToken'];
                                      final accessToken =
                                          response.data['tokenResponseDto']
                                              ['accessToken'];
                                      final accessTokenExpiresIn =
                                          response.data['tokenResponseDto']
                                              ['accessTokenExpiresIn'];
                                      await storage.write(key: 'password', value: password);
                                      await storage.write(key: 'email', value: email);
                                      await storage.write(
                                          key: 'ACCESS_TOKEN_KEY',
                                          value: accessToken);
                                      await storage.write(
                                          key: 'REFRESH_TOKEN_KEY',
                                          value: refreshToken);
                                      await storage.write(
                                          key: 'nickname',
                                          value: nickname);
                                      readTokens();

                                      final userProvider = Provider.of<User>(
                                          context,
                                          listen: false);
                                      userProvider.updateUser({
                                        'accessTokenExpiresIn':
                                            accessTokenExpiresIn,
                                      }, response.data['profileResponseDto']);

                                      Navigator.of(context)
                                          .pushNamedAndRemoveUntil(
                                              AppRoutes.main, (route) => false);

                                      print(
                                          "Login successful: ${response.data}");
                                    } on DioException catch (e) {
                                      // DioException을 DioError로 수정
                                      final response = e.response;
                                      if (response != null) {
                                        print(
                                            "Server responded with: ${response.data}");
                                        print('${response.data}');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  '로그인 실패: ${response.data}')),
                                        );
                                      } else {
                                        print("Error occurred: ${e.message}");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content:
                                                  Text('로그인 실패: ${e.message}')),
                                        );
                                      }
                                    } catch (e) {
                                      print("Unexpected error: $e");
                                      // ScaffoldMessenger.of(context).showSnackBar(
                                      //   SnackBar(content: Text('Unexpected error: $e')),
                                      // );
                                    }
                                  }
                                }
                              : null,
                          name: '로그인',
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const SignupPage(),
                                ),
                              );
                            },
                            child: Text(
                              '회원가입',
                              style: TextStyle(
                                  color: AppColors.black.withOpacity(0.8),
                                  fontSize: 15),
                            ),
                          ),
                        ),
                        // SizedBox(
                        //   height: 30,
                        // ),
                        // Container(
                        //   height: 1,
                        //   width: double.infinity,
                        //   color: AppColors.black.withOpacity(0.4),
                        // ),
                        // SizedBox(
                        //   height: 16,
                        // ),
                        // Text('소셜 로그인'),
                        // SizedBox(
                        //   height: 16,
                        // ),
                        // AppElevatedButton(
                        //   name: '네이버로그인',
                        //   onPressed: () {},
                        //   backgroundColor: Colors.green,
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

// 저장된 토큰 값 읽기
  Future<void> readTokens() async {
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    final refreshToken = await storage.read(key: 'REFRESH_TOKEN_KEY');

    if (accessToken != null) {
      print('Access Token: $accessToken');
    } else {
      print('Access Token not found');
    }

    if (refreshToken != null) {
      print('Refresh Token: $refreshToken');
    } else {
      print('Refresh Token not found');
    }
  }
}

class _Title extends StatelessWidget {
  const _Title({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      "MANsMAN",
      style: TextStyle(
          color: AppColors.black,
          fontSize: 60,
          fontWeight: FontWeight.w800,
          fontFamily: 'Mosk'),
    );
  }
}

class _SubTitle extends StatelessWidget {
  const _SubTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text(
      '남자 중의 남자, 맨스맨',
      style: TextStyle(color: AppColors.black, fontSize: 18),
    );
  }
}
