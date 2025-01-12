import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utmrunify/main.dart';
import 'package:utmrunify/userhomepage.dart';
import 'package:utmrunify/services/StripeService.dart';
import 'auth_service.dart';
import 'homepage.dart';

class ViewRegistrationPage extends StatefulWidget {
  final String registrationId;

  const ViewRegistrationPage({super.key, required this.registrationId});

  @override
  _ViewRegistrationPageState createState() => _ViewRegistrationPageState();
}

class _ViewRegistrationPageState extends State<ViewRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  late final String userID;
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController nationalityController = TextEditingController();
  final TextEditingController passportNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController emergencyContactNameController = TextEditingController();
  final TextEditingController emergencyContactController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController postCodeController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController emergencyRelationshipController = TextEditingController();
  final TextEditingController bloodTypeController = TextEditingController();
  final TextEditingController medicalConditionsController = TextEditingController();

  String fullName = '';
  String contactNumber = '';
  String selectedNationality = '';

  String emergencyContact = '';
  String gender = '';
  String address = '';

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getRegistrationDetails();
  }

  Future<void> _getRegistrationDetails() async {
    try {
      userID = _auth.getUserID();
      final registrationDoc = await FirebaseFirestore.instance.collection('registration').doc(widget.registrationId).get();

      if (registrationDoc.exists) {
        setState(() {
          fullNameController.text = registrationDoc.data()!['name'] ?? '';
          genderController.text = registrationDoc.data()!['gender'] ?? '';
          nationalityController.text = registrationDoc.data()!['nationality'] ?? '';
          passportNoController.text = registrationDoc.data()!['passportNo'] ?? '';
          addressController.text = registrationDoc.data()!['address'] ?? '';
          emergencyContactNameController.text = registrationDoc.data()!['emergencyContactName'] ?? '';
          emergencyContactController.text = registrationDoc.data()!['emergencyContact'] ?? '';
          contactNumberController.text = registrationDoc.data()!['contactno'] ?? '';
          dobController.text = registrationDoc.data()!['dateofbirth'] ?? '';
          postCodeController.text = registrationDoc.data()!['postCode'] ?? '';
          cityController.text = registrationDoc.data()!['city'] ?? '';
          stateController.text = registrationDoc.data()!['state'] ?? '';
          emailController.text = registrationDoc.data()!['email'] ?? '';
          emergencyRelationshipController.text = registrationDoc.data()!['emergencyRelationship'] ?? '';
          bloodTypeController.text = registrationDoc.data()!['bloodType'] ?? '';
          medicalConditionsController.text = registrationDoc.data()!['medicalConditions'] ?? '';
          setState(() {
            isLoading = false; // Stop loading on error
          });
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found.')),
        );
        setState(() {
          isLoading = false; // Stop loading on error
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  Future<void> _autofillDetails() async {
    try {
      final userId = _auth.getUserID();
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          fullNameController.text = userDoc.data()!['name'] ?? '';
          contactNumberController.text = userDoc.data()!['contactno'] ?? '';
          dobController.text = userDoc.data()!['dateofbirth'] ?? ''; // Autofill DOB
          emailController.text = userDoc.data()!['email'] ?? ''; // Autofill Email
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
    }
  }

  @override
  void dispose() {
    fullNameController.dispose();
    genderController.dispose();
    nationalityController.dispose();
    passportNoController.dispose();
    addressController.dispose();
    emergencyContactNameController.dispose();
    emergencyContactController.dispose();
    contactNumberController.dispose();
    dobController.dispose();
    postCodeController.dispose();
    cityController.dispose();
    stateController.dispose();
    emailController.dispose();
    emergencyRelationshipController.dispose();
    bloodTypeController.dispose();
    medicalConditionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDateOfBirth(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != DateTime.now()) {
      setState(() {
        dobController.text = "${pickedDate.toLocal()}".split(' ')[0]; // Format date as yyyy-mm-dd
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      // Show loading indicator while waiting for organiserName
      return Scaffold(
        appBar: AppBar(
          title: Text("Registration Details"),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text("Registration Details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Participant Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(color: Color.fromARGB(255, 119, 0, 50), thickness: 2),
                const SizedBox(height: 8),
                _buildTextField(
                  'Full Name*',
                      (value) => fullNameController.text = value,
                  controller: fullNameController,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Contact Number*',
                      (value) => contactNumberController.text = value,
                  controller: contactNumberController,
                  keyboardType: TextInputType.phone,
                ),
                _buildTextField(
                  'Passport No*',
                      (value) => passportNoController.text = value,
                  controller: passportNoController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Nationality*',
                      (value) => nationalityController.text = value!,
                  controller: nationalityController
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Gender*',
                      (value) => genderController.text = value!,
                    controller: genderController
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _selectDateOfBirth(context),
                  child: AbsorbPointer(
                    child: _buildTextField(
                      'Date of Birth*',
                          (value) => dobController.text = value,
                      controller: dobController,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _buildTextField('Address*', (value) => addressController.text = value, controller: addressController),
                const SizedBox(height: 8),
                _buildTextField('Post Code*', (value) => postCodeController.text = value, controller: postCodeController),
                const SizedBox(height: 8),
                _buildTextField('City*', (value) => cityController.text = value, controller: cityController),
                const SizedBox(height: 8),
                _buildTextField('State*', (value) => stateController.text = value, controller: stateController),
                const SizedBox(height: 8),
                _buildTextField('Email Address*', (value) => emailController.text = value, controller: emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 8),
                _buildTextField(
                  'Emergency Contact Name*',
                      (value) => emergencyContactNameController.text = value,
                  controller: emergencyContactNameController,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Emergency Contact*',
                      (value) => emergencyContactController.text = value,
                  controller: emergencyContactController,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Emergency Contact Relationship*',
                      (value) => emergencyRelationshipController.text = value!,
                  controller: emergencyRelationshipController,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Blood Type*',
                      (value) => bloodTypeController.text = value!,
                  controller: bloodTypeController,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Medical Conditions*',
                      (value) => medicalConditionsController.text = value,
                  controller: medicalConditionsController,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged,
      {TextInputType keyboardType = TextInputType.text,
        TextEditingController? controller}) {
    return TextFormField(
      readOnly: true,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: controller?.text.isEmpty == true ? 'Enter your $label' : null,
      ),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

}
