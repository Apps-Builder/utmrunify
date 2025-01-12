import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'auth_service.dart';
import 'eventdetailpage.dart';
import 'homepage.dart';

class EditEventPage extends StatefulWidget {

  final String eventId;

  const EditEventPage({super.key, required this.eventId});

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final _formKey = GlobalKey<FormState>();
  late final String fullName;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers to manage user input
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventDescriptionController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final TextEditingController _registrationEndTimeController = TextEditingController();
  final TextEditingController _registrationEndDateController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _eventDateController = TextEditingController();
  final TextEditingController _racekitcollectiondateController =
  TextEditingController();
  final TextEditingController _racekitcollectiontimeController =
  TextEditingController();
  final TextEditingController _racekitcollectionlocationController =
  TextEditingController();

  late final List<Category> categories;

  // Controllers for category and entitlement
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _entitlementController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(); // Controller for price

  File? _selectedEventBanner; // To store the picked image
  File? _selectedEventRouteMapImage;
  File? _selectedEventEntitlementImage;
  String? _imageUrl, _imageUrl2, _imageUrl3; // To store the uploaded image URL
  bool _agreedToTerms = false;

  bool _isShirtEntitlement = false; // To track if entitlement is a shirt

  final ImagePicker _picker = ImagePicker();

  // Store categories and their entitlements
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _currentEntitlements = [];

  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _getEventDetails();
  }

  Future<void> _getEventDetails() async {
    try {
      final eventDoc = await FirebaseFirestore.instance.collection('events').doc(widget.eventId).get();

      final data = eventDoc.data() as Map<String, dynamic>;
      var categoryList = (data['categories'] as List)
          .map((categoryData) => categoryData as Map<String, dynamic>)
          .toList();

      if (eventDoc.exists) {
        setState(() {
          _eventNameController.text = eventDoc.data()!['name'] ?? '';
          _eventDescriptionController.text = eventDoc.data()!['description'] ?? '';
          fullName = eventDoc.data()!['organiser'] ?? '';
          _eventDateController.text = eventDoc.data()!['eventDate'] ?? '';
          _eventTimeController.text = eventDoc.data()!['eventTime'] ?? '';
          _registrationEndDateController.text = eventDoc.data()!['registrationEndDate'] ?? '';
          _registrationEndTimeController.text = eventDoc.data()!['registrationEndTime'] ?? '';
          _locationController.text = eventDoc.data()!['location'] ?? '';
          _imageUrl = eventDoc.data()!['eventBannerUrl'] ?? '';
          _imageUrl2 = eventDoc.data()!['eventEntitlementUrl'] ?? '';
          _imageUrl3 = eventDoc.data()!['eventRouteMapUrl'] ?? '';
          _racekitcollectiondateController.text = eventDoc.data()!['race_kit_collection_date'] ?? '';
          _racekitcollectiontimeController.text = eventDoc.data()!['race_kit_collection_time'] ?? '';
          _racekitcollectionlocationController.text = eventDoc.data()!['race_kit_collection_venue'] ?? '';
          _categories = categoryList;
          isLoading = false; // Data is loaded, set isLoading to false
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
  Widget build(BuildContext context) {

    if (isLoading) {
      // Show loading indicator while waiting for data
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Event'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Show loading indicator
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildTextField('Name*', '',
                  controller: _eventNameController),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventDateController,
                decoration: InputDecoration(
                  labelText: 'Date',
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
                      _eventDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Date is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventTimeController, // This name can be updated to suit your needs
                decoration: InputDecoration(
                  labelText: 'Time*', // Label should reflect that it's for time input
                  suffixIcon: Icon(Icons.access_time), // Use a clock icon for time
                ),
                readOnly: true, // Make it read-only to trigger the picker on tap
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(), // Set initial time to the current time
                  );
                  if (pickedTime != null) {
                    setState(() {
                      // Convert the picked time to string format (e.g., "HH:mm AM/PM")
                      _eventTimeController.text = pickedTime.format(context);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Time is required'; // Validation for empty time field
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _registrationEndDateController,
                decoration: InputDecoration(
                  labelText: 'Registration End Date*',
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
                      _registrationEndDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Registration End Date is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _registrationEndTimeController, // This name can be updated to suit your needs
                decoration: InputDecoration(
                  labelText: 'Registration End Time*', // Label should reflect that it's for time input
                  suffixIcon: Icon(Icons.access_time), // Use a clock icon for time
                ),
                readOnly: true, // Make it read-only to trigger the picker on tap
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(), // Set initial time to the current time
                  );
                  if (pickedTime != null) {
                    setState(() {
                      // Convert the picked time to string format (e.g., "HH:mm AM/PM")
                      _registrationEndTimeController.text = pickedTime.format(context);
                    });
                  }
                },
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Registration End Time is required'; // Validation for empty time field
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              buildTextField('Location*', '',
                  controller: _locationController),
              SizedBox(height: 16),
              TextFormField(
                controller: _eventDescriptionController,
                decoration: InputDecoration(
                  labelText: 'Description*',
                  hintText: 'Enter event description',
                ),
                maxLines: null,  // Allow multiple lines
                keyboardType: TextInputType.multiline,  // Set the keyboard type to multiline
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Description is required';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _racekitcollectiondateController,
                decoration: InputDecoration(
                  labelText: 'Race Kit Collection Date',
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
                      _racekitcollectiondateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _racekitcollectiontimeController, // This name can be updated to suit your needs
                decoration: InputDecoration(
                  labelText: 'Race Kit Collection Time', // Label should reflect that it's for time input
                  suffixIcon: Icon(Icons.access_time), // Use a clock icon for time
                ),
                readOnly: true, // Make it read-only to trigger the picker on tap
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(), // Set initial time to the current time
                  );
                  if (pickedTime != null) {
                    setState(() {
                      // Convert the picked time to string format (e.g., "HH:mm AM/PM")
                      _racekitcollectiontimeController.text = pickedTime.format(context);
                    });
                  }
                },
              ),
              SizedBox(height: 16),
              buildTextField('Race Kit Collection Location',
                  '',
                  controller: _racekitcollectionlocationController),
              SizedBox(height: 16),

              // Category and entitlement input
              buildTextField('Category', '',
                  controller: _categoryController),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: buildTextField('Entitlement', '',
                        controller: _entitlementController),
                  ),
                  SizedBox(width: 8), // Add some spacing between the text field and the checkbox
                  Column(
                    children: [
                      Checkbox(
                        value: _isShirtEntitlement,
                        onChanged: (bool? value) {
                          setState(() {
                            _isShirtEntitlement = value ?? false;
                          });
                        },
                      ),
                      Text('Shirt'), // Optional: Label the checkbox for better clarity
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_entitlementController.text.isNotEmpty) {
                    setState(() {
                      _currentEntitlements.add({
                        'name': _entitlementController.text,
                        'isShirt': _isShirtEntitlement, // Add the shirt status
                      });
                    });
                    _entitlementController.clear();
                    _isShirtEntitlement = false; // Reset the shirt checkbox
                  }
                },
                child: Text('Add Entitlement'),
              ),
              SizedBox(height: 16),


              // Display current entitlements for the category
              if (_currentEntitlements.isNotEmpty) ...[
                Text(
                  'Entitlements for "${_categoryController.text}":',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _currentEntitlements.length,
                  itemBuilder: (context, index) {
                    final entitlement = _currentEntitlements[index];
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '• ${entitlement['name']}',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _currentEntitlements.removeAt(index);
                            });
                          },
                        ),
                      ],
                    );
                  },
                ),
                SizedBox(height: 16),
              ],
              SizedBox(height: 8),
              buildTextField('Price', '',
                  controller: _priceController, keyboardType: TextInputType.number),
              ElevatedButton(
                onPressed: () {
                  if (_categoryController.text.isNotEmpty &&
                      _currentEntitlements.isNotEmpty &&
                      _priceController.text.isNotEmpty) {
                    setState(() {
                      _categories.add({
                        'name': _categoryController.text,
                        'entitlements': List<Map<String, dynamic>>.from(_currentEntitlements), // Copy the list of maps
                        'price': double.tryParse(_priceController.text) ?? 0.0, // Store price
                      });
                      _categoryController.clear();
                      _priceController.clear(); // Clear the price input after adding the category
                      _currentEntitlements.clear();
                    });
                  }
                },
                child: Text('Add Category with Entitlements and Price'),
              ),
              SizedBox(height: 16),

              ..._categories.asMap().entries.map((entry) {
                int index = entry.key;
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
                            Text(
                              'Category: ${category['name']}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Price: \$${category['price'].toStringAsFixed(2)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
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
                          children: (category['entitlements'] as List<dynamic>?)
                              ?.map((entitlement) => Text(
                            '• ${entitlement['name']} ${entitlement['isShirt'] ? '(Shirt)' : ''}',
                          ))
                              .toList() ??
                              [],
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),


              _imageUrl == null
                  ? TextButton(
                onPressed: () {_pickImage("Banner");},
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
                  _selectedEventBanner != null
                      ? Image.file(
                    _selectedEventBanner!,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  )
                      : Image.network(
                    _imageUrl!, // URL of the image
                    height: 200,
                    fit: BoxFit.scaleDown,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Handle errors
                  ),
                  TextButton(
                    onPressed: () {_pickImage("Banner");},
                    child: Text('Change Event Banner'),
                  ),
                ],
              ),
              _imageUrl2 == null
                  ? TextButton(
                onPressed: () {_pickImage("Entitlement");},
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF870C14), // Set the background color
                ),
                child: Text(
                  'Upload Event Entitlement Image',
                  style: TextStyle(color: Colors.white), // Set the text color
                ),
              )
                  : Column(
                children: [
                  _selectedEventEntitlementImage != null
                      ? Image.file(
                    _selectedEventEntitlementImage!,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  )
                      : Image.network(
                    _imageUrl2!, // URL of the image
                    height: 200,
                    fit: BoxFit.scaleDown,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Handle errors
                  ),
                  TextButton(
                    onPressed: () {_pickImage("Entitlement");},
                    child: Text('Change Event Entitlement Image'),
                  ),
                ],
              ),
              _imageUrl3 == null
                  ? TextButton(
                onPressed: () {_pickImage("Route Map");},
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF870C14), // Set the background color
                ),
                child: Text(
                  'Upload Event Route Map',
                  style: TextStyle(color: Colors.white), // Set the text color
                ),
              )
                  : Column(
                children: [
                  _selectedEventRouteMapImage != null
                      ? Image.file(
                    _selectedEventRouteMapImage!,
                    height: 200,
                    fit: BoxFit.scaleDown,
                  )
                      : Image.network(
                    _imageUrl3!, // URL of the image
                    height: 200,
                    fit: BoxFit.scaleDown,
                    errorBuilder: (context, error, stackTrace) => Icon(Icons.error), // Handle errors
                  ),
                  TextButton(
                    onPressed: () {_pickImage("Route Map");},
                    child: Text('Change Event Route Map'),
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
                    setState(() {
                      isLoading = true; // Start loading
                    });
                    await saveEventToFirestore();
                    setState(() {
                      isLoading = false; // Stop loading after upload
                    });
                  } else if (!_agreedToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please agree to the terms and conditions')),
                    );
                  }
                },
                child: Text('UPDATE', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(String imageType) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        if (imageType == "Banner") {
          _selectedEventBanner = File(pickedFile.path);
        } else if (imageType == "Route Map") {
          _selectedEventRouteMapImage = File(pickedFile.path);
        } else if (imageType == "Entitlement") {
          _selectedEventEntitlementImage = File(pickedFile.path);
        }

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
    if (_selectedEventBanner != null) {
      _imageUrl = await _uploadImage(_selectedEventBanner!);
    }

    if (_selectedEventEntitlementImage != null) {
      _imageUrl2 = await _uploadImage(_selectedEventEntitlementImage!);
    }

    if (_selectedEventRouteMapImage != null) {
      _imageUrl3 = await _uploadImage(_selectedEventRouteMapImage!);
    }

    if (_imageUrl == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please upload an event image.')),
      );
      return;
    }

    try {
      // Create the event document in Firestore
      await _firestore.collection('events').doc(widget.eventId).update({
        'name': _eventNameController.text.trim(),
        'organiser': fullName,
        'description': _eventDescriptionController.text.trim(),
        'eventDate': _eventDateController.text.trim(),
        'eventTime': _eventTimeController.text.trim(),
        'registrationEndDate': _registrationEndDateController.text.trim(),
        'registrationEndTime': _registrationEndTimeController.text.trim(),
        'eventBannerUrl': _imageUrl,
        'eventEntitlementUrl': _imageUrl2,
        'eventRouteMapUrl': _imageUrl3,
        'location': _locationController.text.trim(),
        'race_kit_collection_date': _racekitcollectiondateController.text.trim(),
        'race_kit_collection_time': _racekitcollectiontimeController.text.trim(),
        'race_kit_collection_venue': _racekitcollectionlocationController.text.trim(),
        'categories': _categories, // Add categories (including price) to Firestore
      });

      // Navigate to the event details page
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event Updated Successfully')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    }
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
      ),
      readOnly: readOnly,
      onTap: onTap,
      keyboardType: keyboardType,
      validator: (value) {
        if (value != null && value.isEmpty && label != 'Race Kit Collection Location' && label != 'Category' && label != 'Entitlement' && label != 'Price') {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }

}
