import 'package:flutter/material.dart';
import 'package:frontend/screens/addStrory.dart';
import 'package:frontend/screens/all%20stories.dart';
import 'package:frontend/screens/allPost.dart';
import 'package:frontend/screens/postAPost.dart';

class AllContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
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
      child: GestureDetector(
        onTap: () {
          // Close the expanded buttons when tapping anywhere on the screen
          Navigator.of(context).pop();
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 30, left: 16),
                  child: Text(
                    'Almabase',
                    style: TextStyle(
                      fontSize: 32.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo, // Choose your preferred color
                    ),
                  ),
                ),
                Container(
                  height: 80.0, // Set your preferred height

                  child: AllStoriesWidget(),
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey[300],
                ),
                Container(
                  color: Colors.orange[100],
                  padding: EdgeInsets.only(left: 16, top: 8),
                  child: Text(
                    'All Posts',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo, // Choose your preferred color
                    ),
                  ),
                ),
                Expanded(
                  child: AllPostsWidget(),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: _StartFloatingButton(),
            ),
          ],
        ),
      ),
    ));
  }
}

class _StartFloatingButton extends StatefulWidget {
  @override
  _StartFloatingButtonState createState() => _StartFloatingButtonState();
}

class _StartFloatingButtonState extends State<_StartFloatingButton> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
        _showExpandedButtons(context);
      },
      child: Icon(
        _isExpanded ? Icons.close : Icons.add,
      ),
      backgroundColor: _isExpanded ? Colors.redAccent : Colors.orange,
      elevation: _isExpanded ? 8.0 : 6.0,
    );
  }

  void _showExpandedButtons(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostStoryPage(),
                        ),
                      );
                    },
                    child: Icon(Icons.play_arrow_outlined),
                    backgroundColor: Colors.indigo,
                  ),
                  SizedBox(width: 16),
                  FloatingActionButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CreateApost()),
                      );
                    },
                    child: Icon(Icons.post_add),
                    backgroundColor: Colors.indigo,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
