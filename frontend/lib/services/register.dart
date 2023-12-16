import 'dart:io';

import 'package:frontend/screens/signin.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';

class RegistrationService {
  static Future<void> registerUser({
    required String fullName,
    required BuildContext context,
    required String userName,
    required String email,
    required String password,
    required File pickedImage,
  }) async {
    try {
      if (pickedImage == null) {
        print('Please Select an Profile Pic');
        return;
      }
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://almabase.onrender.com/app/v1/signup'));
      request.fields['fullName'] = fullName;
      request.fields['userName'] = userName;
      request.fields['email'] = email;
      request.fields['password'] = password;
      request.files.add(http.MultipartFile.fromBytes(
          'file', await pickedImage!.readAsBytes(),
          filename: 'profile_pic.jpg',
          contentType: MediaType('image', 'jpeg')));
      var response = await request.send();

      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Login()),
        );
        print('User registered successfully');
      } else {
        print('User registration failed');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error registering user: $error');
    }
  }
}
