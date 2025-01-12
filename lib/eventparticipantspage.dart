import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:utmrunify/viewregistrationpage.dart';

import 'auth_service.dart';

class EventParticipants extends StatefulWidget {

  final String eventId;

  const EventParticipants({super.key, required this.eventId});

  @override
  _EventParticipants createState() => _EventParticipants();
}

class _EventParticipants extends State<EventParticipants> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _auth = AuthService();
  late String eventName;
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    _getEventDetails();
  }

  Future<void> _getEventDetails() async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('events').doc(widget.eventId).get();

      if (userDoc.exists) {
        setState(() {
          eventName = userDoc.data()!['name'] ?? '';
          isLoading = false; // Set loading to false after data is fetched
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User data not found.')),
        );
        setState(() {
          isLoading = false; // Stop loading even if user data is missing
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch user data: $e')),
      );
      setState(() {
        isLoading = false; // Stop loading on error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Show loading indicator while waiting for organiserName
      return Scaffold(
        appBar: AppBar(
          title: Text('Select Participant'),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Participant'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('registration').where('eventName', isEqualTo: eventName).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No events found.'));
          }

          final registrations = snapshot.data!.docs;

          return ListView.builder(
            itemCount: registrations.length,
            itemBuilder: (context, index) {
              final registration = registrations[index];
              final eventData = registration.data() as Map<String, dynamic>;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(registration['name'] ?? 'Unnamed Event'),
                  subtitle: Text('NRIC: ${eventData['passportNo'] ?? 'N/A'}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.visibility, color: Colors.grey),
                        onPressed: () => _viewEventParticipants(registration.id),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _confirmDelete(registration.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _viewEventParticipants(String registrationId) {
    // Navigate to an event editing page or show a dialog to edit the event
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewRegistrationPage(registrationId: registrationId),
      ),
    );
  }

  void _confirmDelete(String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Participant'),
        content: Text('Are you sure you want to remove this participant?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _deleteUser(userId);
              Navigator.pop(context);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteUser(String registrationId) async {
    try {
      await _firestore.collection('registration').doc(registrationId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Participant removed successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete participant: $e')),
      );
    }
  }
}
