import 'package:flutter/material.dart';
import 'package:utmrunify/model/loginpage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTMRunify',
      theme: ThemeData(
        // fontFamily: GoogleFonts.josefinSans().fontFamily,
      ),
      home: LoginPage(0),
    );
  }
}