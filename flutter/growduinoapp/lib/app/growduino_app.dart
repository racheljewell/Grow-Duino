import 'package:flutter/material.dart';
import 'package:growduinoapp/ui/home/home_page.dart';

class GrowduinoApp extends StatelessWidget {
  const GrowduinoApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            const MyHomePage(),
            Center(
              child: Container(
                width: 300,
                height: 650,
                decoration: BoxDecoration(
                  color: const Color(0x00d9d9d9).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(top: 30.0, left: 8.0),
                        child: Text(
                          'GrowDuino',
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF013f27), // Set text color to fully opaque
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Add some space between title and other content
                      // Add other content here
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
