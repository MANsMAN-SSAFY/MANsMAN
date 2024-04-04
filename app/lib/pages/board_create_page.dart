import 'dart:convert';
import 'dart:io';
import 'package:app/common/style/app_colors.dart';
import 'package:app/store/user.dart';
import 'package:flutter/material.dart';
import 'package:app/common/default_layout/default_layout.dart';
import 'package:app/config/app_routes.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:app/store/router.dart';

class BoardCreatePage extends StatefulWidget {
  const BoardCreatePage({super.key});

  @override
  _BoardCreatePageState createState() => _BoardCreatePageState();
}

class _BoardCreatePageState extends State<BoardCreatePage> {
  late FocusNode _titleFocusNode;
  final List<XFile> _selectedImages = []; // 선택한 이미지를 저장할 리스트
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final Dio dio = Dio();

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  void _onPostWritten() {
    // 글 작성이 완료되면 Navigator.pop()을 호출하기 전에 상태를 갱신하여 새로운 글을 전달합니다.
    final router = Provider.of<MainRouter>(context, listen: false);
    // 타겟 탭의 인덱스를 설정합니다.
    router.setIndex(3); // 예를 들어 '추천 화장품' 탭으로 이동하려면 인덱스를 1로 설정
    // MainPage로 이동합니다.
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.main,
      ModalRoute.withName('/'),
    );
  }

  // 이미지 선택 함수
  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImages.add(pickedFile);
      });
    }
  }

  // 글쓰기 함수
  Future<void> _writePost() async {
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('제목과 내용을 작성해주세요.'),
          duration: Duration(seconds: 2), // 스낵바 표시 시간
        ),
      );
      return;
    }

    try {
      FormData formData = FormData();

      // 제목과 내용 추가
      formData.fields.addAll([
        MapEntry('title', _titleController.text),
        MapEntry('content', _contentController.text),
      ]);

      // 이미지 파일 추가
      for (var imageFile in _selectedImages) {
        formData.files.add(MapEntry(
          'img',
          await MultipartFile.fromFile(imageFile.path),
        ));
      }

      // POST 요청 보내기
      final response = await dio.post(
        '${dotenv.env['baseUrl']}boards',
        data: formData,
        options: Options(
          headers: {
            'Content-Type': 'multipart/form-data',
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      // 서버로부터의 응답 처리
      // 서버로부터의 응답 처리
      if (response.statusCode == HttpStatus.created) {
        // 성공적으로 글쓰기가 완료된 경우
        print('글쓰기가 완료되었습니다.');
        _onPostWritten();

        // 스낵바 표시
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('성공적으로 글을 작성했습니다.'),
            duration: Duration(seconds: 2), // 스낵바 표시 시간
          ),
        );
      } else {
        // 글쓰기 실패한 경우
        print('글쓰기 실패: ${response.statusCode}');
      }
    } catch (e) {
      // 예외 처리
      print('글쓰기 오류: $e');
    }
  }

  // 이미지를 제거하는 함수
  void _removeImage(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            // 다이얼로그의 모서리를 둥글게 처리
            borderRadius: BorderRadius.circular(20.0),
          ),
          title: const Text(
            '사진 삭제',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black, // 제목의 글꼴 색상 지정
            ),
          ),
          content: const Text(
            '사진을 삭제하시겠습니까?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey, // 내용의 글꼴 색상 지정
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  child: const Text(
                    '아니오',
                    style: TextStyle(
                      color: Colors.red, // '아니오' 버튼의 글꼴 색상 지정
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
                TextButton(
                  child: const Text(
                    '예',
                    style: TextStyle(
                      color: Colors.blue, // '예' 버튼의 글꼴 색상 지정
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedImages.removeAt(index); // 사진 삭제
                    });
                    Navigator.of(context).pop(); // 다이얼로그 닫기
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: '글쓰기',
      actions: [
        TextButton(
          onPressed: _writePost,
          child: const Text(
            '글쓰기',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.blue,
            ),
          ),
        )
      ],
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _titleController,
                  style: const TextStyle(fontSize: 24),
                  focusNode: _titleFocusNode,
                  decoration: const InputDecoration(
                    hintText: '제목을 입력하세요',
                    hintStyle: TextStyle(
                      fontSize: 20,
                    ),
                    border: InputBorder.none,
                  ),
                ),
                Container(
                  height: 16,
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 1))),
                ),
                TextField(
                  controller: _contentController,
                  style: const TextStyle(fontSize: 18),
                  maxLines: 10, // 다중 라인 입력 가능
                  decoration: const InputDecoration(
                    hintText: '내용을 입력하세요',
                    border: InputBorder.none,
                  ),
                ),
                Container(
                  height: 16,
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 1))),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: _selectImage,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.blue,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "사진 선택",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                _selectedImages.isEmpty
                    ? const SizedBox(
                        height: 200, // 여기서 원하는 높이를 지정해주세요.
                        child: Center(
                          child: Text(
                            '사진을 추가해주세요',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () => _removeImage(index),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.file(
                                  File(_selectedImages[index].path),
                                  height: 180,
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
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
