import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_organiser.dart';

class SignUpOrganiser extends StatefulWidget {
  const SignUpOrganiser({Key? key}) : super(key: key);

  @override
  _SignUpOrganiserState createState() => _SignUpOrganiserState();
}

class _SignUpOrganiserState extends State<SignUpOrganiser> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _contactController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Correct Firebase Database reference for the specific region
  final DatabaseReference _databaseRef = FirebaseDatabase.instanceFor(
    app: FirebaseDatabase.instance.app,
    databaseURL:
        "https://utm-runify-ad-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref().child('organisers');

  bool isAgreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _signUpOrganiser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final contact = _contactController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || contact.isEmpty || password.isEmpty) {
      _showErrorDialog("All fields are required.");
      return;
    }

    if (!RegExp(r"^[^@]+@[^@]+\.[^@]+").hasMatch(email)) {
      _showErrorDialog("Invalid email format.");
      return;
    }

    if (contact.length < 10 || contact.length > 15) {
      _showErrorDialog("Contact number must be between 10 and 15 digits.");
      return;
    }

    if (password != confirmPassword) {
      _showErrorDialog("Passwords do not match.");
      return;
    }

    if (password.length < 6) {
      _showErrorDialog("Password must be at least 6 characters long.");
      return;
    }

    if (!isAgreed) {
      _showErrorDialog("You must agree to the terms and conditions.");
      return;
    }

    try {
      print("Starting user registration...");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User registered successfully: ${userCredential.user!.uid}");

      print("Saving organiser details to database...");
      await _databaseRef.child(userCredential.user!.uid).set({
        'name': name,
        'email': email,
        'contact': contact,
      });
      print("Details saved successfully!");

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginOrganiser()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = "Sign-up failed. Please try again.";
      if (e.code == 'email-already-in-use') {
        errorMessage = "This email is already in use.";
      } else if (e.code == 'invalid-email') {
        errorMessage = "The email address is not valid.";
      } else if (e.code == 'weak-password') {
        errorMessage = "The password is too weak.";
      }
      print("FirebaseAuthException: ${e.code}");
      _showErrorDialog(errorMessage);
    } catch (e) {
      print("Unexpected error: $e");
      _showErrorDialog("An unexpected error occurred. Please try again.");
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Sign-Up Error"),
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

  Widget _buildTextField({
    required String labelText,
    required TextEditingController controller,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Organiser Sign Up',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Organiser Details',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(color: Colors.red, thickness: 2),
              const SizedBox(height: 20),
              _buildTextField(
                labelText: 'Organiser Name',
                controller: _nameController,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                labelText: 'E-mail',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                labelText: 'Contact Number',
                controller: _contactController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                labelText: 'Password',
                controller: _passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              _buildTextField(
                labelText: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: isAgreed,
                    onChanged: (value) {
                      setState(() {
                        isAgreed = value ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      'I agree to the terms & conditions of the UNBOCS\'24 RUN',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
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
                  onPressed: _signUpOrganiser,
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
