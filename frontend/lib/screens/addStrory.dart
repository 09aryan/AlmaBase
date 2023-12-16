import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend/constent/nav_bar.dart';
import 'package:frontend/model/authToken.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class PostStoryPage extends StatefulWidget {
  @override
  _PostStoryPageState createState() => _PostStoryPageState();
}

class _PostStoryPageState extends State<PostStoryPage> {
  final TextEditingController textController = TextEditingController();
  List<File> imagesFiles = [];
  bool isPostingStory = false;

  Future<void> postStory() async {
    try {
      String? authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken;
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://almabase.onrender.com/app/v1/post-story'),
      );
      request.headers['Authorization'] = authToken!;
      request.fields['text'] = textController.text;

      for (int i = 0; i < imagesFiles.length; i++) {
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          imagesFiles[i].path,
        ));
      }

      setState(() {
        isPostingStory = true;
      });

      var response = await request.send();
      if (response.statusCode == 201) {
        print('Story posted successfully');
      } else {
        print('Error posting the story: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        isPostingStory = false;
      });
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
        title: const Text('Add An Alert'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyHomePag()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selected Images:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Container(
              height: 150.0,
              child: imagesFiles.isEmpty
                  ? GestureDetector(
                      onTap: () async {
                        List<File> selectedImageFiles =
                            await pickMultipleImages();
                        setState(() {
                          imagesFiles = selectedImageFiles;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.add_a_photo,
                            size: 60,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: imagesFiles.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              imagesFiles[index],
                              height: 120,
                              width: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: textController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'ADD DESCRCPTIOS',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isPostingStory ? null : postStory,
              style: ElevatedButton.styleFrom(
                primary: Colors.orange[300],
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              child: isPostingStory
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text(
                      'Post Story',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
