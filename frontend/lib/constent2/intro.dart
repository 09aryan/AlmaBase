import 'package:flutter/material.dart';
import 'package:frontend/screens/signin.dart';

class AnimatedSplashScreen extends StatefulWidget {
  @override
  _AnimatedSplashScreenState createState() => _AnimatedSplashScreenState();
  static const String id = '/onboarding';
}

class _AnimatedSplashScreenState extends State<AnimatedSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _animationController.forward().then((_) {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: FadeTransition(
            opacity: _animation,
            child: Center(
              child: Image.asset(
                'assets/intro1.jpeg',
                width: 150,
                height: 200,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Connect with Alumni',
      'subtitle': 'Network with former classmates and professionals.',
      'image': 'assets/intro1.jpeg',
    },
    {
      'title': 'Explore Opportunities',
      'subtitle': 'Discover job openings and career advancement.',
      'image': 'assets/intro2.jpeg',
    },
    {
      'title': 'Stay Updated',
      'subtitle': 'Get news and events about your alma mater.',
      'image': 'assets/d.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return OnboardingPage(
                  title: onboardingData[index]['title']!,
                  subtitle: onboardingData[index]['subtitle']!,
                  image: onboardingData[index]['image']!,
                  pageController: _pageController,
                  currentPage: _currentPage,
                  totalPages: onboardingData.length,
                );
              },
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: onboardingData.map((data) {
                int index = onboardingData.indexOf(data);
                return Container(
                  width: 10.0,
                  height: 10.0,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue : Colors.grey,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final PageController pageController;
  final int currentPage;
  final int totalPages;

  const OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.pageController,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: FractionallySizedBox(
              heightFactor: 0.9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.0),
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SizedBox(height: 00),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          SizedBox(height: 40),
          if (currentPage < totalPages - 1)
            ElevatedButton(
              onPressed: () {
                int nextPage = currentPage + 1;
                pageController.animateToPage(
                  nextPage,
                  duration: Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 240, 177, 19),
              ),
            ),
          if (currentPage == totalPages - 1)
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              child: Text('Get Started'),
              style: ElevatedButton.styleFrom(
                primary: Color.fromARGB(255, 240, 177, 19),
              ),
            ),
        ],
      ),
    );
  }
}
