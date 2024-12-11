import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:utmrunify/main.dart';

import 'auth_service.dart';
import 'organiserloginpage.dart';

class UserSignUpPage extends StatefulWidget {
  @override
  _UserSignUpState createState() => _UserSignUpState();
}

class _UserSignUpState extends State<UserSignUpPage> {
  final _auth = AuthService();

  final _fullname = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _contactno = TextEditingController();
  final _confirmpassword = TextEditingController();
  final _height = TextEditingController();
  final _weight = TextEditingController();
  final _dob = TextEditingController();

  String? _selectedGender;
  String? userID;

  @override
  void dispose() {
    super.dispose();
    _fullname.dispose();
    _email.dispose();
    _password.dispose();
    _contactno.dispose();
    _confirmpassword.dispose();
    _height.dispose();
    _weight.dispose();
    _dob.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool _isChecked = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Stack(
                  children: [
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
                    Center(
                      child: Container(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          "User Sign Up",
                          style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),

                // Form Fields
                Text(
                  "User Details",
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Divider(color: Color(0xFF870C14), thickness: 2),
                SizedBox(height: 15),
                TextFormField(
                  controller: _fullname,
                  decoration: InputDecoration(labelText: 'Full Name'),
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedGender,
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  items: ['Male', 'Female', 'Other']
                      .map((gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ))
                      .toList(),
                  decoration: InputDecoration(labelText: 'Gender'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _dob,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _dob.text = "${pickedDate.toLocal()}".split(' ')[0];
                      });
                    }
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _height,
                  decoration: InputDecoration(labelText: 'Height (cm)'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _weight,
                  decoration: InputDecoration(labelText: 'Weight (kg)'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _email,
                  decoration: InputDecoration(labelText: 'E-mail'),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contactno,
                  decoration: InputDecoration(labelText: 'Contact Number'),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _confirmpassword,
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Confirm Password'),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  goToHome(BuildContext context) => Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => MyHomePage(),
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
  );

  uploadUserToDb() async {
    try {
      FirebaseFirestore.instance.collection("users").add({
        "email": _email.text.trim(),
      "contactco": _contactno.text.trim(),
      "height": _height.text.trim(),
      "weight": _weight.text.trim(),
      "dateofbirth": _dob.text.trim(),
        "gender": _selectedGender,
        "name": _fullname.text.trim(),
        "userID": userID
      });
    } catch(e) {
      print(e);
    }
  }

  _signup() async {
    final user = await _auth.createUserWithEmailAndPassword(_email.text, _password.text);

    if (user != null) {
      userID = user!.uid;
      log("User created successfully");
      goToHome(context);
    }
    uploadUserToDb();
  }
}
