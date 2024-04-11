import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key});

  Future<Map<String, dynamic>> pullSettings(String title) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/grow-duino/us-central1/getSettings'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'settings': title,
      }),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      // and return the settings.
      return jsonDecode(response.body);
    } else {
      // If the server returns an error response, throw an exception.
      throw Exception('Failed to load settings');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Demo'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              try {
                // Call the pullSettings function when the button is pressed
                Map<String, dynamic> settings = await pullSettings('your_title_here');
                // Process the settings data here
                print(settings);
              } catch (e) {
                // Handle any errors that occur during the request
                print('Error: $e');
              }
            },
            child: const Text('Pull Settings'),
          ),
        ),
      ),
    );
  }
}
