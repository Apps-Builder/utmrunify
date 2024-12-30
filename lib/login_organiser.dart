import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup_organiser.dart'; // Import the SignUpOrganiser page
import 'user_login.dart'; // Import the UserLogin page
import 'firebase_auth.dart'; // Import the FirebaseAuthService class

class LoginOrganiser extends StatefulWidget {
  const LoginOrganiser({Key? key}) : super(key: key);

  @override
  _LoginOrganiserState createState() => _LoginOrganiserState();
}

class _LoginOrganiserState extends State<LoginOrganiser> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuthService _firebaseAuthService = FirebaseAuthService();

  // Function to handle login
  void _login() async {
    try {
      // Sign in using Firebase Authentication
      await _firebaseAuthService.signInWithEmailPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to the next screen after successful login (for example, event list screen)
      Navigator.pushReplacement(
        // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(
            builder: (context) =>
                const UserLogin()), // Change to your next screen
      );
    } on FirebaseAuthException catch (e) {
      // Show error if login fails
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? 'Login failed')));
    }
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
                    'assets/utm_background.jpg'), // Replace with your background image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Overlay for logo and login form
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Larger Logo Image
                Image.asset(
                  'assets/logo.png', // Replace with your logo image path
                  width: 250,
                  height: 250,
                ),
                const SizedBox(height: 30),
                // Form fields
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      // E-mail input
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
                      // Password input
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
                      // Centered Sign Up and Login links
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              // Navigate to Sign Up as Organiser page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpOrganiser(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign Up as Organiser',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              // Navigate to User Login page
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const UserLogin(),
                                ),
                              );
                            },
                            child: const Text(
                              'User Login',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Log In as Organiser button
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
                        onPressed: _login, // Call the login function here
                        child: const Text(
                          'Log In as Organiser',
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
}
