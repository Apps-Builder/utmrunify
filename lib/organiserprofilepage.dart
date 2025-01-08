import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';

import 'auth_service.dart';
//import 'main.dart';
import 'package:utmrunify/userhomepage.dart';

class OrganiserProfilePage extends StatefulWidget {
  const OrganiserProfilePage({super.key});

  @override
  _OrganiserProfilePageState createState() => _OrganiserProfilePageState();
}

class _OrganiserProfilePageState extends State<OrganiserProfilePage> {
  final _auth = AuthService();
  final ImagePicker _picker = ImagePicker();

  String? _imageUrl;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _contactController = TextEditingController();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  String? _gender;

  String? userID;

  @override
  void initState() {
    super.initState();
    userID = _auth.getUserID();
    _loadProfileData();
    _loadProfileImage();
  }

  // Load profile data from Firestore
  Future<void> _loadProfileData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID) // Get the user document by userID
          .get();

      if (userDoc.exists) {
        var data = userDoc.data() as Map<String, dynamic>;

        // Populate the text controllers with fetched data
        _fullNameController.text = data['name'] ?? '';
        _emailController.text = data['email'] ?? '';
        _weightController.text = data['weight'] ?? '';
        _heightController.text = data['height'] ?? '';
        _dobController.text = data['dateofbirth'] ?? '';
        _contactController.text = data['contactno'] ?? '';
        _gender = data['gender'] ?? 'Male'; // Default to Male if null
      } else {
        print("User data not found!");
      }
    } catch (e) {
      print("Error loading user data: $e");
    }
  }

  // Load profile image from Firebase Storage
  Future<void> _loadProfileImage() async {
    try {
      String fileName = 'profile_photos/$userID.jpg';
      final ref = FirebaseStorage.instance.ref().child(fileName);

      final downloadUrl = await ref.getDownloadURL();
      setState(() {
        _imageUrl = downloadUrl;
      });
    } catch (e) {
      setState(() {
        _imageUrl = null; // Default to null if no image is found
      });
    }
  }

  // Handle image selection and upload
  Future<void> _pickAndUploadImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        File imageFile = File(pickedFile.path);

        String fileName = 'profile_photos/$userID.jpg';
        final ref = FirebaseStorage.instance.ref().child(fileName);

        await ref.putFile(imageFile);
        final downloadUrl = await ref.getDownloadURL();

        if (mounted) {
          setState(() {
            _imageUrl = downloadUrl;
          });

          if (mounted) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text("Success"),
                content: Text('Image uploaded successfully!'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('OK'),
                  ),
                ],
              ),
            );
          }
        }
      }
    } catch (e) {
      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Error"),
            content: Text('Failed to upload image: $e'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }


  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          // Get the email from the controller
          String email = _emailController.text;
          bool updateEmail = false;

          // Re-authenticate the user before updating the email
          String currentPassword = _passwordController.text; // Get current password from the user
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!,
            password: currentPassword,
          );

          if (email != user.email) {
            // Reauthenticate the user
            await user.reauthenticateWithCredential(credential);

            // Verify and update the email
            await user.verifyBeforeUpdateEmail(email);

            updateEmail = true;
          }

          // Update Firestore with new profile data
          await FirebaseFirestore.instance.collection('users').doc(userID).set({
            'email': user.email,
            'contactno': _contactController.text,
            'name': _fullNameController.text,
            'userID': userID,
            'usertype': 'organiser',
          });

          if (mounted) {
            if (updateEmail) {
              _showDialog('Your profile has been successfully updated! Please check your new email inbox to verify and confirm the email change.', isSuccess: true);
            } else {
              _showDialog('Profile updated successfully!', isSuccess: true);
            }
          }
        }
      } catch (e) {
        if (mounted) {
          _showDialog('Failed to update profile: $e', isSuccess: false);
        }
      }
    }
  }

  void _showDialog(String message, {required bool isSuccess}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isSuccess ? 'Success' : 'Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organiser Profile'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 20), // Add spacing below the AppBar
                // Circular Profile Photo with Tap Feature
                GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: CircleAvatar(
                    radius: 50, // Size of the avatar
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: _imageUrl != null
                        ? NetworkImage(_imageUrl!)
                        : null, // Display image if URL exists
                    child: _imageUrl == null
                        ? const Icon(
                      Icons.account_circle, // Default icon
                      size: 100, // Size of the icon (larger to fill the circle)
                      color: Colors.grey,
                    )
                        : null, // No icon if an image is present
                  ),
                ),
                const SizedBox(height: 20), // Spacing between photo and content

                // Form for user details
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Full Name Field
                      TextFormField(
                        controller: _fullNameController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Full Name',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10), // Spacing between fields

                      // Email Field
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Email',
                        ),
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
                      const SizedBox(height: 10), // Spacing between fields


                      // Contact Number Field
                      TextFormField(
                        controller: _contactController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Contact No.',
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Contact number is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),

                      // Password Field (with asterisks)
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: UnderlineInputBorder(),
                          labelText: 'Password',
                        ),
                        obscureText: true, // This hides the password as asterisks
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
                      const SizedBox(height: 20), // Spacing between form and submit button

                      // Submit Button (Full Width)
                      Container(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF870C14), // Button color
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            textStyle: const TextStyle(fontSize: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // Rounded corners
                            ),
                          ),
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20), // Add spacing below the form

                // Sign Out Button (Full Width)
                Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _auth.signout();
                      goToLogin(context);
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
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
