import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/constent/nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class AllStoriesWidget extends StatefulWidget {
  @override
  State<AllStoriesWidget> createState() => _AllStoriesWidgetState();
}

class _AllStoriesWidgetState extends State<AllStoriesWidget> {
  List<dynamic> stories = [];

  @override
  void initState() {
    fetchStories();
    super.initState();
  }

  Future<void> fetchStories() async {
    try {
      final response = await http
          .get(Uri.parse('https://almabase.onrender.com/app/v1/stories'));
      if (response.statusCode == 200) {
        List<dynamic> fetchedStories = jsonDecode(response.body)['stories'];

        // Sort the stories based on the 'createdAt' field in descending order (latest first)
        fetchedStories.sort((a, b) {
          DateTime timeA = DateTime.parse(a['createdAt']);
          DateTime timeB = DateTime.parse(b['createdAt']);
          return timeB.compareTo(timeA);
        });

        setState(() {
          stories = fetchedStories;
        });
      } else {
        throw Exception('Failed to load stories');
      }
    } catch (err) {
      print('Error fetching stories: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      body: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: stories.length,
        itemBuilder: (context, index) {
          final story = stories[index];
          return GestureDetector(
            onTap: () {
              // Navigate to a screen displaying the details of the clicked story
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StoryDetailsScreen(story: story),
                ),
              );
            },
            child: StoryItemWidget(story: story),
          );
        },
      ),
    );
  }
}

// ... (previous code)

class StoryDetailsScreen extends StatelessWidget {
  final dynamic story;

  const StoryDetailsScreen({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[100],
      appBar: AppBar(
        title: Text('Alters'),
        backgroundColor: Colors.grey, // Set background color
        actions: [
          // Add a button to the right side of the AppBar
          IconButton(
            icon: Icon(Icons.navigate_next),
            onPressed: () {
              // Navigate to a new screen when the button is pressed
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      MyHomePag(), // Replace with your desired screen
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display user details at the top
          Padding(
            padding: const EdgeInsets.all(8.0), // Reduced padding
            child: Container(
              padding: const EdgeInsets.all(8.0), // Reduced padding
              decoration: BoxDecoration(
                color: Colors.grey[200], // Grey background
                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                border:
                    Border.all(color: Colors.white, width: 2.0), // White border
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(story['user']['profilepic']),
                    radius: 30.0, // Reduced radius
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'User: ${story['user']['userName']}',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Text color
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    'Bio: ${story['user']['bio'] ?? 'No bio'}',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.black, // Text color
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Display story details here
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Display text
                  if (story['text'] != null)
                    Container(
                      color: Colors.grey[200], // Grey background
                      margin: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SingleChildScrollView(
                          child: Text(
                            'Text: ${story['text']}',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black, // Text color
                            ),
                          ),
                        ),
                      ),
                    ),
                  // Display image
                  if (story['image'] != null)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey, // Border color
                          width: 2.0,
                        ),
                        borderRadius:
                            BorderRadius.circular(10.0), // Rounded corners
                      ),
                      margin: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          story['image'],
                          fit: BoxFit.cover,
                          height: 200.0,
                        ),
                      ),
                    ),
                  // Display video
                  if (story['video'] != null)
                    Container(
                      color: Colors.grey[200], // Grey background
                      padding: const EdgeInsets.all(8.0),
                      child: ChewieListItem(
                        videoPlayerController: VideoPlayerController.network(
                          story['video'],
                        ),
                      ),
                    ),
                  // ... Add more details as needed
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ... (remaining code)

class ChewieListItem extends StatefulWidget {
  final VideoPlayerController videoPlayerController;

  ChewieListItem({required this.videoPlayerController});

  @override
  _ChewieListItemState createState() => _ChewieListItemState();
}

class _ChewieListItemState extends State<ChewieListItem> {
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();
    _chewieController = ChewieController(
      videoPlayerController: widget.videoPlayerController,
      autoPlay: true,
      looping: true,
      aspectRatio: 16 / 9,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Chewie(controller: _chewieController),
    );
  }

  @override
  void dispose() {
    super.dispose();
    widget.videoPlayerController.dispose();
    _chewieController.dispose();
  }
}

class StoryItemWidget extends StatelessWidget {
  final dynamic story;

  const StoryItemWidget({Key? key, required this.story}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Check if 'story' is null or if 'user' is null
    if (story == null || story['user'] == null) {
      // Handle the case where the story or user is null
      return Container(
          color:
              Colors.orange[200]); // Return an empty container or a placeholder
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFD700), // Light Orange
            Color(0xFFFFA500), // Orange
            Color(0xFFFF8C00), // Darker Orange
          ],
        ),
      ),
      child: Container(
        color: Colors.orange[300],
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: [
              // Check if 'profilepic' is null before accessing it
              if (story['user']['profilepic'] != null)
                CircleAvatar(
                  backgroundImage: NetworkImage(story['user']['profilepic']),
                  radius: 25.0,
                ),
              // Check if 'userName' is null before accessing it
              if (story['user']['userName'] != null)
                Text(story['user']['userName']),
            ],
          ),
        ),
      ),
    );
  }
}
