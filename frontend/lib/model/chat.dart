// chat_model.dart
import 'package:flutter/foundation.dart';

class Chat {
  final String id;
  final String chatName;
  final String latestMessageContent;
  final String latestMessageSenderName;
  final String latestMessageSenderProfilePic;
  Chat(
      {required this.id,
      required this.chatName,
      required this.latestMessageContent,
      required this.latestMessageSenderName,
      required this.latestMessageSenderProfilePic});
}
// chat_provider.dart

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];

  List<Chat> get chats => _chats;

  set chats(List<Chat> value) {
    _chats = value;
    notifyListeners();
  }
}
