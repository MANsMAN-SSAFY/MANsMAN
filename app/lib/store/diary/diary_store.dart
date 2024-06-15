import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:app/store/diary/skin_picture_store.dart';

class DiaryProvider extends ChangeNotifier {
  Map<String, dynamic> _diaryInfo = {};
  Map<String, dynamic> get diaryInfo => _diaryInfo;

  Future<Map<String, dynamic>> getReport(
      BuildContext context, String reportId, int selectedIndex) async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      final response = await dio.get(
        "${dotenv.env['baseUrl']}reports/$reportId",
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );

      if (response.statusCode == 200) {
        print(
            "리포트정보====================================================\n${response.data}");
        setDiaryInfo(response.data);
        // print("데이터 : ${response.data}");
        // Provider.of<MySkinPictures>(context, listen: false)
        //     .setReport(selectedIndex, response.data);
        // print("$selectedIndex번 변경 성공");
        // print(
        //     "변경된 데이터 : ${Provider.of<MySkinPictures>(context, listen: false).reportList[selectedIndex]}");

        return response.data;
      }
    } catch (e) {
      print("reportList 변경 에러 : $e");
      print("에러 어디서나냐 -----------------------------$reportId");
      throw Exception('reportList 변경에 실패했습니다: $e');
    }
    return {};
  }

  Future<void> putMemo(String memo, String reportId, String memberId) async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    final Map<String, dynamic> data = {
      "reportId": int.parse(reportId),
      "memo": memo,
    };

    try {
      final response =
          await dio.put("${dotenv.env['baseUrl']}reports/memo/$memberId",
              options: Options(
                headers: {
                  "Authorization": 'Bearer $accessToken',
                },
              ),
              data: data);

      if (response.statusCode == 200) {
        print("메모 DB 저장 성공");
      }
    } catch (e) {
      print("다이어리 저장 에러 : $e");
    }
  }

  Future<void> putWater(double water, String reportId, String memberId) async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    final Map<String, dynamic> data = {
      "reportId": int.parse(reportId),
      "water": water.toInt(),
    };

    try {
      final response =
          await dio.put("${dotenv.env['baseUrl']}reports/water/$memberId",
              options: Options(
                headers: {
                  "Authorization": 'Bearer $accessToken',
                },
              ),
              data: data);

      if (response.statusCode == 200) {
        print("수분 DB 저장 성공");
      }
    } catch (e) {
      print("다이어리 저장 에러 : $e");
    }
  }

  Future<void> putSleep(double sleep, String reportId, String memberId) async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    String formatSleepTime(double sleepHours) {
      int hours = sleepHours.floor(); // 소수점 앞의 정수 부분 (시간)
      int minutes = ((sleepHours - hours) * 60).round(); // 소수점 뒤의 부분을 분으로 변환

      // "HH:MM" 형식의 문자열로 포맷팅
      String formattedSleep =
          "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}";

      return formattedSleep;
    }

    String sleepTimeString = formatSleepTime(sleep);

    final Map<String, dynamic> data = {
      "reportId": int.parse(reportId),
      "sleep": sleep,
    };

    try {
      final response =
          await dio.put("${dotenv.env['baseUrl']}reports/sleep/$memberId",
              options: Options(
                headers: {
                  "Authorization": 'Bearer $accessToken',
                },
              ),
              data: data);

      if (response.statusCode == 200) {
        print("수면 DB 저장 성공");
      }
    } catch (e) {
      print("다이어리 저장 에러 : $e");
    }
  }

  void setDiaryInfo(Map<String, dynamic> newdata) {
    _diaryInfo = newdata;
    print("다이어리 정보 저장");
    print(_diaryInfo);
    notifyListeners();
  }

  void updateMemo(String newMemo) {
    putMemo(
      newMemo,
      _diaryInfo['reportId'].toString(),
      _diaryInfo['memberId'].toString(),
    );
    _diaryInfo['memo'] = newMemo; // memo 값만 업데이트
    print("메모 업데이트: $newMemo");
    notifyListeners(); // 리스너에게 변화를 알림
  }

  void updateTags(List<dynamic> newTags) {
    _diaryInfo['tags'] = newTags;
    print("태그 업데이트: $newTags");
    notifyListeners(); // 리스너에게 변화를 알림
  }
}
