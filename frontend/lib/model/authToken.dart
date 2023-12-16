import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? authToken;

  void setAuthToken(String token) {
    authToken = token;
    notifyListeners();
  }
}
