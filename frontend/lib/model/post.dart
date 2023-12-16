import 'package:frontend/model/comment.dart';
import 'package:frontend/model/like.dart';
import 'package:frontend/model/userModel.dart';

// Assuming you have a User class

class Post {
  final String id; // Assuming you have an ID field in your Mongoose schema
  final User user;
  final List<Comment> comments;
  final List<Like> likes;
  final String caption;
  final String location;
  final String media;
  final DateTime createdAt;
  final List<String> tags;
  final List<User> taggedUsers;

  Post({
    required this.id,
    required this.user,
    required this.comments,
    required this.likes,
    required this.caption,
    required this.location,
    required this.media,
    required this.createdAt,
    required this.tags,
    required this.taggedUsers,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      user: User.fromJson(json['user']),
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) => Comment.fromJson(commentJson))
          .toList(),
      likes: (json['likes'] as List<dynamic>)
          .map((likeJson) => Like.fromJson(likeJson))
          .toList(),
      caption: json['caption'],
      location: json['location'],
      media: json['media'],
      createdAt: DateTime.parse(json['createdAt']),
      tags: (json['tags'] as List<dynamic>).cast<String>(),
      taggedUsers: (json['taggedUsers'] as List<dynamic>)
          .map((userJson) => User.fromJson(userJson))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'user': user.toJson(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
      'likes': likes.map((like) => like.toJson()).toList(),
      'caption': caption,
      'location': location,
      'media': media,
      'createdAt': createdAt.toIso8601String(),
      'tags': tags,
      'taggedUsers': taggedUsers.map((user) => user.toJson()).toList(),
    };
  }
}
