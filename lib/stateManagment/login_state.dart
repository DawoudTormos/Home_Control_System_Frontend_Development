import 'package:flutter/material.dart';

class LoginState extends ChangeNotifier {

  bool _isTokenChecked = false;
  bool _isLoggedIn = false;
  bool _isDataLoaded= false;

  bool get isLoggedIn => _isLoggedIn;
  bool get isTokenChecked => _isTokenChecked;
  bool get isDataLoaded => _isDataLoaded;



  void setDataLoaded(bool x) {
    _isDataLoaded = x;
    notifyListeners();
  }

  void setTokenCheck(bool x) {
    _isTokenChecked = x;
    notifyListeners();
  }
  void login() {
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }
}

