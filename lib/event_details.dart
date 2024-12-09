import 'package:flutter/material.dart';
import 'main.dart';
import 'registerevent.dart'; 

class EventDetailsPage extends StatelessWidget {
  final RunningEvent event;

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: AssetImage(event.imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              event.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.calendar_today, color: Color.fromARGB(255, 119, 0, 50)),
                const SizedBox(width: 8),
                Text(event.date),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, color: Color.fromARGB(255, 119, 0, 50)),
                const SizedBox(width: 8),
                Text(event.location),
              ],
            ),
            const Divider(height: 32, color: Color.fromARGB(255, 119, 0, 50), thickness: 3),
            const Text(
              'ABOUT',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 119, 0, 50)),
            ),
            const SizedBox(height: 8),
            const Text(
              'Runner\'s entitlement: \n\n1. Finisher jersey\n2. Finisher Medal\n3. Race bib\n4. E-certificate\n5. Refreshments',
            ),
            const Divider(height: 32, color: Color.fromARGB(255, 119, 0, 50), thickness: 3),
            const Text(
              'RACE KIT COLLECTION',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color.fromARGB(255, 119, 0, 50)),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${event.collectDate}\n'
              'Time: ${event.collectTime}\n'
              'Venue: ${event.collectLocation}\n',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            // Sign Up Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RunSelectionPage(selectedEvent: event)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'SIGN UP',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
