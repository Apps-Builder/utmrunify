import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmrunify/main.dart';

import 'organiserloginpage.dart';

class OrganiserSignUpPage extends StatefulWidget {
  const OrganiserSignUpPage({super.key});


  @override
  _OrganiserSignUpState createState() => _OrganiserSignUpState();
}

class _OrganiserSignUpState extends State<OrganiserSignUpPage> {

  @override
  void initState() {
    super.initState();
  }
  void _onSignUp() {

  }
  @override
  Widget build(BuildContext context) {

    bool isChecked = false;

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
                        icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.black, size: 18),
                      ),
                      const Text(
                        "Back",
                        style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // Centered title
                Center(
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: const Text(
                      "Organiser Sign Up",
                      style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Organiser Details",
                    style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),  // Add some spacing between the text and the divider
                  const Divider(
                    color: Color(0xFF870C14),   // Set the color of the divider
                    thickness: 2,         // Set the thickness of the divider
                    endIndent: 0,         // Optional: add an end indent to control the width
                  ),
                  const SizedBox(height: 15),
                  // Organiser Name
                  Container(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFF870C14)),
                            ),
                            labelText: 'Organiser Name',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          cursorColor: Colors.black,
                        ),
                        const SizedBox(height: 16.0),

                        // E-mail
                        TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'E-mail',

                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16.0),

                        // Contact Number
                        TextFormField(
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Contact Number',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          cursorColor: Colors.black,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16.0),

                        // Password
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Password',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          cursorColor: Colors.black,
                        ),
                        const SizedBox(height: 16.0),

                        // Confirm Password
                        TextFormField(
                          obscureText: true,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(color: Colors.black),

                          ),
                          cursorColor: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                      child:
                      Row(
                          children: [
                            Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value ?? false;
                                });
                              },
                            ),
                            const Expanded(

                              child: Text(
                                "I have read and agreed to abide by the rules & regulations of the UNBOCS'24 RUN",
                                style: TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),

                            ),
                          ])
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => const MyHomePage(),
                            transitionDuration: Duration.zero, // Removes the transition duration
                            reverseTransitionDuration: Duration.zero, // Removes reverse transition
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF870C14), // Button color
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        textStyle: const TextStyle(fontSize: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20), // Rounded corners
                        ),
                      ),

                      child: const Text(
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
}
