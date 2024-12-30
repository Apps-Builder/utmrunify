import 'package:flutter/material.dart';
import 'participant_details_unbocs24.dart';

class SignupUnbocs24Screen extends StatefulWidget {
  const SignupUnbocs24Screen({Key? key}) : super(key: key);

  @override
  _SignupUnbocs24ScreenState createState() => _SignupUnbocs24ScreenState();
}

class _SignupUnbocs24ScreenState extends State<SignupUnbocs24Screen> {
  bool is5kmSelected = false; // Default not selected
  bool is10kmSelected = false; // Default not selected
  String selectedSize = 'XL - SHORT SLEEVE';
  double subtotal = 0.0; // Initial subtotal is 0 as no category is selected

  void _updateSubtotal() {
    setState(() {
      subtotal = (is5kmSelected ? 45 : 0) + (is10kmSelected ? 60 : 0);
    });
  }

  // Method to get the entitlements based on the selected category
  String _getEntitlements() {
    if (is5kmSelected) {
      return '1. 5KM UNBOCS\'24 finisher jersey\n'
          '2. 5KM finisher medal\n'
          '3. 5KM race bib\n'
          '4. E-certificate\n'
          '5. Refreshments';
    } else if (is10kmSelected) {
      return '1. 10KM UNBOCS\'24 finisher jersey\n'
          '2. 10KM finisher medal\n'
          '3. 10KM race bib\n'
          '4. E-certificate\n'
          '5. Refreshments';
    }
    return 'Please select a category to see your entitlements.';
  }

  // Navigation method
  void _navigateToParticipantDetails() {
    String selectedCategory = is5kmSelected ? '5KM' : '10KM';
    if (is5kmSelected || is10kmSelected) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ParticipantDetailsUnbocs24Screen(
            category: selectedCategory,
          ),
        ),
      );
    } else {
      // Show a dialog if no category is selected
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Selection Required'),
            content: const Text('Please select a category before proceeding.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
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
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Handle additional actions if needed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              value: is5kmSelected,
              onChanged: (value) {
                setState(() {
                  is5kmSelected = value!;
                  if (is5kmSelected) is10kmSelected = false;
                  _updateSubtotal();
                });
              },
              title: const Text('5KM'),
            ),
            CheckboxListTile(
              value: is10kmSelected,
              onChanged: (value) {
                setState(() {
                  is10kmSelected = value!;
                  if (is10kmSelected) is5kmSelected = false;
                  _updateSubtotal();
                });
              },
              title: const Text('10KM'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your entitlements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(_getEntitlements()),
            const SizedBox(height: 16),
            const Text(
              'Size',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: selectedSize,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSize = newValue!;
                });
              },
              items: <String>[
                'XS - SHORT SLEEVE',
                'S - SHORT SLEEVE',
                'M - SHORT SLEEVE',
                'L - SHORT SLEEVE',
                'XL - SHORT SLEEVE',
                '2XL - SHORT SLEEVE',
                '3XL - SHORT SLEEVE',
                '4XL - SHORT SLEEVE',
                '5XL - SHORT SLEEVE',
                '6XL - SHORT SLEEVE',
                '7XL - SHORT SLEEVE',
                '8XL - SHORT SLEEVE',
              ].map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              dropdownColor: Colors.white,
              underline: Container(
                height: 2,
                color: Colors.red[900],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: double.infinity,
                  child: Image.asset(
                    'assets/size_chart.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal: RM${subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: _navigateToParticipantDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[900],
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'NEXT',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
