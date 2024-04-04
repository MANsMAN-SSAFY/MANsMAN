import 'package:flutter/material.dart';

class Noti extends ChangeNotifier {
  final List<Map<String, dynamic>> _notis = [
    {
      "notification": {"title": "superstructure", "body": "superstructure"},
      "data": {"key": "VOG"},
      "type": "EU",
      'time': "1234-12-34"
    },
    {
      "notification": {"title": "zero administration", "body": "interface"},
      "data": {"key": "PEG"},
      "type": "EU",
      'time': "1234-12-34"
    },
    {
      "notification": {
        "title": "Down-sized",
        "body": "artificial intelligence"
      },
      "data": {"key": "KVA"},
      "type": "EU",
      'time': "1234-12-34"
    },
    {
      "notification": {"title": "capability", "body": "Mandatory"},
      "data": {"key": "UNC"},
      "type": "SA",
      'time': "1234-12-34"
    },
    {
      "notification": {"title": "Robust", "body": "access"},
      "data": {"key": "VIN"},
      "type": "EU",
      'time': "1234-12-34"
    }
  ];
  List<Map<String, dynamic>> get notis => _notis;

  void addNoti(Map<String, dynamic> noti) {
    _notis.add(noti);
    notifyListeners();
  }

  void removeNoti(int index) {
    _notis.removeAt(index);
    notifyListeners();
  }
}
