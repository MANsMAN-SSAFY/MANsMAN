import 'package:flutter/material.dart';

class MainRouter extends ChangeNotifier {
  int _routeIndex = 0;
  int get routeIndex => _routeIndex;

  void setIndex(int routeIndex) {
    _routeIndex = routeIndex;
    print(routeIndex.toString());
    notifyListeners();
  }
}
