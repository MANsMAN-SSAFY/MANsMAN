import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MySkinPictures extends ChangeNotifier {
  List<dynamic> _reportList = [];
  List<dynamic> get reportList => List.from(_reportList.reversed);

  final List<String> _reportPicturs = [];
  List<String> get reportPicturs => _reportPicturs;

  String _lastId = "";
  String get lastId => _lastId;

  bool _hasNext = true;
  bool get hasNext => _hasNext;

  bool _today = false;
  bool get today => _today;

  Future<List> getSkinPictures() async {
    final Dio dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: "ACCESS_TOKEN_KEY");

    try {
      final response = await dio.get(
        "${dotenv.env['baseUrl']}reports/scroll?lastId=$lastId&pageSize=5",
        options: Options(
          headers: {
            "Authorization": 'Bearer $accessToken',
          },
        ),
      );
      print(response.statusCode.toString());
      print(response.data);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        print(data);
        setLastId(response.data['lastId'].toString());
        setHasNext(response.data['hasNext']);

        // response data를 돌면서 imgUrl만 리스트에 추가
        for (var item in data) {
          final Map<String, dynamic> data = item;
          final String imgUrl = data['imgUrl'];
          setPictures(imgUrl);
          addSkinData(data);
        }
      }
    } catch (e) {
      print("에러 여긴가 : $e");
    }
    print('갱신 데이터 저장');
    print(reportList.length);
    return reportList;
  }

  void diaryGetReport(dynamic data) {
    _reportList = data;
    notifyListeners();
  }

  void setPictures(String path) {
    _reportPicturs.add(path);
    print('이미지 저장 $path');
    notifyListeners();
  }

  void addSkinData(dynamic data) {
    _reportList.add(data); // _reportList에 직접 데이터 추가
    print('리포트 저장 $data');
    notifyListeners();
  }

  bool hasTodaysPhoto() {
    var now = nowInKorea();
    for (var report in reportList) {
      DateTime reportDate = DateTime.parse(report['date']);
      if (reportDate.year == now.year &&
          reportDate.month == now.month &&
          reportDate.day == now.day) {
        return true;
      }
    }
    return false;
  }

  void setLastId(String id) {
    _lastId = id;
    notifyListeners();
  }

  void setHasNext(bool hasNext) {
    _hasNext = hasNext;
    notifyListeners();
  }

  void setToday(bool today) {
    _today = hasTodaysPhoto();
    notifyListeners();
  }

  void setReport(int index, Map<String, dynamic> report) {
    _reportList[index] = report;
    notifyListeners();
  }

  DateTime nowInKorea() {
    var now = DateTime.now().toUtc();
    return now.add(const Duration(hours: 9)); // UTC에서 KST(UTC+9)로 변환
  }
}
