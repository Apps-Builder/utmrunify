import 'package:flutter/material.dart';
import 'signup_equin3.dart'; // Import the signup screen for Equin3 VRun

class Equin3RunScreen extends StatelessWidget {
  const Equin3RunScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'EQUIN3 VRUN',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Image.asset(
            'assets/Event 3.png', // Updated the image asset path for Equin3 VRun
            fit: BoxFit.cover,
            height: 200,
          ),
          const SizedBox(height: 16),
          Text(
            'EQUIN3 VRUN',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 8),
              const Text('10 January 2025 (Friday) | 07:00 AM'),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.location_on, size: 16),
              const SizedBox(width: 8),
              const Text('Virtual Run'),
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
            '1. Equin3 VRun finisher jersey\n'
            '2. Finisher medal\n'
            '3. Exclusive digital badge\n'
            '4. E-certificate\n'
            '5. Leaderboard ranking',
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
            'Date: 7 - 9 January 2025\n'
            'Time: 10:00 AM - 4:00 PM\n'
            'Venue: Dewan Sultan Iskandar',
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Navigate to SignupEquin3Screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SignupEquin3Screen(),
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
