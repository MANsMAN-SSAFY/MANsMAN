import 'package:flutter/material.dart';

class Memo extends ChangeNotifier {
  String _memo = '오늘의 한줄을 추가하세요.';
  String get memo => _memo;

  void setMemo(String memo) {
    _memo = memo;
    notifyListeners();
  }
}
