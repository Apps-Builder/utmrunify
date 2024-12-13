import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RegisterEventPage(),
    );
  }
}

class RegisterEventPage extends StatefulWidget {
  @override
  _RegisterEventPageState createState() => _RegisterEventPageState();
}

class _RegisterEventPageState extends State<RegisterEventPage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Controllers to manage user input
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _startTimeController = TextEditingController();
  final TextEditingController _endTimeController = TextEditingController();
  final TextEditingController _organizerNameController =TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _pictureController = TextEditingController();

  bool _agreedToTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Register Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Event Name*', 'eg. UNBOCS RUN', controller:_eventNameController),
              SizedBox(height: 16),
              buildTextField('Category*', 'eg. 5KM', controller: _categoryController),
              SizedBox(height: 16),
              buildTextField('Description*', 'Enter event description', controller: _descriptionController),
              SizedBox(height: 16),
              buildTextField('Location*', 'Enter event location', controller: _locationController),
              SizedBox(height: 16),
              buildTextField('Price*', 'Enter ticket price', controller: _priceController, keyboardType: TextInputType.number),
              SizedBox(height: 16),
      buildTextField('Picture URL*', 'Enter picture URL', controller: _pictureController),
SizedBox(height: 16),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: buildTextField('Start Time*', '8:00', controller: _startTimeController)),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: 'AM',
                    items: ['AM', 'PM']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  SizedBox(width: 16),
                  Expanded(child: buildTextField('End Time*', '9:00', controller: _endTimeController)),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: 'AM',
                    items: ['AM', 'PM']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                ],
              ),
              SizedBox(height: 16),
              buildTextField('Date*', 'Select date', controller: _dateController, readOnly: true,
                  onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (selectedDate != null) {
                  setState(() {
                    _dateController.text = "${selectedDate.toLocal()}".split(' ')[0]; // Format as YYYY-MM-DD
                  });
                }
              }),
              SizedBox(height: 16),
              buildTextField('Organizer Name*', 'eg. MUHAMMAD', controller: _organizerNameController),
              SizedBox(height: 16),
              buildTextField('Contact No*', 'eg. 0111.....',
                  keyboardType: TextInputType.phone, controller: _contactController),
              SizedBox(height: 16),
              buildTextField('Email*', 'eg. Ali@graduate.utm.my',
                  keyboardType: TextInputType.emailAddress, controller: _emailController),
              SizedBox(height: 16),
              Row(
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (bool? value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Text(
                      'I have read and agreed to abide by the rules & regulations of the UTM',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () async{
                  if (_formKey.currentState!.validate() && _agreedToTerms) {
                    await saveEventToFirestore();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Form submitted successfully!')),
                    );
                  } else if (!_agreedToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content:
                              Text('Please agree to the terms and conditions')),
                    );
                  }
                },
                child: Text('SUBMIT'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> saveEventToFirestore() async {
  try {
    await _firestore.collection('events').add({
  'eventName': _eventNameController.text.trim(),
  'category': _categoryController.text.trim(),
  'startTime': _startTimeController.text,
  'endTime': _endTimeController.text,
  'date': _dateController.text,
  'organizerName': _organizerNameController.text.trim(),
  'contact': _contactController.text.trim(),
  'email': _emailController.text.trim(),
  'description': _descriptionController.text.trim(),
  'location': _locationController.text.trim(),
  'price': double.tryParse(_priceController.text.trim()) ?? 0,
  'picture': _pictureController.text.trim(),
  'createdAt': FieldValue.serverTimestamp(),
});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Event registered successfully!')),
    );
    _clearFormFields();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error saving event: $e')),
    );
  }
}

// Helper method to clear form fields after successful submission
void _clearFormFields() {
  _eventNameController.clear();
  _categoryController.clear();
  _startTimeController.clear();
  _endTimeController.clear();
  _dateController.clear();
  _organizerNameController.clear();
  _contactController.clear();
  _emailController.clear();
  _descriptionController.clear();
  _locationController.clear();
  _priceController.clear();
  _pictureController.clear();
}


  Widget buildTextField(String label, String placeholder,
      {TextEditingController? controller,
      bool readOnly = false,
      VoidCallback? onTap,
      TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(),
      ),
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$label is required';
        }
        return null;
      },
    );
  }
}
