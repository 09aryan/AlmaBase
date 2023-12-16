import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constent/postItemWidget.dart';
import 'package:http/http.dart' as http;

class AllPostsWidget extends StatefulWidget {
  const AllPostsWidget({super.key});

  @override
  State<AllPostsWidget> createState() => _AllPostsWidgetState();
}

class _AllPostsWidgetState extends State<AllPostsWidget> {
  List<dynamic> posts = [];

  @override
  void initState() {
    super.initState();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    try {
      final response = await http
          .get(Uri.parse('https://almabase.onrender.com/app/v1/all-posts'));
      if (response.statusCode == 200) {
        print(response.body);
        // Sort the posts based on the timestamp (assuming there's a 'timestamp' field in each post)
        List<dynamic> fetchedPosts = jsonDecode(response.body)['posts'];
        fetchedPosts.sort((a, b) => b['createdAt'].compareTo(a['createdAt']));

        setState(() {
          posts = fetchedPosts;
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (err) {
      print('Error fetching posts: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.orange[100],
        body: ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostItemWidget(post: post);
          },
        ),
      ),
    );
  }
}
