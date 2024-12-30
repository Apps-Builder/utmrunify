import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

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
  bool isSubmitting = false;

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
  Future<void> _handleSubmit() async {
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

    setState(() => isSubmitting = true);

    try {
      final participantId = _databaseRef.push().key; // Generate a unique ID
      await _databaseRef.child(participantId!).set({
        'fullName': fullName,
        'nationality': nationality,
        'passportNric': passportNric,
        'contactNumber': contactNumber,
        'emergencyContact': emergencyContact,
        'category': widget.category,
      });

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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
        ),
      );
    } finally {
      setState(() => isSubmitting = false);
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
                    onPressed: isSubmitting ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900],
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: isSubmitting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
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

class ReviewUnbocs24Screen extends StatefulWidget {
  final String participantId;

  const ReviewUnbocs24Screen({Key? key, required this.participantId})
      : super(key: key);

  @override
  _ReviewUnbocs24ScreenState createState() => _ReviewUnbocs24ScreenState();
}

class _ReviewUnbocs24ScreenState extends State<ReviewUnbocs24Screen> {
  Map<String, dynamic>? participantData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchParticipantDetails();
  }

  Future<void> _fetchParticipantDetails() async {
    try {
      DatabaseReference participantRef = FirebaseDatabase.instance
          .ref()
          .child('participants')
          .child(widget.participantId);

      DatabaseEvent event = await participantRef.once();
      if (event.snapshot.exists) {
        setState(() {
          participantData =
              Map<String, dynamic>.from(event.snapshot.value as Map);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Participant details not found.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching details: $e'),
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Review Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : participantData == null
              ? const Center(
                  child: Text('No details available.'),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Participant Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Divider(thickness: 2, color: Colors.red),
                        const SizedBox(height: 16),
                        _buildDetailRow(
                            'Full Name', participantData!['fullName'] ?? ''),
                        _buildDetailRow('Nationality',
                            participantData!['nationality'] ?? ''),
                        _buildDetailRow('Passport/NRIC',
                            participantData!['passportNric'] ?? ''),
                        _buildDetailRow('Contact Number',
                            participantData!['contactNumber'] ?? ''),
                        _buildDetailRow('Emergency Contact',
                            participantData!['emergencyContact'] ?? ''),
                        _buildDetailRow(
                            'Category', participantData!['category'] ?? ''),
                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.center,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[900],
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
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
