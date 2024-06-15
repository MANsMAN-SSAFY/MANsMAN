import 'package:app/common/style/app_colors.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class MyProfileImage extends StatefulWidget {
  final double size;
  const MyProfileImage({super.key, this.size = 40});

  @override
  State<MyProfileImage> createState() => _MyProfileImageState();
}

class _MyProfileImageState extends State<MyProfileImage> {
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
    final imgUrl = result?['imgUrl'];
    print(imgUrl);
    return isloading == true
        ? Center(
            child: CircularProgressIndicator(
              color: AppColors.blue,
            ),
          )
        : ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: imgUrl != null && imgUrl.isNotEmpty
                ? Image.network(
                    imgUrl,
                    width: widget.size,
                    height: widget.size,
                    fit: BoxFit.cover,
                  )
                : Icon(
                    Icons.account_circle_rounded,
                    color: AppColors.iconBlack,
                    size: widget.size,
                  ) // 기본 이미지로 변경

            );
  }
}
