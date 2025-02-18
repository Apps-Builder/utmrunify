import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:utmrunify/main.dart';
import 'package:utmrunify/userhomepage.dart';
import 'package:utmrunify/services/StripeService.dart';
import 'auth_service.dart';
import 'homepage.dart';

class ParticipantFormPage extends StatefulWidget {
  final Category category;
  final RunningEvent selectedEvent;
  final String selectedShirtSize;

  const ParticipantFormPage({super.key, required this.category, required this.selectedEvent, required this.selectedShirtSize});

  @override
  _ParticipantFormPageState createState() => _ParticipantFormPageState();
}

class _ParticipantFormPageState extends State<ParticipantFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _auth = AuthService();
  late final String userID;
  final TextEditingController fullNameController = TextEditingController();
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
  bool isAgreed = false;
  bool isLoading = false;

  bool isMeSelected = false; // Default selection
  bool isNewSelected = false;

  // Method for "Me" button onPressed
  void _selectMe() {
    setState(() {
      isMeSelected = true;
      isNewSelected = false; // Deselect the "New" button
      _autofillDetails(); // Autofill user details
    });
  }

  // Method for "New" button onPressed
  void _selectNew() {
    setState(() {
      isNewSelected = true;
      isMeSelected = false; // Deselect the "Me" button

      // Clear all text fields
      fullNameController.clear();
      passportNoController.clear();
      addressController.clear();
      emergencyContactNameController.clear();
      emergencyContactController.clear();
      contactNumberController.clear();
      dobController.clear();
      postCodeController.clear();
      cityController.clear();
      stateController.clear();
      emailController.clear();
      emergencyRelationshipController.clear();
      bloodTypeController.clear();
      medicalConditionsController.clear();
      selectedNationality = '';
      gender = '';
    });
  }

  List<String> countries = [
    'Malaysia', 'Singapore', 'Indonesia', 'Thailand',
    'United States', 'Canada', 'Germany', 'Australia', 'India', 'China', 'Japan', 'Brazil', 'Russia',
    // Add more countries or use a package to get a full list.
  ];

  List<String> genders = ['Male', 'Female', 'Other'];

  List<String> emergencyRelationships = [
    'Husband', 'Wife', 'Son', 'Daughter', 'Grandfather', 'Grandmother',
    'Father', 'Mother', 'Brother', 'Sister', 'Uncle', 'Aunt', 'Cousin',
    'Nephew', 'Niece', 'Other'
  ];

  List<String> bloodTypes = [
    'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-', 'I don\'t know'
  ];

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  Future<void> _getUserDetails() async {
    try {
      userID = _auth.getUserID();
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(userID).get();

      if (userDoc.exists) {
        setState(() {
          fullName = userDoc.data()!['name'] ?? '';
          contactNumber = userDoc.data()!['contactno'] ?? '';
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
          title: Text(widget.selectedEvent.name),
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
        title: Text(widget.selectedEvent.name),
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
                  'Category',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(color: Color.fromARGB(255, 119, 0, 50), thickness: 2),
                Text(widget.category.name, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text(
                  'Entitlements',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(color: Color.fromARGB(255, 119, 0, 50), thickness: 2),
                ...List.generate(
                  widget.category.entitlements.length,
                      (index) {
                    String entitlementName = widget.category.entitlements[index].name;
                    // Add '(Shirt)' if entitlement is a shirt
                    if (widget.category.entitlements[index].isShirt) {
                      entitlementName += ' (Chosen Size: ${widget.selectedShirtSize})';
                    }
                    return Text(
                      '${index + 1}. $entitlementName',
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                ),

                Text("", style: const TextStyle(fontSize: 16)),
                const Text(
                  'Participant Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(color: Color.fromARGB(255, 119, 0, 50), thickness: 2),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isMeSelected
                            ? const Color.fromARGB(255, 119, 0, 50)
                            : const Color.fromARGB(255, 200, 200, 200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: _selectMe, // Autofill user details when clicked
                      child: Text(
                        "$fullName (me)",
                        style: TextStyle(fontSize: 14, color: isMeSelected ? Colors.white : Colors.black,),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isNewSelected
                            ? const Color.fromARGB(255, 119, 0, 50)
                            : const Color.fromARGB(255, 200, 200, 200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                      onPressed: _selectNew, // Call the separate method
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        child: Text(
                          "(New)",
                          style: TextStyle(
                            fontSize: 14,
                            color: isNewSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
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
                _buildDropdownField(
                  'Nationality*',
                  countries,
                      (value) => selectedNationality = value!,
                ),
                const SizedBox(height: 8),
                _buildDropdownField(
                  'Gender*',
                  genders,
                      (value) => gender = value!,
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
                _buildDropdownField(
                  'Emergency Contact Relationship*',
                  emergencyRelationships,
                      (value) => emergencyRelationshipController.text = value!,
                ),
                const SizedBox(height: 8),
                _buildDropdownField(
                  'Blood Type*',
                  bloodTypes,
                      (value) => bloodTypeController.text = value!,
                ),
                const SizedBox(height: 8),
                _buildTextField(
                  'Medical Conditions*',
                      (value) => medicalConditionsController.text = value,
                  controller: medicalConditionsController,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: isAgreed,
                      onChanged: (value) {
                        setState(() {
                          isAgreed = value!;
                        });
                      },
                    ),
                    Expanded(
                      child: Text(
                        'I have read and agree to abide by the rules and regulations of the ${widget.selectedEvent.name}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () async {
                      if (_formKey.currentState!.validate() && isAgreed) {
                          if (await StripeService.instance.makePayment(widget.category.price.toInt())) {
                            setState(() {
                              isLoading = true; // Start loading
                            });
                            uploadInfoToDb();
                            setState(() {
                              isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Payment success. Registration success.'))
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => MyHomePage()),  // Replace with your homepage widget
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Payment failed. Please try again.'))
                            );
                          }
                      } else if (!isAgreed) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please agree to the terms')),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        foregroundColor: Colors.white
                    ),
                    child: isLoading
                        ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                        : const Text('SUBMIT'),
                  ),
                ),
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

  Widget _buildDropdownField(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: items.map((item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select your $label';
        }
        return null;
      },
    );
  }

  void uploadInfoToDb() async {
    try {
      FirebaseFirestore.instance.collection("registration").doc().set({
        "userID": userID,
        "eventName": widget.selectedEvent.name,
        "eventCategory": widget.category.name,
        "shirtSize": widget.selectedShirtSize,
        "email": emailController.text.trim(),
        "contactno": contactNumberController.text.trim(),
        "dateofbirth": dobController.text.trim(),
        "nationality": selectedNationality,
        "gender": gender,
        "name": fullNameController.text.trim(),
        "passportNo": passportNoController.text.trim(),
        "address": addressController.text.trim(),
        "emergencyContactName": emergencyContactNameController.text.trim(),
        "emergencyContact": emergencyContactController.text.trim(),
        "postCode": postCodeController.text.trim(),
        "city": cityController.text.trim(),
        "state": stateController.text.trim(),
        "emergencyRelationship": emergencyRelationshipController.text.trim(),
        "bloodType": bloodTypeController.text.trim(),
        "medicalConditions": medicalConditionsController.text.trim(),
      });
    } catch (e) {
      print(e);
    }
  }

}
