import 'package:flutter/material.dart';

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
              
              buildTextField('Event Name*', 'eg. UNBOCS RUN'),
              SizedBox(height: 16),
              
              
              buildTextField('Category*', 'eg. 5KM'),
              SizedBox(height: 16),

              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: buildTextField('Time*', '8:00')),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: 'AM',
                    items: ['AM', 'PM']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      
                    },
                  ),
                  SizedBox(width: 16),
                  Expanded(child: buildTextField('', '9:00')),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    value: 'AM',
                    items: ['AM', 'PM']
                        .map((value) => DropdownMenuItem(
                              value: value,
                              child: Text(value),
                            ))
                        .toList(),
                    onChanged: (value) {
                      
                    },
                  ),
                ],
              ),
              SizedBox(height: 16),

              
              buildTextField('Date*', 'Select date', readOnly: true, onTap: () async {
                
                await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
              }),
              SizedBox(height: 16),

              
              buildTextField('Organizer Name*', 'eg. MUHAMMAD'),
              SizedBox(height: 16),

              
              buildTextField('Contact No*', 'eg. 0111.....', keyboardType: TextInputType.phone),
              SizedBox(height: 16),

              
              buildTextField('Email*', 'eg. Ali@graduate.utm.my', keyboardType: TextInputType.emailAddress),
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
                onPressed: () {
                  if (_formKey.currentState!.validate() && _agreedToTerms) {
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Form submitted successfully!')),
                    );
                  } else if (!_agreedToTerms) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please agree to the terms and conditions')),
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

  Widget buildTextField(String label, String placeholder,
      {bool readOnly = false, VoidCallback? onTap, TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
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
