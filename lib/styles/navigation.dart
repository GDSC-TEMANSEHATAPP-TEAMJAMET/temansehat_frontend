import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:temansehat_app/styles/color.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:temansehat_app/utils/uri.dart';

Future<void> showCommentsPopup(BuildContext context, String postId) async {
  final _commentController = TextEditingController();
  Future<void> analyzeComment() async {
    final String apiUrl =
        'https://language.googleapis.com/v2/documents:analyzeSentiment?key=AIzaSyCSFfLJ9nzZ9SPSzYgk84g6jOjUGH4ogJU';
    final Map<String, dynamic> payload = {
      'document': {"type": "PLAIN_TEXT", "content": _commentController.text},
    };

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(payload),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      
    } else {
   
    }
  }

  ;
  Future<void> submitComment() async {
    String? userId = await getUserIdLocally();
    String? accessToken = await getTokenLocally();
    final String apiUrl = '$backendUri/api/users/posts/comments';

    final Map<String, dynamic> payload = {
      'user_id': userId,
      'post_id': postId,
      'comment_desc': _commentController.text,
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

    } else {
      ;
    }
  }

  Map<String, dynamic> postData = await getPost(postId);
  Map<String, dynamic>? commentsData = postData['comment'];
  
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    builder: (BuildContext context) {
      return SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            height: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Text(
                  'Comments',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: commentsData != null
                      ? ListView.builder(
                          itemCount: commentsData.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(
                                commentsData['username'] ?? 'Unknown User',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                commentsData['comment_desc'] ??
                                    'No description',
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            );
                          },
                        )
                      : Center(
                          child: Text('No comments available'),
                        ),
                ),
                const SizedBox(height: 10),
                Container(
                  height: 50,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    height: 50,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            decoration: InputDecoration(
                              hintText: 'Send a heartfelt comment...',
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            analyzeComment();
                            submitComment();
                            _showPopup(context);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      );
    },
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

  Timer(Duration(milliseconds: 2000), () {});
}

Future<Map<String, dynamic>> getPost(String postId) async {
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
