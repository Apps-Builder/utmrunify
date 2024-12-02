import 'package:flutter/material.dart';
import 'addevent.dart';



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Running events',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    
                  },
                  child: Text('See More >'),
                ),
              ],
            ),
          ),
       
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                EventCard(
                  date: 'OCT\n12',
                  title: 'UNBOCS\' Run',
                  image: 'assets/img/unbocs.jpg',
                ),

                EventCard(
                  date: 'NOV\n23',
                  title: 'KELIP-KELIP\' Run',
                  image: 'assets/img/Kelip2.jpeg',
                ),

                EventCard(
                  date: 'DEC\n21',
                  title: 'SELOKA\' Run',
                  image: 'assets/img/Seloka.jpeg',
                ),
                // Add more EventCards here
              ],
            ),
          ),
          // Grid buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              mainAxisSpacing: 16.0,
              crossAxisSpacing: 16.0,
              physics: NeverScrollableScrollPhysics(),
              children: [
                FeatureButton(
                  icon: Icons.people,
                  label: 'Participants',
                  onPressed: () {
              
                  },
                ),
                FeatureButton(
                  icon: Icons.event,
                  label: 'Manage Event',
                  onPressed: () {
                 
                  },
                ),
                FeatureButton(
                  icon: Icons.add_circle,
                  label: 'Register Event',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterEventPage()), 
                    );
                  },
                ),
                FeatureButton(
                  icon: Icons.bar_chart,
                  label: 'Report',
                  onPressed: () {
                   
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date;
  final String title;
  final String image;

  EventCard({required this.date, required this.title, required this.image});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image.asset(
              image,
              fit: BoxFit.cover,
              width: 150,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  date,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeatureButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  FeatureButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.black),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
