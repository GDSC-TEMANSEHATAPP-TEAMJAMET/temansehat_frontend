import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:temansehat_app/models/user.dart';
import 'dart:async';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/profile.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class MoodPage extends StatefulWidget {
  const MoodPage({super.key});

  @override
  State<MoodPage> createState() => _MoodPageState();
}

class _MoodPageState extends State<MoodPage> {
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
      print(response.body);
      print('Get Data failed');
      return null; // Return null or handle the error accordingly
    }
  }

  int _currentIndex = 1;
  Color buttonColor = bluePrimary;
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

  final _moodController = TextEditingController();
  String moodImage = "assets/think.png";
  String moodNow = "";
  String mood = "";

  Future<void> submitMood() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final String apiUrl = '$backendUri/api/users/moods';

    final Map<String, dynamic> payload = {
      'user_id': userId,
      'feeling': mood,
      'story': _moodController.text,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 201) {
      print('Mood uploaded successfully');
    } else {
      print('Error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
                backgroundColor: bgColor,
                body: Center(child: CircularProgressIndicator()));
          } else {
            User user = snapshot.data! as User;
            return Scaffold(
              backgroundColor: bgColor,
              appBar: PreferredSize(
                preferredSize: Size.fromHeight(120),
                child: Container(
                  decoration: BoxDecoration(
                      color: bluePrimary,
                      borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20))),
                  height: 120,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: bluePrimary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(20))),
                      title: ElevatedButton.icon(
                          style: buttonAppBar(context),
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: bluePrimary,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          label: Text(
                            "How're things going, ${user.username}?",
                            style: TextStyle(
                                color: bluePrimary,
                                fontSize: width * 0.0375,
                                fontWeight: FontWeight.bold),
                          )),
                      centerTitle: true,
                    ),
                  ),
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
                  selectedIconTheme:
                      IconThemeData(color: blueSecondary, size: 27),
                  unselectedIconTheme: IconThemeData(color: grey, size: 27),
                  currentIndex: _currentIndex,
                  onTap: _onItemTapped,
                  items: const [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.home_outlined), label: "Home"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.mood), label: "Mood"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.forum_outlined), label: "Forum"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.newspaper_outlined), label: "News"),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.person_outline), label: "Profile"),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(top: height * 0.0375),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .center, // Center the row horizontally
                        children: [
                          Container(
                            height: height * 0.4,
                            width: width * 0.27,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                                color: bluePrimary,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                            child: Column(
                              children: [
                                SizedBox(height: height * 0.015),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        moodImage = 'assets/Sad.png';
                                        moodNow =
                                            "I'm sorry to hear you're sad";
                                        mood = "sedih";
                                      });
                                    },
                                    child: Text(
                                      "Sad",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05,
                                      ),
                                    )),
                                SizedBox(height: height * 0.015),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        moodImage = 'assets/Angry.png';
                                        moodNow = "It's fine to feel angry";
                                        mood = "marah";
                                      });
                                    },
                                    child: Text(
                                      "Angry",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05,
                                      ),
                                    )),
                                SizedBox(height: height * 0.015),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        moodImage = 'assets/Neutral.png';
                                        moodNow = "Got it, neutral it is!";
                                        mood = "netral";
                                      });
                                    },
                                    child: Text(
                                      "Neutral",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05,
                                      ),
                                    )),
                                SizedBox(height: height * 0.015),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        moodImage = 'assets/Anxious.png';
                                        moodNow = "You're anxious? It's okay";
                                        mood = "bingung";
                                      });
                                    },
                                    child: Text(
                                      "Anxious",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05,
                                      ),
                                    )),
                                SizedBox(height: height * 0.015),
                                TextButton(
                                    onPressed: () {
                                      setState(() {
                                        moodImage = 'assets/Happy.png';
                                        moodNow = 'Yeay, you are happy now!';
                                        mood = "senang";
                                      });
                                    },
                                    child: Text(
                                      "Happy",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.05,
                                      ),
                                    )),
                                SizedBox(height: height * 0.015),
                              ],
                            ),
                          ),
                          SizedBox(width: width * 0.0375),
                          Column(
                            children: [
                              Image.asset(
                                moodImage,
                                height: width * 0.345,
                                width: width * 0.345,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: height * 0.02),
                                child: Text(
                                  moodNow,
                                  style: TextStyle(
                                      color: bluePrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      Container(
                        padding: EdgeInsets.all(width * 0.0425),
                        child: Column(
                          children: <Widget>[
                            Text("Tell me about it!",
                                style: TextStyle(color: bluePrimary)),
                            SizedBox(height: 5),
                            Container(
                              width: width * 0.65,
                              child: TextField(
                                textAlign: TextAlign.center,
                                minLines: 4,
                                maxLines: 4,
                                controller: _moodController,
                                decoration: InputDecoration(
                                    hintText: "...",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: bluePrimary, width: 2),
                                      borderRadius: BorderRadius.circular(
                                          10.0), // Adjust the value as needed
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: bluePrimary, width: 2),
                                      borderRadius: BorderRadius.circular(10.0),
                                    )),
                              ),
                            ),
                            Padding(padding: EdgeInsets.all(width * 0.02)),
                            ElevatedButton.icon(
                              style: buttonSubmit,
                              onPressed: () {
                                if (mood.isNotEmpty &&
                                    _moodController.text.isNotEmpty) {
                                  _showPopup(context);
                                  submitMood();
                                }
                              },
                              icon: const Icon(Icons.send, color: Colors.white),
                              label: Text(
                                'Submit',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: width * 0.034375),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        });
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              height: 130,
              width: 130,
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: bluePrimary,
                shape: BoxShape.circle,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, color: Colors.white, size: 48.0),
                  SizedBox(height: 8.0),
                  Text(
                    'Submitted!',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    // Auto-close the popup after 2 seconds
    Timer(Duration(milliseconds: 2000), () {
      Navigator.of(context).pop();
    });
  }
}
