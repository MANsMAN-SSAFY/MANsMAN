import 'dart:ffi';
import 'dart:io';

import 'package:app/common/dio/dio.dart';
import 'package:app/store/Profile/profile_image.dart';
import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/store/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class NewProfileModal extends StatefulWidget {
  const NewProfileModal({super.key});

  @override
  State<NewProfileModal> createState() => _NewProfileModalState();
}

class _NewProfileModalState extends State<NewProfileModal> {
  XFile? _image; // 이미지를 담을 변수 선어
  final ImagePicker picker = ImagePicker(); //ImagePicker 초기화

  //이미지를 가져오는 함수
  Future getImage(ImageSource imageSource) async {
    //pickedFile에 ImagePicker로 가져온 이미지가 담긴다.
    final XFile? pickedFile = await picker.pickImage(source: imageSource);
    if (pickedFile != null) {
      setState(() {
        _image = XFile(pickedFile.path); //가져온 이미지를 _image에 저장
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          )),
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '프로필 사진 수정',
            style: AppTexts.body1,
          ),
          SizedBox(
            height: 16,
          ),
          _buildPhotoArea(),
          SizedBox(
            height: 16,
          ),
          SizedBox(
            height: 16,
          ),
          _buildButton(),
          // OutlinedButton(onPressed: (){}, child: Text('직접 촬영'),),
          SizedBox(
            height: 16,
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.iconBlack.withOpacity(0.5),
            ),
            height: 1,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              OutlinedButton(
                onPressed: () async {
                  final dio = Dio();
                  final storage = FlutterSecureStorage();
                  var formData = FormData();
                  print("버튼 클릭됨33333333");

                  final accessToken =
                      await storage.read(key: 'ACCESS_TOKEN_KEY');

                  try {
                    final response = await dio.delete(
                        'https://j10e106.p.ssafy.io/api/members/images',
                        options: Options(
                            headers: {'Authorization': 'Bearer $accessToken'}));

                    final userProvider =
                    Provider.of<User>(context, listen: false);
                    userProvider.updateimgUrl('');

                    Navigator.pop(context, true);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('프로필 사진이 성공적으로 삭제되었습니다.')),
                    );
                  } on DioException catch (e) {
                    // DioException을 DioError로 수정
                    final response = e.response;
                    if (response != null) {
                      print("Server responded with: ${response.data}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('프로필 사진 삭제 실패: ${response.data}')),
                      );
                    } else {
                      print("Error occurred: ${e.message}");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('프로필 사진 삭제 실패: ${e.message}'),
                        ),
                      );
                    }
                  } catch (e) {
                    print("프로필 사진 삭제 실패: $e");
                  }
                },
                child: Text('프로필 사진 삭제'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.iconBlack.withOpacity(0.7),
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  final dio = Dio();
                  final storage = FlutterSecureStorage();
                  print("버튼 클릭됨33333333");
                  final refreshToken =
                      await storage.read(key: 'REFRESH_TOKEN_KEY');
                  final accessToken =
                      await storage.read(key: 'ACCESS_TOKEN_KEY');

                  if (_image != null) {
                    dynamic sendData = _image!.path;
                    var formData = FormData.fromMap({
                      'imgUrl': await MultipartFile.fromFile(sendData,
                          filename: 'upload'),
                    });
                    print(formData);
                    try {
                      final accessToken =
                          await storage.read(key: 'ACCESS_TOKEN_KEY');
                      final response = await dio.post(
                          'https://j10e106.p.ssafy.io/api/members/images',
                          data: formData,
                          options: Options(headers: {
                            'Authorization': 'Bearer $accessToken'
                          }));
                      final userProvider =
                      Provider.of<User>(context, listen: false);
                      userProvider.updateimgUrl(response.data['imgUrl']);
                      print("imgUrl successful: ${response.data}");
                      Navigator.pop(context, true);
                    } on DioException catch (e) {
                      // DioException을 DioError로 수정
                      final response = e.response;
                      if (response != null) {
                        print("Server responded with: ${response.data}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text('프로필 사진 수정 실패: ${response.data}')),
                        );
                      } else {
                        print("Error occurred: ${e.message}");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('프로필 사진 수정 실패: ${e.message}'),
                          ),
                        );
                      }
                    } catch (e) {
                      print("프로필 사진 수정 실패: $e");
                    }
                  }
                },
                child: Text('프로필 사진 수정'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.white,
                  backgroundColor: AppColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoArea() {
    return _image != null
        ? Container(
            width: 200,
            height: 200,
            child: Image.file(File(_image!.path)), //가져온 이미지를 화면에 띄워주는 코드
          )
        : Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey, // 여기서 배경색을 설정
              borderRadius: BorderRadius.all(Radius.circular(20)), // 둥근 모서리 효과
            ),
          );
  }

  Widget _buildButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton(
          onPressed: () {
            getImage(ImageSource.camera); //getImage 함수를 호출해서 카메라로 찍은 사진 가져오기
          },
          child: Text(
            "카메라",
          ),
          style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blue,
              backgroundColor: AppColors.white),
        ),
        SizedBox(width: 30),
        OutlinedButton(
          onPressed: () {
            getImage(ImageSource.gallery); //getImage 함수를 호출해서 갤러리에서 사진 가져오기
          },
          child: Text("갤러리"),
          style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.blue,
              backgroundColor: AppColors.white),
        ),
      ],
    );
  }
}
