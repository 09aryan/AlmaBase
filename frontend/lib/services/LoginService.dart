import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/constent/nav_bar.dart';
import 'package:frontend/model/authToken.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static Future<void> loginUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('https://almabase.onrender.com/app/v1/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          'email': email.toString(),
          'password': password.toString(),
        }),
      );

      if (response.statusCode == 200) {
        // Successful login, handle the response
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print('Response body: ${response.body}');

        Provider.of<UserProvider>(context, listen: false)
            .setUser(response.body);
        Provider.of<AuthProvider>(context, listen: false)
            .setAuthToken(jsonDecode(response.body)['token']);
        await prefs.setString(
            'x-auth-token', jsonDecode(response.body)['token']);

        // Rebuild the widget tree
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePag()),
        );
      } else {
        // Failed login, handle the response
        print('Login failed. ${response.body}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error logging in: $error');
    }
  }
}
