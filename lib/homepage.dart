import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'event_details.dart';

class Category {
  final String name;
  final List<String> entitlements;
  final double price; // Change price to int

  Category({
    required this.name,
    required this.entitlements,
    required this.price, // Initialize price in constructor
  });

  // Factory method to create a Category instance from a map
  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      name: map['name'] ?? '',
      entitlements: List<String>.from(map['entitlements'] ?? []),
      price: map['price'] != null ? double.tryParse(map['price'].toString()) ?? 0 : 0, // Parse price as int
    );
  }
}



class RunningEvent {
  final String name;
  final String eventDate;
  final String imageUrl;
  final String location;
  final String raceKitCollectionDate;
  final String raceKitCollectionTime;
  final String raceKitCollectionVenue;
  final List<Category> categories;

  RunningEvent({
    required this.name,
    required this.eventDate,
    required this.location,
    required this.imageUrl,
    required this.raceKitCollectionDate,
    required this.raceKitCollectionTime,
    required this.raceKitCollectionVenue,
    required this.categories,
  });

  // Factory method to create an instance from Firestore document
  factory RunningEvent.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    var categoryList = (data['categories'] as List)
        .map((categoryData) => Category.fromMap(categoryData))
        .toList();

    return RunningEvent(
      name: data['name'] ?? '',
      eventDate: data['eventDate'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      raceKitCollectionDate: data['race_kit_collection_date'] ?? '',
      raceKitCollectionTime: data['race_kit_collection_time'] ?? '',
      raceKitCollectionVenue: data['race_kit_collection_venue'] ?? '',
      categories: categoryList,
    );
  }
}



class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<RunningEvent> runningEvents = [];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final collection = FirebaseFirestore.instance.collection('events');
    final querySnapshot = await collection.get();

    final events = querySnapshot.docs
        .map((doc) => RunningEvent.fromFirestore(doc))
        .toList();

    setState(() {
      runningEvents.addAll(events);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Running Events',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Divider(
              color: Color.fromARGB(255, 119, 0, 50),
              thickness: 3,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: runningEvents.length,
                itemBuilder: (context, index) {
                  final event = runningEvents[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              height: 200,
                              width: double.infinity, // Make the width span the parent container
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.grey[200], // Optional: Background color for better appearance
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5),
                                child: Image.network(
                                  event.imageUrl, // Assuming this is a valid image URL
                                  fit: BoxFit.cover, // Ensures the image fills the container
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300], // Fallback color
                                      child: Center(
                                        child: Text(
                                          'Image not available',
                                          style: TextStyle(color: Colors.grey),
                                        ),
                                      ),
                                    );
                                  },
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) {
                                      return child; // Image is fully loaded
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress.expectedTotalBytes != null
                                            ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),

                            Positioned(
                              top: 8,
                              left: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                                decoration: BoxDecoration(
                                  color: Colors.black87,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  event.eventDate,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(event.location),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          EventDetailsPage(event: event),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color.fromARGB(255, 119, 0, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Register Now',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
