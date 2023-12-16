import 'package:flutter/material.dart';
import 'package:frontend/constent2/privacyScreen.dart';
import 'package:frontend/constent2/termsPage.dart';
import 'package:frontend/screens/upDateBio.dart';

class MoreItemsPagee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[200],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title:
            Text('More Items', style: TextStyle(color: Colors.grey.shade700)),
        backgroundColor: Colors.white, // Set app bar background color
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSection(context, 'Update Bio', [
              {'text': 'Update Bio', 'icon': Icons.update},
              {'text': 'Activity', 'icon': Icons.directions_run}
            ]),
            SizedBox(height: 24.0),
            _buildSection(context, 'Videos', [
              {'text': 'Promo Videos', 'icon': Icons.video_library},
              {'text': 'Help', 'icon': Icons.help}
            ]),
            SizedBox(height: 24.0),
            _buildSection(context, 'Others', [
              {'text': 'Terms of Service', 'icon': Icons.rule},
              {'text': 'Privacy Policy', 'icon': Icons.privacy_tip}
            ]),
            SizedBox(height: 24.0),
            _buildSection(context, 'App', [
              {'text': 'About', 'icon': Icons.info},
              {'text': 'Settings', 'icon': Icons.settings},
              {'text': 'FAQs', 'icon': Icons.question_answer}
            ]),
            SizedBox(height: 24.0),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, String title, List<Map<String, dynamic>> buttons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey[800], // Set text color to grey
          ),
        ),
        SizedBox(height: 8.0),
        Column(
          children: buttons
              .map((button) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if (button['text'] == 'Terms of Service') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsOfService(),
                            ),
                          );
                        } else if (button['text'] == 'Privacy Policy') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PrivacyPolicy(),
                            ),
                          );
                        } else if (button['text'] == 'Update Bio') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UpdateBioPage(),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.white, // Set button background to grey
                        onPrimary: Colors.grey[800], // Set text color to grey
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          side: BorderSide(
                              color: Colors
                                  .grey), // Set button border color to grey
                        ),
                        padding: EdgeInsets.all(16.0),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(button['icon'],
                              color: Colors.black), // Set icon color to grey
                          Expanded(
                            child: Container(
                              height: 50,
                              alignment: Alignment.center,
                              child: Text(
                                button['text'],
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Icon(Icons.arrow_forward,
                              color: Colors
                                  .grey[800]), // Set arrow icon color to grey
                        ],
                      ),
                    ),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
