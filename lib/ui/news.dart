
import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/profile.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<NewsPage> {
  int _currentIndex = 3; // Set the initial index to NewsPage

  final List<Widget> destinations = [
    const HomePage(),
    const MoodPage(),
    const ForumPage(),
    const NewsPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destinations[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
     final width = MediaQuery.of(context).size.width;

    return Scaffold(
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          color: bluePrimary,
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: bluePrimary,
          showSelectedLabels: false,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          selectedIconTheme: IconThemeData(color: blueSecondary, size: 27),
          unselectedIconTheme: IconThemeData(color: grey, size: 27),
          currentIndex: _currentIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.mood),
              label: "Mood",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.forum_outlined),
              label: "Forum",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.newspaper_outlined),
              label: "News",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: "Profile",
            ),
          ],
        ),
      ),
      body: ListView(
        children: [Container(
          width: width * 0.9,
        )],
      ),
    );
  }
}
