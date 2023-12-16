import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/constent/nav_bar.dart';
import 'package:frontend/model/userModel.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:frontend/screens/userDetails.dart';
import 'package:frontend/services/userDetails.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UpdateBio {
  static Future<void> updateBio({
    required final String userId,
    required final String bio,
    required BuildContext context,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final Map<String, dynamic> requestBody = {'bio': bio};
      final response = await http.put(
        Uri.parse(
            'https://almabase.onrender.com/app/v1/set-Bio/${userProvider.user!.id}'),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': userProvider.user!.token.toString()
        },
        body: jsonEncode(requestBody),
      );
      print(
          'https://almabase.onrender.com/app/v1/set-Bio/${userProvider.user!.id}');
      print('Response: ${response.body}');
      print('Status code: ${response.statusCode}');
      print(userId);
      if (response.statusCode == 200) {
        User updatedUser =
            userProvider.user!.copyWith(bio: jsonDecode(response.body)['bio']);
        userProvider.setUserFromModel(updatedUser);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyHomePag()),
        );
      } else {
        // Handle error
        print('Failed to update bio. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error updating bio: $error');
    }
  }
}
