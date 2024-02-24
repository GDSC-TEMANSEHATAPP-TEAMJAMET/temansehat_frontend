import 'package:flutter/material.dart';
import 'package:temansehat_app/ui/news.dart';
import 'package:temansehat_app/ui/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Poppins'),
      debugShowCheckedModeBanner: false,
      home: WelcomePage(),
    );
  }
}
