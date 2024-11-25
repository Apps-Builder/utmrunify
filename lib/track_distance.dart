import 'package:flutter/material.dart';

class TrackingDistance extends StatefulWidget {
  const TrackingDistance({super.key});

  @override
  _TrackingDistanceState createState() => _TrackingDistanceState();
}

class _TrackingDistanceState extends State<TrackingDistance> {
  String selectedTab = 'Day';

  final Map<String, String> tabContent = {
    'Day': 'You covered 5 KM today!',
    'Week': 'This week: 30 KM!',
    'Month': 'This month: 120 KM!',
    'Year': 'Year-to-date: 850 KM!',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 119, 0, 50),
            Colors.white,
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text('Distance'),
          actions: const [
            Icon(Icons.grid_view, size: 30.0),
            SizedBox(width: 10.0),
          ],
        ),
        body: Column(
          children: [
            const SizedBox(height: 16.0),
            // Tab Selector
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 0, 50),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ['Day', 'Week', 'Month', 'Year'].map((tab) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTab = tab;
                      });
                    },
                    child: Text(
                      tab,
                      style: TextStyle(
                        color: tab == selectedTab ? Colors.yellow : Colors.white,
                        fontSize: 18.0,
                        fontWeight: tab == selectedTab ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20.0),
            // Display Tab Content
            Container(
              height: 150.0,
              width: double.infinity,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 0, 50),
                borderRadius: BorderRadius.circular(18.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  tabContent[selectedTab]!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Progress Tracker
            Container(
              height: 250.0,
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 0, 50),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Column(
                children: [
                  const Text(
                    'Progress Tracker',
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                  ),
                  const SizedBox(height: 20.0),
                  LinearProgressIndicator(
                    value: selectedTab == 'Day'
                        ? 0.7
                        : selectedTab == 'Week'
                            ? 0.5
                            : selectedTab == 'Month'
                                ? 0.8
                                : 0.6,
                    color: Colors.yellow,
                    backgroundColor: Colors.white.withOpacity(0.3),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    '${(selectedTab == 'Day'
                            ? 0.7
                            : selectedTab == 'Week'
                                ? 0.5
                                : selectedTab == 'Month'
                                    ? 0.8
                                    : 0.6) * 100}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
