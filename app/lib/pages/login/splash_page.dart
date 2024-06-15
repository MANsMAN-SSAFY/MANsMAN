import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/common/dio/dio.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/config/app_routes.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final storage = FlutterSecureStorage();
  @override
  void initState() {
    super.initState();
    checkToken();
  }

  void checkToken() async {
    print('시작');

    final refreshToken = await storage.read(key: 'REFRESH_TOKEN_KEY');
    final accessToken = await storage.read(key: 'ACCESS_TOKEN_KEY');
    final password = await storage.read(key: 'password');
    final email = await storage.read(key: 'email');
    print('정보 유출?!!!');
    print(password);
    print(email);
    print('REFRESH_TOKEN_KEY: $refreshToken');
    print('ACCESS_TOKEN_KEY: $accessToken');
    final dio = Dio();
    if (refreshToken == null || accessToken == null) {
      try {
        Map<String, dynamic> notificationData = {
          "notificationToken": await FirebaseMessaging.instance.getToken(),
        };
        final response = await dio.post(
          'https://j10e106.p.ssafy.io/api/auth/reissue',
          options: Options(
            headers: {'Authorization': 'Bearer $refreshToken'},
          ),
          data: notificationData,
        );

        await storage.write(
            key: 'ACCESS_TOKEN_KEY', value: response.data['accessToken']);
        await storage.write(
            key: 'REFRESH_TOKEN_KEY', value: response.data['refreshToken']);
        print('자동로그인 됨');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      } catch (e) {
        print('로그인 페이지로 이동: $e');
        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
      }
    } else {
      try {
        Map<String, dynamic> loginData = {
          "email": email,
          "password": password,
          "notificationToken": await FirebaseMessaging.instance.getToken(),
        };

        final response = await dio
            .post('https://j10e106.p.ssafy.io/api/auth/login', data: loginData);
        final nickname = response.data['profileResponseDto']['nickname'];
        final refreshToken = response.data['tokenResponseDto']['refreshToken'];
        final accessToken = response.data['tokenResponseDto']['accessToken'];
        final accessTokenExpiresIn =
            response.data['tokenResponseDto']['accessTokenExpiresIn'];
        await storage.write(key: 'password', value: password);
        await storage.write(key: 'email', value: email);
        await storage.write(key: 'ACCESS_TOKEN_KEY', value: accessToken);
        await storage.write(key: 'REFRESH_TOKEN_KEY', value: refreshToken);
        await storage.write(key: 'nickname', value: nickname);

        final userProvider = Provider.of<User>(context, listen: false);
        userProvider.updateUser({
          'accessTokenExpiresIn': accessTokenExpiresIn,
        }, response.data['profileResponseDto']);

        Navigator.of(context)
            .pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);

        print("Login successful: ${response.data}");
      } on DioException catch (e) {
        // DioException을 DioError로 수정
        final response = e.response;
        if (response != null) {
          print("Server responded with: ${response.data}");
          print('${response.data}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: ${response.data}')),
          );
        } else {
          print("Error occurred: ${e.message}");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('로그인 실패: ${e.message}')),
          );
        }
      } catch (e) {
        print("Unexpected error: $e");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Unexpected error: $e')),
        // );
      }
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.main, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      child: Scaffold(
        body: Container(
          color: AppColors.blue,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'MANsMAN',
                style: TextStyle(
                    fontSize: 50,
                    fontFamily: 'Mosk',
                    fontWeight: FontWeight.w800,
                    color: AppColors.white),
              ),
              const SizedBox(
                height: 16,
              ),
              CircularProgressIndicator(
                color: AppColors.white,
              )
            ],
          ),
        ),
      ),
    );
  }
}
