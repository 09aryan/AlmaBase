import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiServices {
  static Future<String?> fetchMessageContent(String? messageId) async {
    try {
      if (messageId == null) {
        // If messageId is null, return a default message
        return 'Start a conversation';
      }

      final response = await http.get(
        Uri.parse('https://almabase.onrender.com/app/v1/messages/$messageId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> messageData = json.decode(response.body);
        final String content = messageData['content'] ?? 'media';

        return content;
      } else {
        // Handle error cases, e.g., message not found
        print('Error: ${response.statusCode}');
        return 'media';
      }
    } catch (error) {
      print('Error fetching message content: $error');
      return ' ';
    }
  }
}
