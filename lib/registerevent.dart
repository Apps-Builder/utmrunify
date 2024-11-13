import 'package:flutter/material.dart';

class RunSelectionPage extends StatefulWidget {
  const RunSelectionPage({super.key});

  @override
  _RunSelectionPageState createState() => _RunSelectionPageState();
}

class _RunSelectionPageState extends State<RunSelectionPage> {
  bool is5kmSelected = true;
  bool is10kmSelected = false;
  String selectedSize = 'Size';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('UNBOCS\'24 RUN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Handle cart action here
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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            CheckboxListTile(
              title: const Text('5KM'),
              value: is5kmSelected,
              onChanged: (value) {
                setState(() {
                  is5kmSelected = value!;
                  if (value) is10kmSelected = false;
                });
              },
            ),
            CheckboxListTile(
              title: const Text('10KM'),
              value: is10kmSelected,
              onChanged: (value) {
                setState(() {
                  is10kmSelected = value!;
                  if (value) is5kmSelected = false;
                });
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Your entitlements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('1. 5KM UNBOCS\'24 finisher jersey'),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedSize,
              items: <String>['Size', 'XS', 'S', 'M', 'L', 'XL', 'XXL']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSize = newValue!;
                });
              },
              style: const TextStyle(fontSize: 16, color: Colors.black),
              isExpanded: true,
            ),
            const SizedBox(height: 16),
            const Text('2. 5KM finisher medal'),
            const Text('3. 5KM race bib'),
            const Text('4. E-certificate'),
            const Text('5. Refreshments'),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Subtotal RM45.00',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Handle submit action here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('SUBMIT'),
                ),
              ],
            ),
          ],
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
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.black,
      ),
    );
  }
}
