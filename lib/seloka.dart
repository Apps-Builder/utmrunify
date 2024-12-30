import 'package:flutter/material.dart';
import 'signup_seloka.dart'; // Import the signup screen for Seloka Run

class SelokaRunScreen extends StatelessWidget {
  const SelokaRunScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'SELOKA RUN',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.asset(
            'assets/Event 2.jpg', // Updated with the image for Seloka Run
            fit: BoxFit.cover,
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            'SELOKA RUN',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text('21 December 2024 (Saturday) | 07:30 AM'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 8),
              Text('Stadium Azman Hashim'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'ABOUT',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            '1. Seloka Run finisher jersey\n'
            '2. Finisher medal\n'
            '3. Race bib\n'
            '4. E-certificate\n'
            '5. Refreshments',
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'RACE KIT COLLECTION',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const Text(
            'Date: 18 - 20 December 2024\n'
            'Time: 10.00 a.m - 5.00 p.m\n'
            'Venue: Stadium Azman Hashim',
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to SignupSelokaScreen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupSelokaScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: const Text(
              'SIGN UP',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
