import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:frontend/constent/VideoPlayerWidget.dart';
import 'package:frontend/model/authToken.dart';
import 'package:frontend/provider/user.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  ChatPage({required this.chatId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late IO.Socket socket;
  List<Map<String, dynamic>> _messages = [];
  TextEditingController _messageController = TextEditingController();
  late List<File> _pickedFiles = [];

  Future<Uint8List?> _loadImage(String url) async {
    try {
      if (url.contains('mp4') || url.contains('avi')) {
        final thumbnailPath = await VideoThumbnail.thumbnailFile(
          video: url,
          thumbnailPath: (await getTemporaryDirectory()).path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: 120,
          quality: 25,
        );

        return File(thumbnailPath!).readAsBytesSync();
      } else {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          return response.bodyBytes;
        } else {
          throw Exception(
              'Failed to load image. Status code: ${response.statusCode}');
        }
      }
    } catch (e, stackTrace) {
      print('Error loading media: $e\n$stackTrace');
      return null;
    }
  }

  Widget _buildMediaContent(List mediaURLs) {
    return Column(
      children: mediaURLs.map<Widget>((mediaURL) {
        if (mediaURL.toString().contains('mp4') ||
            mediaURL.toString().contains('avi')) {
          return VideoPlayerr(url: mediaURL);
        } else {
          return FutureBuilder(
            future: _loadImage(mediaURL),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.data != null) {
                return Image.memory(snapshot.data as Uint8List);
              } else if (snapshot.hasError) {
                print('Error loading media: ${snapshot.error}');
                return Container(); // Display an empty container on error
              } else {
                return CircularProgressIndicator();
              }
            },
          );
        }
      }).toList(),
    );
  }

  Widget _buildMessageBubble({
    required bool isMyMessage,
    required Widget content,
    required String userProfilePic,
    required String userName,
  }) {
    return Row(
      mainAxisAlignment:
          isMyMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isMyMessage) // Add this condition for sender's content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userProfilePic),
              ),
              Text(
                userName,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        Container(
          margin: EdgeInsets.all(8.0),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isMyMessage ? Colors.indigo : Colors.orange,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMyMessage ? 16.0 : 0.0),
              topRight: Radius.circular(isMyMessage ? 0.0 : 16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.7,
            ),
            child: content,
          ),
        ),
        if (isMyMessage) // Add this condition for sender's content
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(userProfilePic),
              ),
              Text(
                userName,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
      ],
    );
  }

  void _fetchChatMessages() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://almabase.onrender.com/app/v1/message/${widget.chatId}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        // Sort messages by updated time
        data.sort((a, b) {
          final DateTime timeA = DateTime.parse(a['updatedAt']);
          final DateTime timeB = DateTime.parse(b['updatedAt']);
          return timeB.compareTo(timeA);
        });

        setState(() {
          _messages = List.from(data);
          print(_messages);
        });
      } else {
        print(
            'Error fetching chat messages. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  Future<void> _sendMessage() async {
    try {
      final messageData = {
        'chatId': widget.chatId,
        'content': _messageController.text,
        'senderId': Provider.of<UserProvider>(context, listen: false).user?.id,
      };
      String? authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken ?? '';
      print(authToken);

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://almabase.onrender.com/app/v1/message'),
      );

      request.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Authorization': authToken,
      });

      request.fields['chatId'] = widget.chatId;
      request.fields['content'] = _messageController.text;

      for (File pickedFile in _pickedFiles) {
        request.files.add(await http.MultipartFile.fromPath(
          'media',
          pickedFile.path,
        ));
      }

      final response = await request.send();

      if (response.statusCode == 200) {
        socket.emit('new message', messageData);
        _fetchChatMessages();
        _messageController.clear();
        _pickedFiles.clear();
      } else {
        print('Error sending message: ${response.statusCode}');
        print('Response body: ${await response.stream.bytesToString()}');
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  Future<void> _pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'jpg',
          'jpeg',
          'png',
          'mp4',
          'avi',
          'mov',
          'mkv'
        ], // Add video extensions
        allowMultiple: true,
      );

      if (result != null) {
        List<File> pickedFiles =
            result.files.map((file) => File(file.path!)).toList();

        setState(() {
          _pickedFiles = pickedFiles;
        });
      }
    } catch (e) {
      print('Error picking files: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchChatMessages();

    // Connect to the Socket.io server
    socket = IO.io('https://almabase.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true, // Connect automatically
    });

    // Handle socket events
    socket.onConnect((_) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      print('Connected to socket.io');
      socket.emit('setup', {'_id': userProvider.user?.id});
      socket.emit('join chat', widget.chatId);
    });

    socket.on('message received', (data) {
      print('Received new message: $data');
      // Handle the received message
      _fetchChatMessages();
    });

    socket.connect();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          if (_pickedFiles.isNotEmpty)
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.red),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _pickedFiles.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _pickedFiles[index].toString().contains('mp4') ||
                            _pickedFiles[index].toString().contains('avi')
                        ? VideoPlayerr(url: _pickedFiles[index].path)
                        : Image.file(
                            _pickedFiles[index],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                          ),
                  );
                },
              ),
            ),
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final sender = message['sender'];
                final isMyMessage =
                    sender != null && sender['_id'] == userProvider.user?.id;

                return _buildMessageBubble(
                  isMyMessage: isMyMessage,
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (message['mediaURLs'] != null &&
                          message['mediaURLs'].isNotEmpty)
                        _buildMediaContent(message['mediaURLs']),
                      Text(
                        message['content'],
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  userProfilePic: sender['profilepic'],
                  userName: sender['userName'] ?? '',
                );
              },
            ),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(color: Colors.grey.shade300),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(25.0),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    child: Icon(Icons.send),
                  ),
                  SizedBox(width: 8.0),
                  FloatingActionButton(
                    onPressed: _pickFiles,
                    child: Icon(Icons.attach_file),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
