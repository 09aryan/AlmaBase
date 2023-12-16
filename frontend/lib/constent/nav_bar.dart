import 'package:flutter/material.dart';

import 'package:frontend/screens/addStrory.dart';

import 'package:frontend/screens/allChatPage.dart';
import 'package:frontend/screens/allContents.dart';

import 'package:frontend/screens/userDetails.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../constent2/morePage.dart';

class MyHomePag extends StatefulWidget {
  const MyHomePag({Key? key}) : super(key: key);

  @override
  _MyHomePagState createState() => _MyHomePagState();
}

class _MyHomePagState extends State<MyHomePag> {
  late PageController _pageController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: selectedIndex);
  }

  void onTabTapped(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _listOfWidget,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.white,
        color: Colors.white, // Change as needed
        buttonBackgroundColor:
            const Color.fromARGB(255, 212, 229, 244), // Change as needed
        height: 50,
        items: [
          Icon(Icons.post_add, size: 30),
          Icon(Icons.person_2_outlined, size: 30),
          Icon(Icons.chat_rounded, size: 30),
          Icon(Icons.settings_rounded, size: 30),
        ],
        onTap: onTabTapped,
      ),
    );
  }

  List<Widget> _listOfWidget = <Widget>[
    AllContentsPage(),
    UserInformationPage(),
    ChatsPage(),
    MoreItemsPagee(),
  ];
}
