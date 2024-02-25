import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:http/http.dart' as http;
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/post.dart';
import 'package:temansehat_app/ui/postdetail.dart';
import 'package:temansehat_app/ui/profile.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  String post_Id = '';
  bool like = false;
  int _currentIndex = 2; // Set the initial index to ForumPage
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

  Future<Map<String, dynamic>> getPost() async {
    String? accessToken = await getTokenLocally();
    final response = await http.get(
      Uri.parse('$backendUri/api/users/posts'),
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
        return {};
      }
    } else {
      return {}; // Return null or handle the error accordingly
    }
  }

  Future<void> likePost() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final String apiUrl = '$backendUri/api/users/posts/likes';

    final Map<String, dynamic> payload = {
      'user_id': userId,
      'post_id': post_Id,
      'like': like,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    // Menangani respons dari server

    if (response.statusCode == 201) {
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

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
            currentIndex: 2,
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
        backgroundColor: bluePrimary,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(120),
          child: Container(
            decoration: BoxDecoration(
              color: forumDark,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
            ),
            height: 120,
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: forumDark,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
                title: ElevatedButton.icon(
                    style: postAppBar(context),
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      "CommunitySehat",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: width * 0.04,
                          fontWeight: FontWeight.bold),
                    )),
                centerTitle: true,
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PostPage()),
            );
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: forumDark, // Change the background color as needed
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        body: FutureBuilder<Map<String, dynamic>>(
          future: getPost(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              Map<String, dynamic> posts = snapshot.data!;

              return ListView.separated(
                itemCount: posts.length,
                separatorBuilder: (BuildContext context, int index) =>
                    SizedBox(height: 20),
                itemBuilder: (context, index) {
                  String postId = posts.keys.elementAt(index);
                  Map<String, dynamic> postData = posts[postId];
                  Map<String, dynamic>? commentsData = postData['comment'];
                  if (commentsData != null) {
                    commentsData.forEach((commentId, commentData) {});
                  }

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailPage(
                            postId: postId,
                            description: postData['description'],
                            postDate: postData['post_date'],
                            title: postData['title'],
                            commentsData: commentsData,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: bluePrimary,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: forumDark)),
                      alignment: Alignment.center,
                      width: width * 0.35,
                      height: height * 0.3,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  postData['user_pfp'] != null
                                      ? CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage: MemoryImage(
                                              base64Decode(
                                                  postData['user_pfp'])),
                                        )
                                      : CircleAvatar(
                                          radius: 20.0,
                                          backgroundImage:
                                              AssetImage('assets/nopfp.jpg'),
                                        ),
                                  SizedBox(width: 5),
                                  Text(postData['username'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: Colors.white)),
                                ],
                              ),
                              Text(
                                postData['post_date'],
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10.0),
                          Text(
                            postData['title'],
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                                color: Colors.white),
                          ),
                          const SizedBox(height: 5.0),
                          const SizedBox(height: 5.0),
                          Text(
                            postData['description'].length > 50
                                ? postData['description'].substring(0, 47) +
                                    "..."
                                : postData['description'],
                            style:
                                TextStyle(fontSize: 12.0, color: Colors.white),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        post_Id = postId;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.thumb_up_alt_rounded,
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
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
