import 'package:flutter/material.dart';
import 'signup_unbocs24.dart'; // Import the signup screen

class Unbocs24RunScreen extends StatelessWidget {
  const Unbocs24RunScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'UNBOCS\' 24 RUN',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.asset(
            'assets/Event 1.png', // Update with the correct path for your image
            fit: BoxFit.cover,
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            'UNBOCS\' 24 RUN',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              Text('10 November 2024 (Sunday) | 07:00 AM'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 8),
              Text('Student Union Building UTM'),
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
            '1. UNBOCS\'24 finisher jersey\n'
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
            'Date: 6 - 8 November 2024\n'
            'Time: 11.00 a.m - 4.00 p.m\n'
            'Venue: Dewan Sultan Iskandar',
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to SignupUnbocs24Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupUnbocs24Screen(),
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
