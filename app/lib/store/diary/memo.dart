import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Memo extends ChangeNotifier {
  String _memo = '';
  String get memo => _memo;

  Future<void> myMemo(String memo, String reportId, String memberId) async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    final Map<String, dynamic> data = {
      "reportId": int.parse(reportId),
      "memo": memo,
    };

    try {
      final response = await dio.put(
        "${dotenv.env['baseUrl']}reports/memo/$memberId",
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
        data: data,
      );
      if (response.statusCode == 200) {
        print("메모 변경 성공");
      }
    } catch (e) {
      print("메모 변경 오류: $e");
    }
  }

  void setMemo(String memo, String reportId, String memberId) {
    _memo = memo;
    myMemo(memo, reportId, memberId);
    notifyListeners();
  }
}
