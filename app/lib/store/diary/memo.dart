import 'package:flutter/material.dart';

class Memo extends ChangeNotifier {
  String _memo = '초기값임';
  String get memo => _memo;

  void setMemo(String memo) {
    _memo = memo;
    notifyListeners();
  }
}
