import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/styles/navigation.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/profile.dart';

class DetailPage extends StatefulWidget {
  
  DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int _currentIndex = 4;
  // Set the initial index to ProfilePage
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
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: bluePrimary,
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: height * 0.1),
            Padding(
              padding: const EdgeInsets.only(right: 250),
              child: ElevatedButton.icon(
                  style: backButton(context),
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text(
                    "Back",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.0375,
                    ),
                  )),
            ),
            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                    color: bluePrimary,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20)),
                width: width * 0.9,
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Set alignment to start
                  children: [
                    Text(
                      'Lorem Ipsum.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '18 Januari 2024 | 16.58',
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Image.network(
                      'https://picsum.photos/250?image=9',
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis convallis aliquam arcu, eget ullamcorper nulla consectetur eget. Quisque interdum vehicula orci, id mattis sapien congue a.',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(right: 30),
              child: Container(
                width: width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              // Add your logic for thumb up action
                            },
                            icon: Icon(
                              Icons.thumb_up_alt_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add your logic for thumb down action
                            },
                            icon: Icon(
                              Icons.thumb_down_alt_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add your logic for comment action
                            },
                            icon: Icon(
                              Icons.mode_comment_rounded,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Add your logic for share action
                            },
                            icon: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        showCommentsPopup(context);
                      },
                      child: const Text(
                        'View all comments',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'User 1',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          TextSpan(
                            text: ' i have a sad story bla bla bla ',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
