import 'package:flutter/material.dart';
import 'unbocs24.dart'; // Import Unbocs24 run screen
import 'seloka.dart'; // Import Seloka run screen
import 'equin3.dart'; // Import Equin3 run screen

class HomeRunningEvents extends StatelessWidget {
  const HomeRunningEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Home', style: TextStyle(fontSize: 18, color: Colors.white)),
            Text(
              'Running events',
              style: TextStyle(fontSize: 14, color: Colors.white70),
            ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.account_circle, color: Colors.white),
          onPressed: () {
            // Navigate to user profile
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Implement "View all" navigation
            },
            child: const Text(
              'View all',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildEventCard(
            context,
            date: 'NOV\n10',
            imagePath: 'assets/Event 1.png',
            eventTitle: 'Unbocs24 RUN',
          ),
          const SizedBox(height: 16),
          _buildEventCard(
            context,
            date: 'DEC\n21',
            imagePath: 'assets/Event 2.jpg',
            eventTitle: 'Seloka Run',
          ),
          const SizedBox(height: 16),
          _buildEventCard(
            context,
            date: 'JAN\n10',
            imagePath: 'assets/Event 3.png',
            eventTitle: 'Equin3 VRun',
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Record',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_run),
            label: 'Activity',
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(
    BuildContext context, {
    required String date,
    required String imagePath,
    required String eventTitle,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10.0)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    date,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  eventTitle,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (eventTitle == 'Unbocs24 RUN') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Unbocs24RunScreen()),
                        );
                      } else if (eventTitle == 'Seloka Run') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SelokaRunScreen()),
                        );
                      } else if (eventTitle == 'Equin3 VRun') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Equin3RunScreen()),
                        );
                      } else {
                        // Handle other events or show a message
                      }
                    },
                    child: const Text(
                      'Register Now',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
