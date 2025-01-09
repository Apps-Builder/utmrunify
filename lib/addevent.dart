import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'eventdetailpage.dart';

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

  // Controllers to manage user input
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _racekitcollectiondateController =
  TextEditingController();
  final TextEditingController _racekitcollectiontimeController =
  TextEditingController();
  final TextEditingController _racekitcollectionlocationController =
  TextEditingController();

  // Controllers for category and entitlement
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _entitlementController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // Controller for price

  File? _selectedImage; // To store the picked image
  String? _imageUrl; // To store the uploaded image URL
  bool _agreedToTerms = false;

  final ImagePicker _picker = ImagePicker();

  // Store categories and their entitlements
  List<Map<String, dynamic>> _categories = [];
  List<String> _currentEntitlements = []; // Temporary list to store entitlements for a single category

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
              buildTextField('Name', 'e.g. UNBOCS RUN',
                  controller: _eventNameController),
              SizedBox(height: 16),
              buildTextField('Date', 'e.g. 2024-12-15',
                  controller: _eventDateController),
              SizedBox(height: 16),
              buildTextField('Location', 'Enter event location',
                  controller: _locationController),
              SizedBox(height: 16),
              buildTextField('Race Kit Collection Date', 'e.g. 2024-12-14',
                  controller: _racekitcollectiondateController),
              SizedBox(height: 16),
              buildTextField('Race Kit Collection Time',
                  'e.g. 12:00 PM - 4:00 PM',
                  controller: _racekitcollectiontimeController),
              SizedBox(height: 16),
              buildTextField('Race Kit Collection Location',
                  'e.g. Dewan Sultan Iskandar',
                  controller: _racekitcollectionlocationController),
              SizedBox(height: 16),

              // Category and entitlement input
              buildTextField('Category', 'e.g. 5KM Fun Run',
                  controller: _categoryController),
              SizedBox(height: 8),
              buildTextField('Entitlement', 'e.g. Ultron Event Jersey',
                  controller: _entitlementController),
              SizedBox(height: 8),
              buildTextField('Price', 'e.g. 50',
                  controller: _priceController, keyboardType: TextInputType.number),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_entitlementController.text.isNotEmpty) {
                    setState(() {
                      _currentEntitlements.add(_entitlementController.text);
                    });
                    _entitlementController.clear();
                  }
                },
                child: Text('Add Entitlement'),
              ),
              SizedBox(height: 16),

              // Display current entitlements for the category
              if (_currentEntitlements.isNotEmpty) ...[
                Text('Entitlements for "${_categoryController.text}":'),
                ..._currentEntitlements.map((entitlement) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('• $entitlement'),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          setState(() {
                            _currentEntitlements.remove(entitlement);
                          });
                        },
                      ),
                    ],
                  );
                }).toList(),
                SizedBox(height: 16),
              ],

              ElevatedButton(
                onPressed: () {
                  if (_categoryController.text.isNotEmpty &&
                      _currentEntitlements.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    setState(() {
                      _categories.add({
                        'name': _categoryController.text,
                        'entitlements': List.from(_currentEntitlements),
                        'price': double.tryParse(_priceController.text) ?? 0.0, // Store price
                      });
                      _categoryController.clear();
                      _priceController.clear();  // Clear the price input after adding the category
                      _currentEntitlements.clear();
                    });
                  }
                },
                child: Text('Add Category with Entitlements and Price'),
              ),
              SizedBox(height: 16),

              // Display added categories and their entitlements
              ..._categories.asMap().entries.map((entry) {
                int index = entry.key; // Index of the current category
                Map<String, dynamic> category = entry.value;

                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Category: ${category['name']}',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('Price: \$${category['price'].toStringAsFixed(2)}', // Display price
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _categories.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: (category['entitlements'] as List)
                          .map((entitlement) =>
                          Text('• $entitlement'))
                          .toList(),
                    )],
                    ),
                  ),
                );
              }).toList(),

              _selectedImage == null
                  ? TextButton(
                onPressed: _pickImage,
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF870C14), // Set the background color
                ),
                child: Text(
                  'Upload Event Banner',
                  style: TextStyle(color: Colors.white), // Set the text color
                ),
              )
                  : Column(
                children: [
                  Image.file(_selectedImage!, height: 150),
                  TextButton(
                    onPressed: _pickImage,
                    child: Text('Change Image'),
                  ),
                ],
              ),
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
                      'I have read and agreed to abide by the rules & regulations of the UTM RUNIFY.',
                      style: TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF870C14),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate() && _agreedToTerms) {
                    await saveEventToFirestore();
                  } else if (!_agreedToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please agree to the terms and conditions')),
                    );
                  }
                },
                child: Text('SUBMIT', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('event_banner/${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = await storageRef.putFile(image);
      return await storageRef.getDownloadURL();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  Future<void> saveEventToFirestore() async {
    if (_selectedImage != null) {
      _imageUrl = await _uploadImage(_selectedImage!);
    }

    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an event image.')),
      );
      return;
    }

    try {
      // Create the event document in Firestore
      DocumentReference docRef = await _firestore.collection('events').add({
        'name': _eventNameController.text.trim(),
        'eventDate': _eventDateController.text.trim(),
        'imageUrl': _imageUrl,
        'location': _locationController.text.trim(),
        'race_kit_collection_date': _racekitcollectiondateController.text.trim(),
        'race_kit_collection_time': _racekitcollectiontimeController.text.trim(),
        'race_kit_collection_venue': _racekitcollectionlocationController.text.trim(),
        'categories': _categories, // Add categories (including price) to Firestore
      });

      // Retrieve the document data after saving
      DocumentSnapshot docSnapshot = await docRef.get();
      final eventData = docSnapshot.data() as Map<String, dynamic>;

      // Navigate to the event details page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EventDetailsPage(eventData: eventData),
        ),
      );

      _clearFormFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    }
  }

  void _clearFormFields() {
    _eventNameController.clear();
    _locationController.clear();
    _eventDateController.clear();
    _racekitcollectiondateController.clear();
    _racekitcollectiontimeController.clear();
    _racekitcollectionlocationController.clear();
    _categoryController.clear();
    _entitlementController.clear();
    _priceController.clear();
    setState(() {
      _selectedImage = null;
      _imageUrl = null;
      _categories = [];
      _currentEntitlements = [];
    });
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
        if (value != null && value.isEmpty && label != 'Category' && label != 'Entitlement' && label != 'Price') {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

}
