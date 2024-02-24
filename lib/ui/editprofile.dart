import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:temansehat_app/models/user.dart';
import 'package:temansehat_app/styles/button.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/styles/profilewidget.dart';
import 'package:temansehat_app/ui/forum.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/mood.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/profile.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late User? user;
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  String pfpBase64 = "";

  @override
  void initState() {
    super.initState();
    fetchUserData();
    _nameController = TextEditingController();
    _bioController = TextEditingController();
  }

  Future<void> fetchUserData() async {
    User? fetchedUser = await getUserData();
    setState(() {
      user = fetchedUser;
      if (user != null) {
        _nameController.text = user!.username;
        _bioController.text = user!.bio;
      }
    });
  }

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
      return null;
    }
  }

  int _currentIndex = 4; // Set the initial index to EditProfilePage
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

  Future<void> updateUserProfile() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final Map<String, dynamic> payload = {
      'user_id': userId,
      'username': _nameController.text,
      'bio': _bioController.text,
      'pfp': pfpBase64,
    };

    final response = await http.put(
      Uri.parse(backendUri + '/api/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      print('Update successful');
    } else {
      print(accessToken);
      print(userId);
      print('Update failed');
    }
  }

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();

      setState(() {
        pfpBase64 = base64Encode(Uint8List.fromList(bytes));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: bgColor,
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
                backgroundColor: bluePrimary,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20))),
                title: ElevatedButton.icon(
                    style: buttonAppBar(context),
                    icon: Icon(Icons.arrow_back_ios_new_rounded,
                        color: bluePrimary),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: Text(
                      "Edit Profile",
                      style: TextStyle(
                          color: bluePrimary,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.bold),
                    )),
                centerTitle: true,
              ),
            ),
          ),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              width: width * 0.8,
              child: Column(
                children: [
                  Stack(children: [
                    Center(
                        child: ClipOval(
                      child: Material(
                        color: Colors.transparent,
                        child: Image.asset(
                          'assets/nopfp.jpg',
                          fit: BoxFit.cover,
                          width: width * 0.3,
                          height: width * 0.3,
                        ),
                      ),
                    )),
                    ProfileWidget(imagePath: user!.pfp, onClicked: pickImage)
                  ]),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: bluePrimary)),
                          maxLength: 15,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: _bioController,
                          decoration: InputDecoration(
                              labelText: 'Bio (Optional)',
                              labelStyle: TextStyle(color: bluePrimary)),
                          // minLines: 6,
                          maxLength: 150,
                        ),
                        ElevatedButton(
                          style: buttonSubmit,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              updateUserProfile();
                            }
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }
}
