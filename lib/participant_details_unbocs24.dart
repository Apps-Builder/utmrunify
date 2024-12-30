import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'review_unbocs24.dart';

class ParticipantDetailsUnbocs24Screen extends StatefulWidget {
  final String category;

  const ParticipantDetailsUnbocs24Screen({Key? key, required this.category})
      : super(key: key);

  @override
  _ParticipantDetailsUnbocs24ScreenState createState() =>
      _ParticipantDetailsUnbocs24ScreenState();
}

class _ParticipantDetailsUnbocs24ScreenState
    extends State<ParticipantDetailsUnbocs24Screen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _nationalityController = TextEditingController();
  final TextEditingController _passportNricController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _emergencyContactController =
      TextEditingController();

  final DatabaseReference _databaseRef =
      FirebaseDatabase.instance.ref().child('participants');

  bool isAgreed = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _nationalityController.dispose();
    _passportNricController.dispose();
    _contactNumberController.dispose();
    _emergencyContactController.dispose();
    super.dispose();
  }

  // Method to handle submit button press
  void _handleSubmit() {
    final fullName = _fullNameController.text.trim();
    final nationality = _nationalityController.text.trim();
    final passportNric = _passportNricController.text.trim();
    final contactNumber = _contactNumberController.text.trim();
    final emergencyContact = _emergencyContactController.text.trim();

    if (fullName.isEmpty ||
        nationality.isEmpty ||
        passportNric.isEmpty ||
        contactNumber.isEmpty ||
        emergencyContact.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required.'),
        ),
      );
      return;
    }

    if (!isAgreed) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions.'),
        ),
      );
      return;
    }

    try {
      // Save participant details to Firebase Realtime Database
      final participantId = _databaseRef.push().key; // Generate a unique ID
      _databaseRef.child(participantId!).set({
        'fullName': fullName,
        'nationality': nationality,
        'passportNric': passportNric,
        'contactNumber': contactNumber,
        'emergencyContact': emergencyContact,
        'category': widget.category,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Form submitted successfully!'),
          ),
        );

        // Navigate to the review screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ReviewUnbocs24Screen(
              participantId: participantId,
            ),
          ),
        );
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit form: $error'),
          ),
        );
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    }
  }

  // Method to build text fields
  Widget _buildTextField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'UNBOCS\' 24 RUN',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Category',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.red[900]!, width: 2.0),
                  ),
                ),
                child: Text(
                  widget.category,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Participants Details',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Divider(thickness: 2, color: Colors.red),
              const SizedBox(height: 8),
              _buildTextField(_fullNameController, 'Full Name'),
              _buildTextField(_nationalityController, 'Nationality'),
              _buildTextField(_passportNricController, 'Passport/NRIC'),
              _buildTextField(_contactNumberController, 'Contact Number'),
              _buildTextField(
                  _emergencyContactController, 'Emergency Contact Number'),
              const SizedBox(height: 24),
              Center(
                child: Container(
                  width: double.infinity,
                  child: CheckboxListTile(
                    value: isAgreed,
                    onChanged: (value) {
                      setState(() {
                        isAgreed = value ?? false;
                      });
                    },
                    title: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 14, color: Colors.black),
                        children: [
                          TextSpan(
                            text: 'I have read and agreed to abide by the\n',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: 'rules & regulations of the UNBOCS\'24 RUN',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.center,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text(
                      'SUBMIT',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
