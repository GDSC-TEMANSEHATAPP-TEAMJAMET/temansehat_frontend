import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/profile.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
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

  Future<void> submitPost() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final String apiUrl = '$backendUri/api/users/posts';

    final Map<String, dynamic> payload = {
      'user_id': userId,
      'title': _titleController.text,
      'description': _paragraphController.text,
      'pictures': images,
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      _showPopup(context);

      print('Post uploaded successfully');
    } else {
      print('Error');
      print(userId);
      print(response.body);
      print(response.statusCode);
    }
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _paragraphController = TextEditingController();

  List<String> images = [];
  Future<void> pickAndEncodeImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      List<int> imageBytes = await pickedFile.readAsBytes();

      String base64String = base64Encode(imageBytes);

      setState(() {
        images.add(base64String);
      });
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
      backgroundColor: bluePrimary,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
              color: forumDark,
              borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20))),
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
                  icon: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: Text(
                    "Create a Post",
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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Title",
                style: TextStyle(color: forumText, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              TextField(
                style: const TextStyle(color: Colors.white),
                controller: _titleController,
                decoration: const InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black))),
              ),
              const SizedBox(height: 20.0),
              Text("What do you wanna tell the world?",
                  style: TextStyle(color: forumText)),
              const SizedBox(height: 10.0),
              Column(
                children: [
                  Container(
                    height: height * 0.5,
                    decoration: BoxDecoration(
                        color: bluePrimary,
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.37,
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            scrollController: ScrollController(),
                            scrollPhysics: const BouncingScrollPhysics(),
                            decoration: const InputDecoration(
                                counterText: '', border: InputBorder.none),
                            controller: _paragraphController,
                            minLines: 13,
                            maxLines: null,
                            maxLength: 5000,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              right: 5, left: 5, bottom: 5),
                        ),
                        Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                pickAndEncodeImage();
                              },
                              icon: Icon(Icons.add_a_photo_rounded,
                                  color: Colors.white, size: 30)),
                          if (images.isNotEmpty)
                            Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.memory(
                                    base64Decode(images.first),
                                    height: width * 0.2,
                                    width: width * 0.3,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(bottom: width * 0.1),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        images.clear();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            submitPost();
                          },
                          icon: Icon(Icons.send_rounded,
                              color: Colors.white, size: 30)),
                    ],
                  ),
                      ],
                    ),
                  ),
                  
                ],
              ),
            ],
          ),
        ),
      ),
    );
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

    Timer(Duration(milliseconds: 2000), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ForumPage()),
      );
    });
  }
}
