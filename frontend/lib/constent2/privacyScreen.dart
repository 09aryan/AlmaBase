import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: PrivacyPolicy(),
  ));
}

class PrivacyPolicy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              pinned: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              expandedHeight: 120.0,
              backgroundColor: const Color.fromARGB(255, 173, 137, 137),
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                centerTitle: true,
              ),
            ),
          ];
        },
        body: Builder(
          builder: (BuildContext context) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      _buildPrivacyPolicySection(
                        'Introduction',
                        'AlmaMingle respects your privacy. This Privacy Policy explains how AlmaMingle collects, uses, and discloses your personal information.',
                      ),
                      _buildPrivacyPolicySection(
                        'Information We Collect',
                        'We collect personal information about you when you use AlmaMingle, including:\n- Your name, email address, and other information you provide when you create an account\n- Your profile information, including your name, graduation year, and other information you choose to share\n- Your interactions with other users, such as the messages you send and receive\n- Your use of AlmaMingle features, such as the groups you join and the events you attend\nWe may also collect information about your computer or device, such as your IP address, browser type, and operating system.',
                      ),
                      _buildPrivacyPolicySection(
                        'How We Use Your Information',
                        'We use your personal information to:\n\n'
                            'Provide and improve AlmaMingle\n'
                            'Connect you with other alumni\n'
                            'Send you communications about AlmaMingle and other services\n'
                            'Personalize your experience on AlmaMingle\n'
                            'Comply with our legal obligations',
                      ),
                      _buildPrivacyPolicySection(
                        'Information Sharing',
                        'We may share your personal information with:\n\n'
                            'Third-party service providers who help us operate AlmaMingle\n'
                            'Other alumni with whom you choose to connect\n'
                            'Law enforcement agencies, if required by law\n'
                            'We will not share your personal information with third-party advertisers without your consent.',
                      ),
                      _buildPrivacyPolicySection(
                        'Data Security',
                        'We take reasonable precautions to protect your personal information from unauthorized access, use, disclosure, alteration, or destruction.',
                      ),
                      _buildPrivacyPolicySection(
                        'Your Choices',
                        'You can control your privacy settings on AlmaMingle. You can also request to delete your account by contacting us at [email protected]',
                      ), // Add other sections here
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildPrivacyPolicySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            content,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }
}
