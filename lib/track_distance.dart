import 'package:flutter/material.dart';

class TrackingDistance extends StatelessWidget {
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: const Color.fromARGB(255, 255, 255, 255),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: const Text('Distance'),
          actions: [
            Icon(Icons.grid_view, size: 30.0),
            const SizedBox(width: 10.0),
          ],
        ),
        body: Column(
          children: [
            Container(
              height: 400.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 0, 50),
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: const [
                        Text('Day', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                        Text('Week', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                        Text('Month', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                        Text('Year', style: TextStyle(color: Colors.white, fontSize: 18.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 100.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 0, 50),
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
            const SizedBox(height: 20.0),
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 119, 0, 50),
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
