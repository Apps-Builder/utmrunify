import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:utmrunify/loginpage.dart';

import 'package:utmrunify/userprofilepage.dart';
import 'auth_service.dart';

import 'event_details.dart';
import 'homepage.dart';
import 'track_distance.dart';
import 'shop.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final _auth = AuthService();
  static final List<Widget> _pages = <Widget>[
    HomePage(),
    NotificationPage(),
    FeedbackPage(),
    ShopPage(),
    ActivityPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _auth.listenForTokenChanges(); // Start listening for token changes
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.person_pin),
          color: const Color.fromARGB(255, 119, 0, 50),
          iconSize: 40,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          },
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notification',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.feedback),
            label: 'Feedback',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Shop', // 'Shop' tab should navigate to ShopPage
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history_toggle_off_rounded),
            label: 'Activity',
          ),
        ],
        currentIndex: _selectedIndex,
        unselectedItemColor: Colors.blueGrey[400],
        selectedItemColor: const Color.fromARGB(255, 119, 0, 50),
        type: BottomNavigationBarType.fixed,
        onTap: _onItemTapped,
        unselectedFontSize: 12,
        selectedFontSize: 12,
      ),
    );
  }
}

// class HomePage extends StatelessWidget {
//   const HomePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Text(
//               'Running Events',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             const Divider(
//               color: Color.fromARGB(255, 119, 0, 50),
//               thickness: 3,
//             ),
//             Expanded(
//               child: StreamBuilder<QuerySnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('events')
//                     .orderBy('createdAt', descending: true)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//
//                   if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
//                     return const Center(child: Text('No events available.'));
//                   }
//
//                   final eventDocs = snapshot.data!.docs;
//
//                   return ListView.builder(
//                     itemCount: eventDocs.length,
//                     itemBuilder: (context, index) {
//                       final event =
//                           eventDocs[index].data() as Map<String, dynamic>;
//                       /*child: ListView.builder(
//                 itemCount: runningEvents.length,
//                 itemBuilder: (context, index) {
//                   final event = runningEvents[index];*/
//                       return Card(
//                         margin: const EdgeInsets.symmetric(vertical: 3),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Stack(
//                               children: [
//                                 Container(
//                                   height: 200,
//                                   decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(5),
//                                   ),
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(5),
//                                     child: Image.network(
//                                       event['picture'] ?? '',
//                                       /*child: Image.asset(
//                                   event.imagePath,*/
//                                       fit: BoxFit.cover,
//                                       width: double.infinity,
//                                     ),
//                                   ),
//                                 ),
//                                 Positioned(
//                                   top: 8,
//                                   left: 8,
//                                   child: Container(
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 4, horizontal: 8),
//                                     decoration: BoxDecoration(
//                                       color: Colors.black87,
//                                       borderRadius: BorderRadius.circular(4),
//                                     ),
//                                     child: Text(
//                                       event['date'] ?? 'N/A',
//                                       //event.date,
//                                       style: const TextStyle(
//                                           color: Colors.white,
//                                           fontWeight: FontWeight.bold),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.all(12.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     event['eventName'] ?? 'Event Name',
//                                     //event.name,
//                                     style: const TextStyle(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   const SizedBox(height: 4),
//                                   Text(event['location'] ?? 'Location'),
//                                   //Text(event.location),
//                                   const SizedBox(height: 8),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       final runningEvent = RunningEvent(
//                                         event['eventName'] ?? 'Event Name',
//                                         event['date'] ?? 'N/A',
//                                         event['location'] ?? 'Location',
//                                         event['picture'] ??
//                                             '', // Assuming 'picture' is the key for the image URL
//                                         event['collectDate'] ?? 'N/A',
//                                         event['collectTime'] ?? 'N/A',
//                                         event['collectLocation'] ?? 'N/A',
//                                       );
//                                       Navigator.push(
//                                         context,
//                                         MaterialPageRoute(
//                                           builder: (context) =>
//                                               EventDetailsPage(
//                                                   event: runningEvent),
//                                           //builder: (context) => EventDetailsPage(event: event),
//                                         ),
//                                       );
//                                     },
//                                     style: ElevatedButton.styleFrom(
//                                       backgroundColor:
//                                           const Color.fromARGB(255, 119, 0, 50),
//                                       shape: RoundedRectangleBorder(
//                                         borderRadius: BorderRadius.circular(8),
//                                       ),
//                                     ),
//                                     child: const Text(
//                                       'Register Now',
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// // RunningEvent class and mock event data
// class RunningEvent {
//   final String name;
//   final String date;
//   final String location;
//   final String imagePath;
//   final String collectDate;
//   final String collectTime;
//   final String collectLocation;
//
//   RunningEvent(this.name, this.date, this.location, this.imagePath,
//       this.collectDate, this.collectTime, this.collectLocation);
// }
//
// final List<RunningEvent> runningEvents = [
//   RunningEvent(
//       'UNBOCS 24 RUN',
//       'Nov 15',
//       'Student Union Building UTM',
//       'assets/image/unbocs.jpg',
//       '13-14 November 2024',
//       '12.00 p.m - 4.00 p.m',
//       'Dewan Sultan Iskandar'),
//   RunningEvent(
//       'Larian Seloka',
//       'Dec 22',
//       'Stadium Azman Hashim UTM',
//       'assets/image/seloka.jpg',
//       '21 December 2024',
//       '12.00 p.m - 4.00 p.m',
//       'Dewan Sultan Iskandar'),
//   RunningEvent(
//       'Night Trail',
//       'Jan 05',
//       'Mountain Path',
//       'assets/image/night.jpg',
//       '04 January 2025',
//       '12.00 p.m - 4.00 p.m',
//       'Dewan Sultan Iskandar'),
// ];

// Placeholder Pages
class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Notification Page'));
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Feedback Page'));
  }
}

class ActivityPage extends StatelessWidget {
  const ActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TrackingDistance();
  }
}

goToLogin(BuildContext context) => Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
        transitionDuration: Duration.zero, // Removes the transition duration
        reverseTransitionDuration: Duration.zero, // Removes reverse transition
      ),
    );
