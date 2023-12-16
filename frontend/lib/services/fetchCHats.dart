import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/model/authToken.dart';
import 'package:frontend/model/chat.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ApiService {
  static Future<List<Chat>> fetchChats(
      String userId, BuildContext context) async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final String currentUserId = userProvider.user!.id;
      String? authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken ?? '';
      final response = await http.get(
        Uri.parse('https://almabase.onrender.com/app/v1/chat/$userId'),
        headers: {
          'Authorization': authToken,
        },
      );

      print(response.body);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        final List<Chat> chats = data.map((chatData) {
          String latestMessageData = chatData['latestMessage'] ??
              ''; // Use the null-aware operator here
          String latestMessageSenderName = '';
          String latestMessageSenderProfilePic = '';
          String chatName = ''; // Initialize chatName

          // Check if the current user is the sender or receiver
          bool isCurrentUserSender = chatData['users'] != null &&
              chatData['users'].isNotEmpty &&
              chatData['users'][0]['_id'] == currentUserId;

          if (isCurrentUserSender) {
            // For sent messages, use the receiver's information
            latestMessageSenderName =
                chatData['users'][1]['userName'] ?? ''; // Use index 1
            latestMessageSenderProfilePic =
                chatData['users'][1]['profilepic'] ?? ''; // Use index 1
            chatName = latestMessageSenderName;
          } else {
            // For received messages, use the sender's information
            latestMessageSenderName =
                chatData['users'][0]['userName'] ?? ''; // Use index 0
            latestMessageSenderProfilePic =
                chatData['users'][0]['profilepic'] ?? ''; // Use index 0
            chatName = latestMessageSenderName;
          }

          print('Latest Message Sender Name: $latestMessageSenderName');
          print(
              'Latest Message Sender Profile Pic: $latestMessageSenderProfilePic');

          return Chat(
            id: chatData['_id'],
            chatName: chatName, // Set the chatName based on sender or receiver
            latestMessageContent: latestMessageData,
            latestMessageSenderName: latestMessageSenderName,
            latestMessageSenderProfilePic: latestMessageSenderProfilePic,
          );
        }).toList();

        print(chats);
        return chats;
      } else {
        throw Exception('Failed to load chats');
      }
    } catch (error) {
      print('Error fetching chats: $error');
      throw Exception('Failed to load chats. Please try again.');
    }
  }
}
