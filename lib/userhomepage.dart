import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:utmrunify/userprofilepage.dart';
import 'homepage.dart';
import 'loginpage.dart';

import 'event_details.dart';
import 'shop.dart';
import 'feedback.dart';
import 'auth_service.dart';
import 'myorder.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _auth = AuthService();
  static final List<Widget> _pages = <Widget>[
    HomePage(),
    FeedbackPage(),
    ShopPage(),
    MyOrderPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _auth.listenForTokenChanges(); // Start listening for token changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.person_pin),
          color: const Color.fromARGB(255, 119, 0, 50),
          iconSize: 40,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined),
            label: 'My Order',  
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blueGrey[400],
        selectedItemColor: const Color.fromARGB(255, 119, 0, 50),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        unselectedFontSize: 12,
        selectedFontSize: 12,
      ),
    );
  }
}

goToLogin(BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero, 
      ),
    );