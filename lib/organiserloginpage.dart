import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'loginpage.dart';
import 'main.dart';
import 'organisersignuppage.dart';
import 'organizerHomePage.dart';

class OrganiserLoginPage extends StatefulWidget {
  @override
  _OrganiserLoginPageState createState() => _OrganiserLoginPageState();
}

class _OrganiserLoginPageState extends State<OrganiserLoginPage> {

  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color.fromRGBO(246, 247, 252, 1),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/image/background.png'), // Replace with your image path
                fit: BoxFit.cover,
                alignment: Alignment.centerLeft,
              ),
            ),
          ),
          // Semi-transparent overlay (optional for better contrast)
          Container(
            color: Color(0xFFD3BB).withOpacity(0.3),
          ),
          // Content (centered)
          Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // UTMRunify Title
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: 'UTM',
                          style: TextStyle(
                            color: Color(0xFF870C14),
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: 'RUNIFY',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.directions_run, size: 100.0, color: Colors.white),
                  Spacer(), // Spacing between title and form

                  // UTMID text field
                  TextField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'E-mail',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    controller: _email,
                  ),
                  SizedBox(height: 15), // Spacing between fields

                  // Password text field
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    ),
                    controller: _password,
                  ),
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  OrganiserSignUpPage(),
                          transitionDuration:
                              Duration.zero, // Removes the transition duration
                          reverseTransitionDuration:
                              Duration.zero, // Removes reverse transition
                        ),
                      );
                    },
                    child: Text(
                      "Sign Up as Organiser",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  LoginPage(),
                          transitionDuration:
                              Duration.zero, // Removes the transition duration
                          reverseTransitionDuration:
                              Duration.zero, // Removes reverse transition
                        ),
                      );
                    },
                    child: Text(
                      "User Login",
                      style: TextStyle(
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(height: 80), // Spacing before the button

                  // Log In button
                  SizedBox(
                    width: double.infinity, // Full width button
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    OrganizerHomePage(),
                            transitionDuration: Duration
                                .zero, // Removes the transition duration
                            reverseTransitionDuration:
                                Duration.zero, // Removes reverse transition
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF870C14), // Button color
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                      ),
                      child: Text(
                        'Log In',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
