import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class UserDetails {
  static Future<Map<String, dynamic>> fetchDetails({
    required BuildContext context,
    required final String userId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await http.get(Uri.parse(
          'https://almabase.onrender.com/app/v1/user-details/${userId}'));
      if (response.statusCode == 200) {
        print('  a                ');
        // print(jsonDecode(response.body));
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load user details');
      }
    } catch (errr) {
      print('Error fetching details: $errr');
      throw Exception('Error fetching user details');
      ;
    }
  }
}
