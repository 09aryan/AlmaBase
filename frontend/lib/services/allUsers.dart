import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/upDateBio.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AllUsers {
  static Future<List<dynamic>> fechUsers() async {
    final response = await http.get(Uri.parse(''));
    try {
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['users'];
      } else {
        print('Error feching users');
        return [];
      }
    } catch (err) {
      print('error while fecthing users ${err}');
      return [];
    }
  }
}
