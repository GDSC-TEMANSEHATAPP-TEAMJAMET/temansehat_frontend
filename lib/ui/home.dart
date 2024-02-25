import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:temansehat_app/models/user.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/profile.dart';
import 'package:temansehat_app/ui/setting.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<User?> getUserData() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final response = await http.get(
      Uri.parse('$backendUri/api/users/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      User user = User(
        username: responseData['username'],
        bio: responseData['bio'],
        email: responseData['email'],
        pfp: responseData['pfp'],
      );
      return user;
    } else {
      return null; // Return null or handle the error accordingly
    }
  }

  int _currentIndex = 0;
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
    final List<Map<String, dynamic>> pageData = [
      {
        "image": "assets/forum.png",
        "title": "CommunitySehat",
        "description": "Need a friend to talk to? Here’s the place!",
      },
      {
        "image": "assets/news.png",
        "title": "InformationSehat",
        "description": "Your reliable source of mental health information",
      },
      {
        "image": "assets/mood.png",
        "title": "MoodSehat",
        "description": "Tell us how you feel today!",
      },
    ];

    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Image.asset('assets/text_logo2.png', height: 52, width: 126),
          centerTitle: true,
          backgroundColor: bluePrimary,
          leading: IconButton(
            icon: const Icon(
              Icons.settings_outlined,
              size: 30,
            ),
            color: Colors.white,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingPage()),
              );
            },
          ),
        ),
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
                  icon: Icon(Icons.home_outlined), label: "Home"),
              BottomNavigationBarItem(icon: Icon(Icons.mood), label: "Mood"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.forum_outlined), label: "Forum"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.newspaper_outlined), label: "News"),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline), label: "Profile"),
            ],
          ),
        ),
        body: FutureBuilder<User?>(
            future: getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else {
                User? user = snapshot.data;
                return Stack(children: [
                  Container(
                    width: double.infinity,
                    height: height * 0.2,
                    decoration: BoxDecoration(
                        color: bluePrimary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(width * 0.06),
                          bottomRight: Radius.circular(width * 0.06),
                        )),
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: height * 0.05,
                                right: width * 0.025,
                                left: width * 0.075),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: height * 0.0125),
                                  child: Text("Hello, ${user!.username}!",
                                      style: TextStyle(
                                          color: bgColor,
                                          fontSize: 17.5,
                                          fontWeight: FontWeight.bold)),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage()),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        20), // Adjust the radius as needed
                                    child:
                                        user.pfp != null
                                            ? Image.memory(
                                                base64Decode(user.pfp!),
                                                fit: BoxFit.cover,
                                                width: width * 0.35,
                                                height: width * 0.35,
                                              )
                                            :
                                        Image.asset(
                                      'assets/nopfp.jpg',
                                      fit: BoxFit.cover,
                                      width: width * 0.35,
                                      height: width * 0.35,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SizedBox(height: height * 0.0375),
                              Row(
                                children: [
                                  OutlinedButton(
                                    style: getButtonHome(context),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MoodPage()),
                                      );
                                    },
                                    child: Text("How're you feeling?",
                                        style: TextStyle(
                                            color: bluePrimary,
                                            fontSize: width * 0.034375)),
                                  ),
                                  Icon(Icons.arrow_forward_ios_rounded,
                                      color: bgColor),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: height * 0.0375),
                          Text(
                            "What do you wanna do today?",
                            style: TextStyle(color: bluePrimary),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: height * 0.02),
                            child: SizedBox(
                              height: height * 0.35,
                              child: ListView.builder(
                                scrollDirection:
                                    Axis.horizontal, // Set horizontal scrolling
                                itemCount: pageData.length,
                                itemBuilder: (context, index) {
                                  final page = pageData[
                                      index]; // Access current page data

                                  return GestureDetector(
                                    onTap: () {
                                      switch (index) {
                                        case 0:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ForumPage()),
                                          );
                                          break;
                                        case 1:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const NewsPage()),
                                          );
                                          break;
                                        case 2:
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MoodPage()),
                                          );
                                          break;
                                        default:
                                          // Handle other cases if needed
                                          break;
                                      }
                                    },
                                    child: Container(
                                      height: height * 0.275,
                                      width: width * 0.45,
                                      decoration: BoxDecoration(
                                        color: bluePrimary,
                                        borderRadius:
                                            BorderRadius.circular(width * 0.05),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                          horizontal:
                                              width * 0.025), // Add some margin
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center, // Align text left
                                        children: [
                                          Image.asset(
                                            page["image"],
                                            width: width * 0.5,
                                            height: width *
                                                0.5, // Set a consistent image height
                                          ),
                                          Text(
                                            page["title"],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                color: Colors.white),
                                          ),
                                          // Add some vertical spacing
                                          Text(
                                            page["description"],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ]);
              }
            }));
  }
}
