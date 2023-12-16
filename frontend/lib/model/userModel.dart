import 'dart:convert';

class User {
  final String id;
  final String userName;
  final String fullName;
  final String password;
  final String email;
  final String profilePic;
  final String bio;
  final int points;
  final String token;
  final List<String> stories; // List of story IDs
  final List<String> posts; // List of post IDs

  User({
    required this.id,
    required this.token,
    required this.userName,
    required this.fullName,
    required this.password,
    required this.email,
    required this.profilePic,
    required this.bio,
    required this.points,
    required this.stories,
    required this.posts,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userName': userName,
      'email': email,
      'password': password,
      'bio': bio,
      'profilePic': profilePic,
      'poinst': points,
      'fullName': fullName,
      'token': token,
      'stories': stories,
      'posts': posts,
    };
  }

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json['user']['_id'] ?? '',
      userName: json['user']['userName'] ?? '',
      fullName: json['user']['fullName'] ??
          '', // There is no 'fullName' in the provided response, you might need to adjust accordingly.
      password: json['user']['password'] ??
          '', // There is no 'password' in the provided response, you might need to adjust accordingly.
      email: json['user']['email'] ?? '',
      profilePic: json['user']['profilepic'] ?? '',
      bio: json['user']['bio'] ?? '',
      points:
          0, // You might need to adjust this depending on your actual response structure.
      token: json['token'] ?? '',
      stories: List<String>.from(json['stories'] ?? []),
      posts: List<String>.from(json['posts'] ?? []),
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
  User copyWith({
    String? id,
    String? userName,
    String? fullName,
    String? password,
    String? email,
    String? profilePic,
    String? bio,
    int? points,
    String? token,
    List<String>? stories,
    List<String>? posts,
  }) {
    return User(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      fullName: fullName ?? this.fullName,
      password: password ?? this.password,
      email: email ?? this.email,
      profilePic: profilePic ?? this.profilePic,
      bio: bio ?? this.bio,
      points: points ?? this.points,
      token: token ?? this.token,
      stories: stories ?? this.stories,
      posts: posts ?? this.posts,
    );
  }
}

