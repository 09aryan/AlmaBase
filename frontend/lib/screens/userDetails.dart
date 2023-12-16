import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/authToken.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/services/userDetails.dart';
import 'package:provider/provider.dart';

class UserInformationPage extends StatefulWidget {
  const UserInformationPage({Key? key}) : super(key: key);

  @override
  _UserInformationPageState createState() => _UserInformationPageState();
}

class _UserInformationPageState extends State<UserInformationPage> {
  late Future<Map<String, dynamic>> userFuture;
  List<dynamic> comments = [];

  Future<void> _fetchPostComments(String postId) async {
    try {
      String? authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken ?? '';
      final response = await http.get(
        Uri.parse('https://almabase.onrender.com/app/v1/post/$postId/comments'),
        headers: {'Authorization': authToken},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        List<dynamic> fetchedComments = responseData['comments'];

        setState(() {
          comments = fetchedComments;
        });

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Comments'),
              content: Column(
                children: comments.map((comment) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(comment['userProfilePic']),
                    ),
                    title: Text(comment['userName']),
                    subtitle: Text(comment['text']),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to load comments');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<void> _showPostLikes(String postId) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
      String? authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken ?? '';
      final response = await http.get(
        Uri.parse('https://almabase.onrender.com/app/v1/all-likes/$postId'),
        headers: {'Authorization': authToken},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        List<dynamic> likes = responseData['likes'];

        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Likes'),
              content: Column(
                children: likes.map((like) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(like['profilepic']),
                    ),
                    title: Text(like['userName']),
                  );
                }).toList(),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        throw Exception('Failed to load likes');
      }
    } catch (error) {
      print(error);
    }
  }

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    userFuture = UserDetails.fetchDetails(
      context: context,
      userId: userProvider.user!.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('User Information'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            return const Center(
              child: Text('Error loading user details'),
            );
          } else {
            final user = snapshot.data!['user'];
            final posts = user?['posts'] as List<dynamic>?;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage:
                                NetworkImage(user?['profilepic'] ?? ''),
                          ),
                        ),
                        Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user?['userName'] ?? 'No username',
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                user?['bio'] ?? 'No bio',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.grey[800],
                                ),
                              ),
                              const SizedBox(height: 4.0),
                              Text(
                                'Points: ${user?['points'] ?? 0}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (posts != null && posts.isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 16.0),
                        Text(
                          'User Posts:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                        for (var post in posts)
                          if (post != null)
                            Card(
                              color: Colors.white,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          post['caption'] ?? 'No caption',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18.0,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 4.0),
                                            Text(post['location'] ??
                                                'No location'),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 150,
                                    child: CarouselSlider(
                                      items: (post['media'] as List<dynamic>?)
                                              ?.map<Widget>((url) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(3.0),
                                                child: Image.network(
                                                  url ?? '',
                                                  width: double.infinity,
                                                  height: 150,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            );
                                          }).toList() ??
                                          [],
                                      options: CarouselOptions(
                                        height: 150.0,
                                        viewportFraction: 1.0,
                                        enableInfiniteScroll: false,
                                        autoPlay: false,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () async {
                                            if (post['_id'] != null) {
                                              _showPostLikes(post['_id']);
                                            } else {
                                              print('Post ID is null');
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                              horizontal: 8.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              'View Likes',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 2.0),
                                        GestureDetector(
                                          onTap: () async {
                                            _fetchPostComments(post['_id']);
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 4.0,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.grey[100],
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              'View Comments',
                                              style: TextStyle(
                                                color: Colors.grey.shade800,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10.0),
                                      ],
                                    ),
                                  ),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: const Text(
                                            'Tagged Users:',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8.0),
                                        for (var userId in post['taggedUsers']
                                                as List<dynamic>? ??
                                            [])
                                          FutureBuilder(
                                            future: UserDetails.fetchDetails(
                                              context: context,
                                              userId: userId.toString(),
                                            ),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                      ConnectionState.done &&
                                                  snapshot.hasData) {
                                                final user =
                                                    snapshot.data!['user'];
                                                final userName =
                                                    user?['userName'] ??
                                                        'No Name';

                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Column(
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                          user?['profilepic'] ??
                                                              '',
                                                        ),
                                                      ),
                                                      Text(
                                                        userName,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.grey[800],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              } else {
                                                return SizedBox.shrink();
                                              }
                                            },
                                          ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.tag,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4.0),
                                        Text(
                                          'Tags: ${post['tags']?.join(', ') ?? 'No tags'}',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                      ],
                    )
                  else
                    Text(
                      'No posts',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
