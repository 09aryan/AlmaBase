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
      final response =
          await http.get(Uri.parse('http://10.0.9.246:1000/app/v1/all-posts'));
      if (response.statusCode == 200) {
        print(response.body);
        setState(() {
          posts = jsonDecode(response.body)['posts'];
        });
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (err) {
      print('Error fecthing posts:$err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        backgroundColor: Colors.orange[100],
        //    backgroundColor: Colors.green.shade100,
        //  backgroundColor: Color(0xFFFFC6FE),
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
