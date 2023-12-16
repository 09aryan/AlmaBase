import 'package:frontend/model/post.dart';
import 'package:frontend/model/userModel.dart';

// Assuming you have a Post class

class Like {
  final String id; // Assuming you have an ID field in your Mongoose schema
  final User user;
  final Post post;

  Like({
    required this.id,
    required this.user,
    required this.post,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      id: json['_id'],
      user: User.fromJson(json['user']),
      post: Post.fromJson(json['post']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': user.toMap(),
      'post': post.toMap(),
    };
  }
}
