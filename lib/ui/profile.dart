import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:temansehat_app/models/user.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/editprofile.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/postdetail.dart';
import 'package:temansehat_app/ui/setting.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
      print(response.body);
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

  int _currentIndex = 4; // Set the initial index to ProfilePage
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
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bluePrimary,
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined, size: 30),
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
      body: FutureBuilder(
          future: Future.wait([getUserData()]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              User user = snapshot.data![0] as User;
              return SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: height * 0.13,
                      decoration: BoxDecoration(
                        color: bluePrimary,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(width * 0.06),
                          bottomRight: Radius.circular(width * 0.06),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 40),
                        child: Column(
                          children: [
                            InkWell(
                              child: ClipOval(
                                child: user.pfp != null
                                    ? Image.memory(
                                        base64Decode(user.pfp!),
                                        fit: BoxFit.cover,
                                        width: width * 0.35,
                                        height: width * 0.35,
                                      )
                                    : Image.asset(
                                        'assets/nopfp.jpg',
                                        fit: BoxFit.cover,
                                        width: width * 0.35,
                                        height: width * 0.35,
                                      ),
                              ),
                            ),
                            Text(user.username,
                                style: TextStyle(
                                    color: bluePrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                            const SizedBox(height: 5),
                            // ignore: sized_box_for_whitespace
                            Container(
                              width: 300,
                              child: Text(
                                user.bio == null ? '' : user.bio!,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const EditProfilePage()),
                                  );
                                },
                                style: buttonProfile,
                                child: Text(
                                  "Edit Profile",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: bluePrimary,
                                      fontWeight: FontWeight.w500),
                                )),
                            Center(child: ToggleButtonScreen())
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}

class ToggleButtonScreen extends StatefulWidget {
  const ToggleButtonScreen({super.key});

  @override
  _ToggleButtonScreenState createState() => _ToggleButtonScreenState();
}

class _ToggleButtonScreenState extends State<ToggleButtonScreen> {
  Future<Map<String, dynamic>> getPost() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final response = await http.get(
      Uri.parse('$backendUri/api/users/posts/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData.isNotEmpty) {
        return responseData;
      } else {
        print('No posts found in the response');
        return {};
      }
    } else {
      print('Get Post failed');
      return {}; // Return null or handle the error accordingly
    }
  }

  List<bool> isSelected = [true, false];

  Future<Map<String, dynamic>> getMood() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final response = await http.get(
      Uri.parse('$backendUri/api/users/moods/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);

      if (responseData.isNotEmpty) {
        return responseData;
      } else {
        print('No Mood found in the response');
        return {};
      }
    } else {
      print('Get Mood failed');
      return {}; // Return null or handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: Future.wait([getPost(), getMood()]),
        builder: (context, snapshot) {
          Map<String, dynamic> moods = snapshot.data![1];
          Map<String, dynamic> posts = snapshot.data![0];

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Expanded(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(color: bluePrimary, width: 3)),
                      ),
                      child: ToggleButtons(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        fillColor: blueSecondary,
                        isSelected: isSelected,
                        onPressed: _toggleSelection,
                        children: [
                          _toggleButtonChild('Posts'),
                          _toggleButtonChild('Mood History'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    isSelected[0]
                        ? SizedBox(
                            height: 300,
                            child: ListView.separated(
                                itemCount: posts.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  String postId = posts.keys.elementAt(index);
                                  Map<String, dynamic> postData = posts[postId];
                                  Map<String, dynamic>? commentsData =
                                      postData['comment'];
                                  if (commentsData != null) {
                                    // Iterate through comments
                                    commentsData
                                        .forEach((commentId, commentData) {
                                      String? username =
                                          commentData?["username"];
                                      String? commentDesc =
                                          commentData?["comment_desc"];
                                      String? commentDate =
                                          commentData?["comment_date"];

                                      // Use the comment data as needed
                                      print(
                                          "Username: $username, Comment: $commentDesc, Date: $commentDate");
                                    });
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => DetailPage(
                                            postId: postId,
                                            description:
                                                postData['description'],
                                            postDate: postData['post_date'],
                                            title: postData['title'],
                                            commentsData: commentsData,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: height * 0.121,
                                      padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        color: bluePrimary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            postData['title'],
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                postData['post_date'],
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              Text(
                                                'x likes | x comments',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : SizedBox(
                            height: 300,
                            child: ListView.separated(
                                itemCount: moods.length,
                                separatorBuilder:
                                    (BuildContext context, int index) =>
                                        SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  String moodId = moods.keys.elementAt(index);
                                  Map<String, dynamic> moodData = moods[moodId];
                                  return Container(
                                    height: height * 0.121,
                                    padding: const EdgeInsets.all(15),
                                    decoration: BoxDecoration(
                                      color: bluePrimary,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          moodData['story'],
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              moodData['mood_date'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            Text(
                                              moodData['feeling'],
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                          )
                  ],
                ),
              ),
            );
          }
        });
  }

  Widget _toggleButtonChild(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        constraints: const BoxConstraints(minWidth: 120),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(color: bluePrimary),
        ),
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      for (int buttonIndex = 0;
          buttonIndex < isSelected.length;
          buttonIndex++) {
        isSelected[buttonIndex] = (buttonIndex == index);
      }
    });
  }
}
