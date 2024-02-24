import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:temansehat_app/models/posts.dart';
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
  List<Post> posts = [];

  @override
  void initState() {
    super.initState();
    // Fetch posts when the widget initializes
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    // Fetch posts using the getPost function
    Post? post = await getPost();
    if (post != null) {
      setState(() {
        // Update the state with the fetched post
        posts.add(post);
      });
    }
  }

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

  Future<Post?> getPost() async {
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
        var postId = responseData.keys.first;
        var postJson = responseData[postId];
        return Post.fromJson(postJson..['postId'] = postId);
      } else {
        print('No posts found in the response');
        return null;
      }
    } else {
      print(response.body);
      print('Get Post failed');
      return null; // Return null or handle the error accordingly
    }
  }

  Future<void> likePost() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final String apiUrl = '$backendUri/api/users/posts';

    final Map<String, dynamic> payload = {
      'user_id': userId,
      'title': '',
      'desc': '',
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
      print('like uploaded successfully');
    } else {
      print('Error');
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
        preferredSize: const Size.fromHeight(120),
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            Center(
              child: posts.isNotEmpty
                  ? ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        Post post = posts[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PostPage()),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPage(),
                                  ),
                                );
                              },
                              child: Center(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PostPage()),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 20),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailPage()),
                                        );
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: bluePrimary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            border:
                                                Border.all(color: forumDark)),
                                        alignment: Alignment.center,
                                        width: 360,
                                        height: 347,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Baris 1: Profile Picture, Username, dan Waktu Post
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    CircleAvatar(
                                                      radius: 20.0,
                                                      backgroundImage:
                                                          MemoryImage(
                                                              base64Decode(post
                                                                  .userPfp!)),
                                                    ),
                                                    SizedBox(width: 5),
                                                    Text(post.username,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 13,
                                                            color:
                                                                Colors.white)),
                                                  ],
                                                ),
                                                Text(
                                                  post.postDate!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 10.0),

                                            // Baris 2: Judul Postingan
                                            Text(
                                              post.title,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(height: 5.0),

                                            // Baris 3: Gambar yang diattach
                                            Expanded(
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                    context: context,
                                                    builder: (BuildContext
                                                            context) =>
                                                        FullScreenImageDialog(
                                                      imagePath:
                                                          'assets/foto.JPG', // Ganti dengan path gambar yang sesuai
                                                    ),
                                                  );
                                                },
                                                child: Image(
                                                  image: AssetImage(
                                                      'assets/foto.JPG'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),

                                            const SizedBox(height: 5.0),
                                            Text(
                                              post.desc!,
                                              style: TextStyle(
                                                  fontSize: 12.0,
                                                  color: Colors.white),
                                            ),

                                            // Baris 5: Icon Like, Dislike, Comment, dan Share
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                padding: EdgeInsets.all(16.0),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {
                                                        // Add your logic for thumb up action
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .thumb_up_alt_rounded,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        // Add your logic for thumb down action
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .thumb_down_alt_rounded,
                                                        color: Colors.white,
                                                        size: 15,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: () {
                                                        // Add your logic for comment action
                                                      },
                                                      icon: Icon(
                                                        Icons
                                                            .mode_comment_rounded,
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
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : CircularProgressIndicator(), // Show loading indicator while posts are being fetched
            ),
          ],
        ),
      ),
    );
  }
}

class FullScreenImageDialog extends StatelessWidget {
  final String imagePath;

  FullScreenImageDialog({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.contain,
            image: AssetImage(imagePath),
          ),
        ),
        child: GestureDetector(
          onTap: () {
            // Tutup dialog ketika gambar di ketuk
            Navigator.of(context).pop();
          },
          child: Container(), // Container kosong untuk menangkap gesture
        ),
      ),
    );
  }
}
