import 'package:flutter/material.dart';
import 'package:growduinoapp/ui/login/login_page.dart';

class GrowduinoApp extends StatelessWidget {
  const GrowduinoApp({super.key});

  // Function to create a text field with custom input decoration
  Widget buildTextField({
    required String labelText,
    required TextStyle labelStyle,
    required Color borderColor,
    required double borderWidth,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: TextField(
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: borderWidth),
          ),
          labelText: labelText,
          labelStyle: labelStyle,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor),
            borderRadius: BorderRadius.circular(45.0)
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: borderWidth*2),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            const LoginPage(),
            Center(
              child: Container(
                width: 300,
                height: 650,
                decoration: BoxDecoration(
                  color: const Color(0x00d9d9d9).withOpacity(0.5),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.center, // Align children in the center horizontally
                  children: [
                    const SizedBox(height: 45), // Add some space from the top
                    const Text(
                      'GrowDuino',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF013f27), // Set text color to fully opaque
                      ),
                    ),
                    const SizedBox(height: 85), // Add some space between title and other content
                    buildTextField(
                      labelText: 'Username', 
                      labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 63, 39)), 
                      borderColor: const Color.fromARGB(255, 1, 63, 39),
                      borderWidth: 1.0
                    ), // TextField
                    const SizedBox(height: 30),
                    buildTextField(
                      labelText: 'Password', 
                      labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 63, 39)), 
                      borderColor: const Color.fromARGB(255, 1, 63, 39),
                      borderWidth: 1.0
                    ), // TextField
                    const SizedBox(height: 30),
                    Container(
                      decoration: (BoxDecoration(
                        color: const Color.fromARGB(255, 1, 63, 39),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3), // changes the shadow direction
                          ),
                        ],
                      )
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100,50),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 251, 251)),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return const Color.fromARGB(255, 255, 251, 251).withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) ||
                                  states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 255, 251, 251).withOpacity(0.12);
                              }
                              return null; // Defer to the widget's default.
                            },
                          ),
                        ),
                        onPressed: () { },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 20, // Adjust the font size here
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
