import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/screens/otherUser.dart';
import 'package:frontend/services/userDetails.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/authToken.dart';
import 'package:frontend/provider/user.dart';
import 'package:provider/provider.dart';
import 'package:carousel_slider/carousel_slider.dart';

class PostItemWidget extends StatefulWidget {
  final dynamic post;

  const PostItemWidget({required this.post});

  @override
  _PostItemWidgetState createState() => _PostItemWidgetState();
}

class _PostItemWidgetState extends State<PostItemWidget> {
  late bool isLiked;
  List<dynamic> likedUsers = [];
  late TextEditingController commentController;

  @override
  void initState() {
    super.initState();
    isLiked = widget.post['likes'].contains(
      Provider.of<UserProvider>(context, listen: false).user?.id,
    );
    commentController = TextEditingController();
  }

  Future<void> onLike(BuildContext context, dynamic post) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
      final postId = post['_id'];
      String? authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken ?? '';
      final response = await http.post(
        Uri.parse('https://almabase.onrender.com/app/v1/like/$postId'),
        headers: {'Authorization': authToken},
        body: {'userId': userId, 'postId': postId},
      );

      if (response.statusCode == 200) {
        print('liked the photo');
        setState(() {
          isLiked = true;
        });
      } else {
        print('Error liking the post: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> onGetComments(BuildContext context, dynamic post) async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://almabase.onrender.com/app/v1/post/${post['_id']}/comments'),
      );

      if (response.statusCode == 200) {
        final comments = jsonDecode(response.body)['comments'];
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Comments'),
              content: Column(
                children: comments
                    .map<Widget>((comment) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                NetworkImage(comment['userProfilePic']),
                          ),
                          title: Text(comment['userName']),
                          subtitle: Text(comment['text']),
                        ))
                    .toList(),
              ),
              actions: <Widget>[
                ElevatedButton(
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
        print('Error getting comments for the post: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> getLikedUsers(String postId) async {
    try {
      final response = await http.get(
        Uri.parse('https://almabase.onrender.com/app/v1/posts/$postId/likes'),
      );

      if (response.statusCode == 200) {
        final likes = jsonDecode(response.body)['likes'];
        setState(() {
          likedUsers = likes;
        });
      } else {
        print('Error getting likes for the post: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> onAddComment(BuildContext context, dynamic post) async {
    try {
      final userId = Provider.of<UserProvider>(context, listen: false).user?.id;
      final postId = post['_id'];
      final text = commentController.text;

      if (userId != null && text.isNotEmpty) {
        final response = await http.post(
          Uri.parse('https://almabase.onrender.com/app/v1/add-comment/$postId'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'userId': userId.toString(), 'text': text}),
        );

        if (response.statusCode == 201) {
          commentController.clear();
        } else {
          print('Error adding comment: ${response.statusCode}');
        }
      } else {
        print('Invalid comment data');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserInformationPage(
                          userId: widget.post['user']?['_id'] ?? '',
                        ),
                      ),
                    );
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: NetworkImage(
                      widget.post['user']?['profilepic'] ??
                          'https://images.unsplash.com/photo-1472214103451-9374bd1c798e?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8cGljfGVufDB8fDB8fHww',
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.post['user']?['userName'] ?? 'No username',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      widget.post['location'] ?? 'No location',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                widget.post['caption'] ?? 'No caption',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            // Rest of the ListTile properties...
          ),
          Container(
            height: 150,
            child: CarouselSlider(
              items: (widget.post['media'] ?? []).map<Widget>((url) {
                return Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      url ?? '',
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }).toList(),
              options: CarouselOptions(
                height: 150.0,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                autoPlay: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => onLike(context, widget.post),
                      icon: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.black,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () async {
                        await getLikedUsers(widget.post['_id'] ?? '');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Liked Users'),
                              content: Column(
                                children: likedUsers
                                    .map<Widget>((user) => ListTile(
                                          leading: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserInformationPage(
                                                    userId:
                                                        user['userId'] ?? '',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                user['profilepic'] ?? '',
                                              ),
                                            ),
                                          ),
                                          title: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      UserInformationPage(
                                                    userId:
                                                        user['userId'] ?? '',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Text(user['userName'] ?? ''),
                                          ),
                                        ))
                                    .toList(),
                              ),
                              actions: <Widget>[
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Text(
                        'Likes',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4.0),
                    GestureDetector(
                      onTap: () => onGetComments(context, widget.post),
                      child: const Text(
                        'Comments',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (widget.post['taggedUsers'] != null)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  const SizedBox(width: 4.0),
                  const Text(
                    'Tagged Users:',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  for (var userId in widget.post['taggedUsers'] ?? [])
                    FutureBuilder(
                      future: UserDetails.fetchDetails(
                        context: context,
                        userId: userId.toString(),
                      ),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final user = snapshot.data!['user'];
                          final userName = user['userName'] ?? 'No Name';

                          return Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserInformationPage(
                                          userId: userId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(user['profilepic'] ?? ''),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            UserInformationPage(
                                          userId: userId.toString(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    userName,
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                const Icon(
                  Icons.tag_sharp,
                  color: Colors.black,
                  size: 18,
                ),
                const SizedBox(width: 2.0),
                const Text(
                  'Tags:',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 2.0),
                Text(
                  '${widget.post['tags']?.join(', ') ?? 'No tags'}',
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 10.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 4.0),
                ElevatedButton(
                  onPressed: () => onAddComment(context, widget.post),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'Comment',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
