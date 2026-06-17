import 'package:flutter/material.dart';

class HomeViewModel extends ChangeNotifier {
  int _bottomNavIndex = 0;

  int get bottomNavIndex => _bottomNavIndex;

  void changeBottomTab(int index) {
    _bottomNavIndex = index;
    notifyListeners();
  }
}