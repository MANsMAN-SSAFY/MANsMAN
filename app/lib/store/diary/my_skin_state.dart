import 'package:flutter/material.dart';

class MySkinData extends ChangeNotifier {
  List<Map<String, dynamic>> _chartData = [
    {"type": 'acne', "value": 0, "color": const Color(0xffffabab)},
    {"type": 'blackheads', "value": 0, "color": const Color(0xffB6D1FF)},
    {"type": 'wrinkles', "value": 0, "color": const Color(0xffC4BECD)},
  ];
  List<Map<String, dynamic>> get chartData => _chartData;

  Map<String, dynamic> _faceData = {
    'faceShape': "얼굴형",
    "skinType": "피부타입",
    "age": 20
  };
  Map<String, dynamic> get faceData => _faceData;

  void setSkinData(List<Map<String, dynamic>> data) {
    // _chartData.clear();
    _chartData = data;
    notifyListeners();
  }

  void setFaceData(Map<String, dynamic> data) {
    // _faceData.clear();
    _faceData = data;
    notifyListeners();
  }
}
