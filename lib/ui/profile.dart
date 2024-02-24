import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:temansehat_app/models/moods.dart';
import 'package:temansehat_app/models/user.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/editprofile.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/setting.dart';
import 'package:temansehat_app/utils/api.dart';
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
                              child: CircleAvatar(
                                backgroundImage:
                                    MemoryImage(base64Decode(user.pfp)),
                                radius: 60,
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
                                user.bio,
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
            return Container();
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
  List<bool> isSelected = [true, false];
  Future<Moods?> getMood() async {
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
      print(response.body);
      Map<String, dynamic> jsonMap = json.decode(response.body);
      Moods moods = Moods.fromJson(jsonMap);

      return moods;
    } else {
      print(response.body);
      print('Get Data failed');
      return null; // Return null or handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
        future: getMood(),
        builder: (context, snapshot) {
          Moods moods = snapshot.data as Moods;
          return Padding(
            padding: const EdgeInsets.all(16.0),
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
                    ? _buildPostContent(height)
                     : Text('no data')// ListView.builder(
                    //     itemCount: moods.entries.length,
                    //     itemBuilder: (context, index) {
                    //       var entry = moods.entries.values.elementAt(index);
                    //       return Container(
                    //         height: 150,
                    //         padding: const EdgeInsets.all(15),
                    //         margin: const EdgeInsets.all(10),
                    //         decoration: BoxDecoration(
                    //           color: Colors.blue,
                    //           borderRadius: BorderRadius.circular(10),
                    //         ),
                    //         child: Column(
                    //           crossAxisAlignment: CrossAxisAlignment.start,
                    //           children: [
                    //             RichText(
                    //               text: TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text: 'Feeling: ',
                    //                     style: TextStyle(
                    //                       fontWeight: FontWeight.bold,
                    //                       fontSize: 18,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: entry.feeling,
                    //                     style: TextStyle(
                    //                       fontSize: 18,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: '\nStory: ',
                    //                     style: TextStyle(
                    //                       fontSize: 18,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: entry.story,
                    //                     style: TextStyle(
                    //                       fontSize: 18,
                    //                       color: Colors.white,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //             const SizedBox(height: 10),
                    //             Row(
                    //               mainAxisAlignment:
                    //                   MainAxisAlignment.spaceBetween,
                    //               children: [
                    //                 Text(
                    //                   'Mood Date: ${entry.moodDate}',
                    //                   style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontSize: 14,
                    //                     fontWeight: FontWeight.normal,
                    //                   ),
                    //                 ),
                    //               ],
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     },
                    //   ),
              ],
            ),
          );
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

  Widget _buildPostContent(double height) {
    return Container(
      height: height * 0.121,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: bluePrimary,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '18 Januari 2024 | 16:58',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                ),
              ),
              Text(
                'x likes | x dislikes | x komentar',
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