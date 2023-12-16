import 'package:frontend/model/post.dart';
import 'package:frontend/model/userModel.dart';

// Assuming you have a Post class

class Comment {
  final String id; // Assuming you have an ID field in your Mongoose schema
  final User user;
  final Post post;
  final String text;
  final DateTime createdAt;
  final List<User> taggedUsers;

  Comment({
    required this.id,
    required this.user,
    required this.post,
    required this.text,
    required this.createdAt,
    required this.taggedUsers,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['_id'],
      user: User.fromJson(json['user']),
      post: Post.fromJson(json['post']),
      text: json['text'],
      createdAt: DateTime.parse(json['createdAt']),
      taggedUsers: (json['taggedUsers'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toMap(),
      'post': post.toMap(),
      'text': text,
      'createdAt': createdAt.toIso8601String(),
      'taggedUsers': taggedUsers.map((user) => user.toJson()).toList(),
    };
  }
}
