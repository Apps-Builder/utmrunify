import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Authentication
import 'home_running_events.dart'; // Import the HomeRunningEvents page

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle user login
  Future<void> _loginUser() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Please fill in both email and password.");
      return;
    }

    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigate to HomeRunningEvents if successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeRunningEvents()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = "No user found with this email.";
          break;
        case 'wrong-password':
          errorMessage = "Incorrect password. Please try again.";
          break;
        case 'invalid-email':
          errorMessage = "Invalid email address.";
          break;
        default:
          errorMessage = "Login failed. Please try again.";
      }
      _showErrorDialog(errorMessage);
    }
  }

  // Method to display error dialogs
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Login Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/utm_background.jpg'), // Use the same background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay for logo and login form
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Move the logo upwards by reducing space above it
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 20.0), // Adjust padding
                  child: Image.asset(
                    'assets/logo.png', // Use the same logo image
                    width: 250,
                    height: 250,
                  ),
                ),
                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      // E-mail TextField
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'E-mail',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Password TextField
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      // Organiser Login link
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate back to Organiser Login
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Organiser Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 30),
                        ],
                      ),
                      // Log In button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF800000),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 100.0,
                            vertical: 15.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        onPressed:
                            _loginUser, // Call login method on button press
                        child: const Text(
                          'Log In',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
