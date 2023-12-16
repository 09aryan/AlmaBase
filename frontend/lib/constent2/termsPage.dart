import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: TermsOfService(),
  ));
}

class TermsOfService extends StatelessWidget {
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
              flexibleSpace: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return FlexibleSpaceBar(
                    title: Opacity(
                      opacity: constraints.biggest.height > 80 ? 1.0 : 0.0,
                      child: Text(
                        'Terms of Service',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    centerTitle: true,
                  );
                },
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: Text(
                  'Last updated: [Date]',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SectionTitle(title: '1. Acceptance of Terms'),
              TextContent(
                text:
                    'By accessing or using [Your Alumni Connection App Name] ("the App"), you agree to comply with and be bound by these Terms of Service. If you do not agree with these terms, please refrain from using the App.',
              ),
              SectionTitle(title: '1. Acceptance of Terms'),
              TextContent(
                text:
                    'By accessing or using [Your Alumni Connection App Name] ("the App"), you agree to comply with and be bound by these Terms of Service. If you do not agree with these terms, please refrain from using the App.',
              ),
              SizedBox(height: 20.0),

// Add other sections here

              SectionTitle(title: '2. User Eligibility'),
              TextContent(
                text:
                    'You must be at least [age] years old to use the App. By using the App, you represent and warrant that you meet the eligibility criteria.',
              ),
              SizedBox(height: 20.0),

              SectionTitle(title: '3. User Account'),
              TextContent(
                text:
                    'a. Registration: To access certain features of the App, you may be required to register for an account. You agree to provide accurate and complete information during the registration process.\n\n'
                    'b. Account Security: You are responsible for maintaining the confidentiality of your account credentials and are solely responsible for any activities that occur under your account.',
              ),
              SizedBox(height: 20.0), // Add other sections here
            ],
          ),
        ),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }
}

class TextContent extends StatelessWidget {
  final String text;

  const TextContent({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.0,
        color: Colors.black87,
        height: 1.4,
      ),
    );
  }
}
