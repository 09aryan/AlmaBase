import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constent/inputTextwithCallBack.dart';
import 'package:frontend/constent/nav_bar.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateApost extends StatefulWidget {
  const CreateApost({Key? key}) : super(key: key);

  @override
  State<CreateApost> createState() => _CreateApostState();
}

class _CreateApostState extends State<CreateApost> {
  final TextEditingController captionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController tagsController = TextEditingController();
  final TextEditingController taggedUsersController = TextEditingController();
  List<File> imagesFiles = [];
  List<User> userSuggestions = [];
  List<User> taggedUsers = [];
  List<dynamic> likedUsers = [];
  bool isCreatingPost = false;

  PageController _pageController = PageController();

  Future<void> createPost() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        'https://almabase.onrender.com/app/v1/create-post/${userProvider.user!.id}',
      ),
    );
    request.fields['caption'] = captionController.text;
    request.fields['location'] = locationController.text;
    request.fields['taggedUsers'] =
        taggedUsers.map((user) => user.userName).join(',');
    request.fields['tags'] = tagsController.text;

    for (int i = 0; i < imagesFiles.length; i++) {
      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imagesFiles[i].path,
      ));
    }

    try {
      setState(() {
        isCreatingPost = true;
      });
      var response = await request.send();
      if (response.statusCode == 201) {
        print('Post created successfully');
      } else {
        print('Failed to create post: ${response.statusCode}');
      }
    } catch (e) {
      print('Error creating post: $e');
    } finally {
      setState(() {
        isCreatingPost = false;
      });
    }
  }

  Future<void> searchUsers(String query) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String apiUrl = 'https://almabase.onrender.com/app/v1/search/$query';

    try {
      var response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        if (query.isNotEmpty) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> usersData = data['users'];
          setState(() {
            userSuggestions =
                usersData.map((user) => User.fromJson(user)).toList();
          });
        }
      } else {
        print('Failed to search users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error searching users: $e');
    }
  }

  Future<List<File>> pickMultipleImages() async {
    List<XFile> xFiles = await ImagePicker().pickMultiImage();
    return xFiles.map((xFile) => File(xFile.path)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A Post'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MyHomePag()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Select Images:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                height: 200,
                child: imagesFiles.isEmpty
                    ? GestureDetector(
                        onTap: () async {
                          List<File> selectedImageFiles =
                              await pickMultipleImages();
                          setState(() {
                            imagesFiles = selectedImageFiles;
                            _pageController = PageController();
                          });
                        },
                        child: Container(
                          color: Colors.grey[100],
                          child: Icon(
                            Icons.add_a_photo,
                            size: 100,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : PageView.builder(
                        controller: _pageController,
                        itemCount: imagesFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              imagesFiles[index],
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 10,
              ),
              InputTextWithCallback(
                label: 'Caption',
                icon: Icons.post_add_outlined,
                controller: captionController,
              ),
              SizedBox(height: 10),
              InputTextWithCallback(
                label: 'Location',
                icon: Icons.location_city_outlined,
                controller: locationController,
              ),
              SizedBox(height: 10),
              InputTextWithCallback(
                label: 'Tags',
                icon: Icons.tag_outlined,
                controller: tagsController,
              ),
              SizedBox(height: 10),
              InputTextWithCallback(
                label: 'Tagged Users',
                icon: Icons.tag_faces_outlined,
                controller: taggedUsersController,
                onChanged: searchUsers,
              ),
              if (userSuggestions.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 8),
                    Text('User Suggestions:'),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: userSuggestions.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundImage: NetworkImage(
                                  userSuggestions[index].profilePic,
                                ),
                              ),
                              SizedBox(width: 8),
                              Text(userSuggestions[index].userName),
                            ],
                          ),
                          onTap: () {
                            final selectedUser = userSuggestions[index];
                            if (!taggedUsers.contains(selectedUser)) {
                              setState(() {
                                taggedUsers.add(selectedUser);
                              });
                            }
                            taggedUsersController.clear();
                            setState(() {
                              userSuggestions = [];
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              if (taggedUsers.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 16),
                    Text(
                      'Tagged Users:',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (var user in taggedUsers)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundImage: NetworkImage(
                                      user.profilePic,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    user.userName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 16),
              if (imagesFiles.isNotEmpty)
                Column(
                  children: [
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: createPost,
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 248, 146, 62),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: isCreatingPost
                          ? CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : Text(
                              'Post',
                              style: TextStyle(fontSize: 20),
                            ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class User {
  final String id;
  final String userName;
  final String profilePic;

  User({
    required this.id,
    required this.userName,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'],
      userName: json['userName'],
      profilePic: json['profilepic'],
    );
  }
}
