import 'package:frontend/model/userModel.dart';

class Story {
  final String id; // Assuming you have an ID field in your Mongoose schema
  final User user;
  final String text;
  final String media;
  // final String video;
  final DateTime createdAt;

  Story({
    required this.id,
    required this.user,
    required this.text,
    required this.media,
    // required this.video,
    required this.createdAt,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['_id'],
      user: User.fromJson(json['user']),
      text: json['text'],
      media: json['media'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user': user.toJson(),
      'text': text,
      'media': media,
      // 'video': video,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
