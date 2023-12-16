import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static Future<Map<String, dynamic>> likePost(
      String postId, String userId) async {
    final String apiUrl = 'http://your-api-url.com/app/v1/like/$postId/$userId';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': userId,
          'postId': postId,
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Post liked successfully'};
      } else {
        return {
          'success': false,
          'message': 'Error liking the post: ${response.statusCode}'
        };
      }
    } catch (error) {
      return {'success': false, 'message': 'Error: $error'};
    }
  }
}
