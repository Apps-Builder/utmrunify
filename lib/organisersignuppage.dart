import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmrunify/main.dart';

import 'auth_service.dart';
import 'organiserloginpage.dart';

class OrganiserSignUpPage extends StatefulWidget {

  @override
  _OrganiserSignUpState createState() => _OrganiserSignUpState();
}

class _OrganiserSignUpState extends State<OrganiserSignUpPage> {

  final _auth = AuthService();

  final _email = TextEditingController();
  final _password = TextEditingController();
  final _contactno = TextEditingController();
  final _confirmpassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
    _contactno.dispose();
    _confirmpassword.dispose();
  }

  void _onSignUp() {

  }

  @override
  Widget build(BuildContext context) {

    bool _isChecked = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                // Back button on the left
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 18),
                      ),
                      Text(
                        "Back",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Centered title
                Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "Organiser Sign Up",
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 15),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Organiser Details",
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),  // Add some spacing between the text and the divider
                  Divider(
                    color: Color(0xFF870C14),   // Set the color of the divider
                    thickness: 2,         // Set the thickness of the divider
                    endIndent: 0,         // Optional: add an end indent to control the width
                  ),
                  SizedBox(height: 15),
                  // Organiser Name
                  Container(
                    padding: EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF870C14)),
                            ),
                            labelText: 'Organiser Name',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          cursorColor: Colors.black,
                        ),
                        SizedBox(height: 16.0),

                        // E-mail
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'E-mail',

                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          controller: _email,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 16.0),

                        // Contact Number
                        TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Contact Number',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          controller: _contactno,
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 16.0),

                        // Password
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          controller: _password,
                          cursorColor: Colors.black,
                        ),
                        SizedBox(height: 16.0),

                        // Confirm Password
                        TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          controller: _confirmpassword,
                          cursorColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                      child:
                      Row(
                          children: [
                            Checkbox(
                              value: _isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  _isChecked = value ?? false;
                                });
                              },
                            ),
                            Expanded(

                              child: Text(
                                "I have read and agreed to abide by the rules & regulations of the UNBOCS'24 RUN",
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),

                            ),
                          ])
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF870C14), // Button color
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                      ),

                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )

          ],
        ),
      ),
    );
  }

  goToHome(BuildContext context) => Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
      transitionDuration: Duration.zero, // Removes the transition duration
      reverseTransitionDuration: Duration.zero, // Removes reverse transition
    ),
  );

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);
    if (user != null) {
      log("User created successfully");
      goToHome(context);
    }
  }
}
