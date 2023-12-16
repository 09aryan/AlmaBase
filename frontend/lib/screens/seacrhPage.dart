import 'package:flutter/material.dart';
import 'package:frontend/model/authToken.dart';
import 'package:frontend/screens/chatPagee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/provider/user.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _searchUsers(String userName) async {
    final response = await http.get(
        Uri.parse('https://almabase.onrender.com/app/v1/search/$userName'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _searchResults = List.from(data['users']);
      });
    } else {
      print('Error searching users');
    }
  }

  Future<void> createChatWithUser(String userId) async {
    try {
      String authToken =
          Provider.of<AuthProvider>(context, listen: false).authToken ?? '';
      print('Auth Token: $authToken');

      final response = await http.post(
        Uri.parse('https://almabase.onrender.com/app/v1/chat/access'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': authToken,
        },
        body: json.encode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final chatId = responseData['_id'];
        print('Chat ID: $chatId');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(chatId: chatId),
          ),
        );
      } else {
        print('Error creating chat: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Network error: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: Colors.grey[200],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                _searchUsers(value);
              },
              decoration: InputDecoration(
                hintText: 'Search for users...',
                prefixIcon: Icon(Icons.search, color: Colors.grey),
                border: InputBorder.none,
              ),
            ),
          ),
          SizedBox(height: 16.0),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final user = _searchResults[index];
                return Card(
                  color: Colors.white,
                  elevation: 2.0,
                  child: ListTile(
                    title: Text(
                      user['userName'],
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Bio: ${user['bio']}',
                      style: TextStyle(
                        color: Colors.grey[800],
                      ),
                    ),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        user['profilepic'] ??
                            'https://example.com/default-image.jpg',
                      ),
                    ),
                    onTap: () {
                      createChatWithUser(user['_id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
