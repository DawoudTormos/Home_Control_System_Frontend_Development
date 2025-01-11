import 'package:flutter/material.dart';

class DataUpdateState extends ChangeNotifier {
  int updateCount = 0;

  void alertDataUpdated() {
    updateCount++;
    notifyListeners();
  }
}
