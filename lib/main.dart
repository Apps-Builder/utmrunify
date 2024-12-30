import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'login_organiser.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UTM Runify',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color(0xFF800000)), // Maroon color
        useMaterial3: true,
      ),
      home: const LoginOrganiser(), // Updated reference
    );
  }
}
