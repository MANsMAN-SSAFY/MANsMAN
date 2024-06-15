import 'package:app/common/style/app_colors.dart';
import 'package:app/common/style/app_texts.dart';
import 'package:app/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:app/components/camera/analysis.dart';
import 'package:app/components/Modal/camera_alert.dart';
import 'package:provider/provider.dart';
import 'package:app/store/diary/skin_picture_store.dart';

class CameraComponent extends StatefulWidget {
  const CameraComponent({super.key});

  @override
  State<CameraComponent> createState() => _CameraComponentState();
}

class _CameraComponentState extends State<CameraComponent> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  final Dio dio = Dio();
  late Map<String, dynamic> analysisResult; // 분석 결과를 저장할 변수

  bool isAnalyzing = false; // 분석 중인지 여부를 저장하는 변수

  Future<void> uploadImage(BuildContext context) async {
    // 이미지 업로드 및 분석 수행
    try {
      // 이미지 업로드 전 분석 중임을 설정
      setState(() {
        isAnalyzing = true;
      });

      // 이미지 업로드
      const storage = FlutterSecureStorage();
      final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");
      String fileName = image!.path.split('/').last;
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(image!.path, filename: fileName),
      });
      Response response = await dio.post(
        "${dotenv.env['baseUrl']}reports",
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      print(response.data);
      analysisResult = response.data; // 분석 결과 저장

      // 분석이 완료되면 분석 중임을 해제
      setState(() {
        isAnalyzing = false;
      });

      // 모달 창을 엽니다.
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: AppColors.white,
        context: context,
        builder: (context) {
          return ReportAlert(
            displayResult: analysisResult,
          );
        },
      );
      print("분석 데이터 저장");
      // 분석 데이터 사진 저장
      Provider.of<MySkinPictures>(context, listen: false)
          .setPictures(response.data['imgUrl']);
      // 분석 데이터 저장
      Provider.of<MySkinPictures>(context, listen: false)
          .addSkinData(response.data);
      // 리포트 일지 생성
      Provider.of<MySkinPictures>(context, listen: false).hasTodaysPhoto();

      setState(() {
        Provider.of<MySkinPictures>(context, listen: false).reportList;
      });
    } catch (e) {
      print("Error uploading image: $e");
      throw Exception('이미지 업로드 중 오류가 발생했습니다.');
    }
  }

  Future<void> getImage(ImageSource imageSource) async {
    final XFile? pickedFile =
        await picker.pickImage(source: imageSource, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        image = XFile(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: buildPhotoArea(),
        ),
        const SizedBox(
          height: 20,
        ),
        buildButton(),
      ],
    );
  }

  Widget buildPhotoArea() {
    return image != null
        ? SizedBox(
            width: 300,
            height: 300,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.file(
                File(image!.path),
                fit: BoxFit.cover,
              ),
            ),
          )
        : Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColors.iconBlack.withOpacity(0.6),
            ),
            width: 300,
            height: 300,
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return CameraAlert(
                          getImage: getImage,
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 150,
                    color: AppColors.white,
                  ),
                )
              ],
            )),
          );
  }

  Widget buildButton() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return CameraAlert(
                      getImage: getImage,
                    );
                  },
                );
              },
              child: const Text(
                "촬영하기",
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(width: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: AppColors.white,
                backgroundColor: AppColors.blue,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
              onPressed: () {
                getImage(ImageSource.gallery);
              },
              child: const Text(
                "불러오기",
                style: TextStyle(fontSize: 17),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: AppColors.black,
            backgroundColor: Colors.amber,
            minimumSize: const Size(250, 40),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
          onPressed:
              image != null && !isAnalyzing ? () => uploadImage(context) : null,
          child: image != null && !isAnalyzing
              ? const Text(
                  "분석",
                  style: TextStyle(fontSize: 17),
                )
              : const Text(
                  "분석",
                  style: TextStyle(fontSize: 17),
                ),
        ),
        const SizedBox(
          height: 40,
        ),
        isAnalyzing
            ? // 분석 중일 때 로딩 스피너 표시
            const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: AppColors.blue,
                    strokeWidth: 8,
                  ), // 로딩 스피너
                  SizedBox(height: 15), // 스피너와 텍스트 사이 간격
                  Text(
                    "분석중입니다\n잠시만 기다려주세요",
                    style: AppTexts.body2,
                    textAlign: TextAlign.center,
                  ), // 사용자에게 상태 알림
                ],
              )
            : const Text(
                '오늘의 리포트를 작성하고\n 나에게 맞는 화장품을 추천받으세요',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              )
      ],
    );
  }
}
