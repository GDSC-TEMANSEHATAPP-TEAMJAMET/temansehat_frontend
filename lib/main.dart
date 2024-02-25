import 'package:flutter/material.dart';
import 'package:temansehat_app/ui/home.dart';
import 'package:temansehat_app/ui/welcome.dart';
import 'package:temansehat_app/utils/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await getTokenLocally();

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({Key? key, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: token == null ? WelcomePage() : HomePage(),
    );
  }
}
