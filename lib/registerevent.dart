import 'package:flutter/material.dart';
import 'participants_details.dart';
import 'main.dart';
import 'package:utmrunify/userhomepage.dart';

class RunSelectionPage extends StatefulWidget {
  final RunningEvent selectedEvent;

  const RunSelectionPage({super.key, required this.selectedEvent});

  @override
  _RunSelectionPageState createState() => _RunSelectionPageState();
}

class _RunSelectionPageState extends State<RunSelectionPage> {
  bool is5kmSelected = true;
  bool is10kmSelected = false;
  String selectedSize = 'Size';
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final entitlements = is5kmSelected
        ? [
            '1. 5KM UNBOCS\'24 finisher jersey',
            '2. 5KM finisher medal',
            '3. 5KM race bib',
            '4. E-certificate',
            '5. Refreshments',
          ]
        : [
            '1. 10KM UNBOCS\'24 finisher jersey',
            '2. 10KM finisher medal',
            '3. 10KM race bib',
            '4. E-certificate',
            '5. Refreshments',
          ];

    final subtotal = is5kmSelected ? 'RM45.00' : 'RM60.00';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.selectedEvent.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            tooltip: 'Cart',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart functionality coming soon!')),
              );
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
            const SizedBox(height: 8),
            // Interactive Selection for 5KM
            GestureDetector(
              onTap: () {
                setState(() {
                  is5kmSelected = true;
                  is10kmSelected = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('5KM selected')),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: is5kmSelected
                      ? const Color.fromARGB(255, 119, 0, 50)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  '5KM',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Interactive Selection for 10KM
            GestureDetector(
              onTap: () {
                setState(() {
                  is5kmSelected = false;
                  is10kmSelected = true;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('10KM selected')),
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: is10kmSelected
                      ? const Color.fromARGB(255, 119, 0, 50)
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: const Text(
                  '10KM',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your entitlements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...entitlements.map((item) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(item),
                )),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: selectedSize,
              items: <String>['Size', 'XS', 'S', 'M', 'L', 'XL', 'XXL']
                  .map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Row(
                    children: [
                      const Icon(Icons.checkroom),
                      const SizedBox(width: 8.0),
                      Text(value),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSize = newValue!;
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Selected size: $selectedSize')),
                );
              },
              style: const TextStyle(fontSize: 16, color: Colors.black),
              isExpanded: true,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal $subtotal',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    String selectedCategory =
                        is5kmSelected ? '5KM run' : '10KM run';
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ParticipantFormPage(
                          category: selectedCategory,
                          selectedEvent: widget.selectedEvent,
                        ),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('SUBMIT'),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Selected: ${_getNavLabel(index)}')),
          );
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fiber_manual_record), label: 'Record'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: 'Shop'),
          BottomNavigationBarItem(icon: Icon(Icons.directions_run), label: 'Activity'),
        ],
        selectedItemColor: const Color.fromARGB(255, 119, 0, 50),
        unselectedItemColor: Colors.black,
      ),
    );
  }

  String _getNavLabel(int index) {
    switch (index) {
      case 0:
        return 'Home';
      case 1:
        return 'Notifications';
      case 2:
        return 'Record';
      case 3:
        return 'Shop';
      case 4:
        return 'Activity';
      default:
        return '';
    }
  }
}
