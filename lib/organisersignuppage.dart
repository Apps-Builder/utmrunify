import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utmrunify/main.dart';
import 'package:utmrunify/organizerHomePage.dart';

import 'auth_service.dart';

class OrganiserSignUpPage extends StatefulWidget {
  @override
  _OrganiserSignUpState createState() => _OrganiserSignUpState();
}

class _OrganiserSignUpState extends State<OrganiserSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _contactno = TextEditingController();
  final _confirmpassword = TextEditingController();

  bool _isChecked = false;
  String? userID;

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _contactno.dispose();
    _confirmpassword.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organiser Signup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Text(
                    "Organiser Details",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Divider(
                    color: Color(0xFF870C14),
                    thickness: 2,
                  ),
                  SizedBox(height: 15),

                  // Organiser Name
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: 'Organiser Name'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Organiser name is required';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Email
                  TextFormField(
                    controller: _email,
                    decoration: InputDecoration(labelText: 'E-mail'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Contact Number
                  TextFormField(
                    controller: _contactno,
                    decoration: InputDecoration(labelText: 'Contact Number'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Contact number is required';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Password
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Password'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 16),

                  // Confirm Password
                  TextFormField(
                    controller: _confirmpassword,
                    obscureText: true,
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _password.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 20),

                  // Checkbox
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
                        ),
                      ),
                    ],
                  ),


                  SizedBox(height: 20),

                  // Sign Up Button
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _signup,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF870C14),
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text("Sign Up", style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      if (_isChecked) {
        final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);

        if (user != null) {
          userID = user.uid;
          log("User created successfully");
          uploadUserToDb();
          goToHome(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the Terms and Conditions to sign up.'),
            backgroundColor: Color(0xFF870C14),
          ),
        );
      }
    }
  }

  void uploadUserToDb() async {
    try {
      FirebaseFirestore.instance.collection("users").doc(userID).set({
        "email": _email.text.trim(),
        "contactno": _contactno.text.trim(),
        "name": _name.text.trim(),
        "userID": userID,
        "usertype": "organiser"
      });
    } catch (e) {
      print(e);
    }
  }

  void goToHome(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => OrganizerHomePage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
