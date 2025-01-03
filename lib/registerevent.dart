import 'package:flutter/material.dart';
import 'homepage.dart';
import 'participants_details.dart';
import 'main.dart';

class RunSelectionPage extends StatefulWidget {
  final RunningEvent selectedEvent;

  const RunSelectionPage({super.key, required this.selectedEvent});

  @override
  _RunSelectionPageState createState() => _RunSelectionPageState();
}

class _RunSelectionPageState extends State<RunSelectionPage> {
  String selectedCategoryName = ''; // To track the selected category
  String selectedSize = 'Size';
  int _currentIndex = 0;
  double subtotal = 0.0; // Initialize subtotal to 0.0

  @override
  Widget build(BuildContext context) {
    // Find the selected category based on the selected category name
    var selectedCategory = widget.selectedEvent.categories.firstWhere(
          (category) => category.name == selectedCategoryName,
      orElse: () => widget.selectedEvent.categories.first, // Default to the first category
    );

    final entitlements = selectedCategory.entitlements;

    // Update the subtotal based on the price of the selected category
    subtotal = selectedCategory.price;

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
            // Display categories dynamically from selectedEvent
            Wrap(
              spacing: 5.0, // Horizontal space between items
              runSpacing: 8.0, // Vertical space between rows
              children: widget.selectedEvent.categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryName = category.name;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${category.name} selected')),
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: selectedCategoryName == category.name
                          ? const Color.fromARGB(255, 119, 0, 50)
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      category.name,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            const Text(
              'Your entitlements',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Display entitlements based on the selected category
            ...entitlements.asMap().entries.map((entry) {
              int index = entry.key; // This is the index of the item
              String item = entry.value; // This is the item itself
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  '${index + 1}. $item', // Add the index number and the item
                  style: const TextStyle(fontSize: 16),
                ),
              );
            }).toList(),

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
                  'Subtotal \$${subtotal.toStringAsFixed(2)}', // Display the dynamic subtotal
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ParticipantFormPage(
                              category: selectedCategoryName,
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
