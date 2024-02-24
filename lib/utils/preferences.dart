import 'package:shared_preferences/shared_preferences.dart';

Future<String?> getUserIdLocally() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('user_id');
}

Future<void> saveUserIdLocally(String userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('user_id', userId);
}

Future<String?> getTokenLocally() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('access_token');
}

Future<void> saveTokenLocally(String accessToken) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('access_token', accessToken);
}

Future<void> saveUsernameLocally(String username) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<String?> getUsernameLocally() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}
