import 'package:flutter/material.dart';
import 'package:utmrunify/main.dart';
import 'package:utmrunify/userhomepage.dart';

class ParticipantFormPage extends StatefulWidget {
  final String category;
  final RunningEvent selectedEvent;

  const ParticipantFormPage({super.key, required this.category, required this.selectedEvent});

  @override
  _ParticipantFormPageState createState() => _ParticipantFormPageState();
}

class _ParticipantFormPageState extends State<ParticipantFormPage> {
  final _formKey = GlobalKey<FormState>();
  String fullName = '';
  String nationality = '';
  String passportOrNric = '';
  String contactNumber = '';
  String emergencyContact = '';
  String address = '';
  bool isAgreed = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
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
                Text(widget.category, style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                const Text(
                  'Participant Details',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const Divider(color: Color.fromARGB(255, 119, 0, 50), thickness: 2),
                const SizedBox(height: 8),
                _buildTextField('Full name', (value) => fullName = value),
                const SizedBox(height: 8),
                _buildTextField('Nationality', (value) => nationality = value),
                const SizedBox(height: 8),
                _buildTextField('Passport/NRIC', (value) => passportOrNric = value),
                const SizedBox(height: 8),
                _buildTextField('Contact Number', (value) => contactNumber = value, keyboardType: TextInputType.phone),
                const SizedBox(height: 8),
                _buildTextField('Emergency Contact Number', (value) => emergencyContact = value, keyboardType: TextInputType.phone),
                const SizedBox(height: 8),
                _buildTextField('Address', (value) => address = value),
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
                        'I have read and agree to abide by the rules and regulations of the ${widget.category.toUpperCase()}',
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
                              setState(() {
                                isLoading = true;
                              });
                              await Future.delayed(const Duration(seconds: 2)); // Simulate form submission
                              setState(() {
                                isLoading = false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Form submitted successfully!')),
                              );
                            } else if (!isAgreed) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Please agree to the terms')),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
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
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.fiber_manual_record), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Activity'),
        ],
        selectedItemColor: const Color.fromARGB(255, 119, 0, 50),
        unselectedItemColor: Colors.black,
      ),
    );
  }

  Widget _buildTextField(String label, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label),
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
