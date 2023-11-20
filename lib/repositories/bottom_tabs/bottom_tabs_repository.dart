import 'package:flutter/material.dart';

class BottomTabRepository extends ChangeNotifier {
  int tabIndex = 0;

  void changeTabIndex(int index) {
    tabIndex = index;
    notifyListeners();
  }
}
