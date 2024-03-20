import 'package:flutter/material.dart';

class HashTag extends ChangeNotifier {
  final List<Map<String, dynamic>> _tags = [];
  List<Map<String, dynamic>> get tags => _tags;

  void addTag(Map<String, dynamic> tag) {
    _tags.add(tag);
    notifyListeners();
  }

  void removeTag(Map<String, dynamic> tag) {
    _tags.remove(tag);
    notifyListeners();
  }
}
