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
    subtotal = selectedCategoryName.isNotEmpty ? selectedCategory.price : 0.0;
  print(selectedCategory.price);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(widget.selectedEvent.name),
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
                      style: TextStyle(
                        fontSize: 16,
                        color: selectedCategoryName == category.name
                            ? Colors.white
                            : Colors.black,
                      ),
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
            if (selectedCategoryName.isNotEmpty)
              ...entitlements.asMap().entries.map((entry) {
                int index = entry.key; // This is the index of the item
                Entitlement entitlement = entry.value; // This is the Entitlement object itself
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${index + 1}. ${entitlement.name}', // Display index, name, and isShirt status
                        style: const TextStyle(fontSize: 16),
                      ),
                      if (entitlement.isShirt) // Check if entitlement is a shirt
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: DropdownButton<String>(
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
                            },
                            style: const TextStyle(fontSize: 16, color: Colors.black),
                            isExpanded: true,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),

            const SizedBox(height: 16),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal \$${subtotal.toStringAsFixed(2)}', // Display the dynamic subtotal
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                ElevatedButton(
                  onPressed: selectedCategoryName.isNotEmpty && selectedSize != 'Size'
                      ? () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation, secondaryAnimation) =>
                            ParticipantFormPage(
                              category: selectedCategory,
                              selectedEvent: widget.selectedEvent,
                              selectedShirtSize: selectedSize
                            ),
                        transitionsBuilder:
                            (context, animation, secondaryAnimation, child) {
                          const begin = Offset(1.0, 0.0);
                          const end = Offset.zero;
                          const curve = Curves.easeInOut;

                          var tween = Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: curve));
                          var offsetAnimation = animation.drive(tween);

                          return SlideTransition(
                            position: offsetAnimation,
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      foregroundColor: Colors.white
                  ),
                  child: const Text('SUBMIT'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
