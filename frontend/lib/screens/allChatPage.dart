import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:frontend/services/fetchCHats.dart';
import 'package:frontend/services/latestMessage.dart';
import 'package:frontend/model/chat.dart';
import 'package:frontend/provider/user.dart';
import 'package:frontend/screens/chatPagee.dart';
import 'package:frontend/screens/seacrhPage.dart';
import 'package:provider/provider.dart';

class ChatsPage extends StatefulWidget {
  @override
  _ChatsPageState createState() => _ChatsPageState();
}

class _ChatsPageState extends State<ChatsPage> {
  late IO.Socket socket;
  late List<Chat> chats = []; // Initialize as an empty list

  @override
  void initState() {
    super.initState();
    initializeSocketConnection();
    connectToSocket();
    fetchChatsOnInit();
  }

  void initializeSocketConnection() {
    socket = IO.io('https://almabase.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });
  }

  void connectToSocket() {
    socket.connect();
    handleSocketEvents();
  }

  void handleSocketEvents() {
    socket.on('connected', (_) {
      print('Connected to socket.io');
    });

    socket.on('message received', (data) {
      print('Received new message: $data');
      // Handle the received message
    });

    // Add more event listeners as needed
  }

  void fetchChatsOnInit() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final String userId = userProvider.user!.id;

    try {
      List<Chat> fetchedChats = await ApiService.fetchChats(userId, context);
      setState(() {
        chats = fetchedChats;
      });
    } catch (error) {
      print('Error fetching chats initially: $error');
      // Handle the error as needed
    }
  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('My Chats', style: TextStyle(color: Colors.grey[800])),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.grey[800]),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: buildChatListView(),
    );
  }

  Widget buildChatListView() {
    if (chats.isEmpty) {
      return Center(child: CircularProgressIndicator());
    } else {
      return ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return buildChatTile(chat);
        },
      );
    }
  }

  Widget buildChatTile(Chat chat) {
    return FutureBuilder<String?>(
      future: ApiServices.fetchMessageContent(chat.latestMessageContent),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final latestMessageContent =
              snapshot.data?.toString() ?? 'No message';

          return GestureDetector(
            onTap: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(chatId: chat.id),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
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
                height: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(0),
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundImage: NetworkImage(
                        chat.latestMessageSenderProfilePic ??
                            'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
                      ),
                    ),
                    title: Text(
                      chat.chatName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    subtitle: Text(
                      'Latest Message: $latestMessageContent',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
