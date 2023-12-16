import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/model/userModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter/foundation.dart';

class UserProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;
  void setUser(String userData) {
    _user = User.fromJson(userData);
    notifyListeners();
  }

  void setUserFromModel(User user) {
    _user = user;
    notifyListeners();
  }
}
    // final userProvider =
    //                 Provider.of<UserProvider>(context, listen: false);
    //             final isMyMessage =
    //                 sender != null && sender['_id'] == userProvider.user?.id;