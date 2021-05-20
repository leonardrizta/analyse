import 'package:analyse_app/screen/decription_result.dart';
import 'package:analyse_app/screen/encryption_result.dart';
import 'package:analyse_app/screen/encryption_screen.dart';
import 'package:analyse_app/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Analyse App",
      theme: ThemeData(
        primaryColor: Color(0xFF1BA0E2),
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}
