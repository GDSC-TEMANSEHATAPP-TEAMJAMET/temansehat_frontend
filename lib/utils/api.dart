import 'dart:convert';

import 'package:temansehat_app/models/posts.dart';
import 'package:temansehat_app/models/user.dart';
import 'package:temansehat_app/utils/preferences.dart';
import 'package:http/http.dart' as http;
import 'package:temansehat_app/utils/uri.dart';

class Service {
  Future getUserData() async {
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
      Map<String?, dynamic> responseMap = jsonDecode(response.body);
      String? username = responseMap['username'];
      String? bio = responseMap['bio'];
      String? email = responseMap['email'];
      String? pfp = responseMap['pfp'];
      print(response.body);
    } else {
      print(response.body);
      print('Update failed');
    }
  }


  Future<void> getMood() async {
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
      // User.fromJson(jsonDecode(response.body));
      print(response.body);
      print('Get Mood successful');
    } else {
      print(response.body);
      print('Get failed');
    }
  }
}
