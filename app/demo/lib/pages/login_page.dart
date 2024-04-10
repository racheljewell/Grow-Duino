import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GrowduinoApp extends StatelessWidget {
  GrowduinoApp({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<String?> signInWithEmailAndPassword({
    required String email, 
    required String password
  }) async {
    print(email);
    print(password);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigate to the home page or perform any other actions upon successful sign-in
      return 'Success';
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: $e');
      return 'Error';
      // Show error message to the user
      // You can use Flutter's SnackBar or showDialog for this purpose
    }
  }

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
            borderRadius: BorderRadius.circular(45.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: borderWidth * 2),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 45),
                    const Text(
                      'GrowDuino',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF013f27),
                      ),
                    ),
                    const SizedBox(height: 85),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 1, 63, 39), width: 1.0),
                        ),
                        labelText: 'Username',
                        labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 63, 39)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 1, 63, 39)),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 1, 63, 39), width: 1.0 * 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 1, 63, 39), width: 1.0),
                        ),
                        labelText: 'Password',
                        labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 63, 39)),
                        border: OutlineInputBorder(
                          borderSide: const BorderSide(color: Color.fromARGB(255, 1, 63, 39)),
                          borderRadius: BorderRadius.circular(45.0),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Color.fromARGB(255, 1, 63, 39), width: 1.0 * 2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 1, 63, 39),
                        borderRadius: BorderRadius.circular(10.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextButton(
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                            const Size(100, 50),
                          ),
                          foregroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 255, 251, 251)),
                          overlayColor: MaterialStateProperty.resolveWith<Color?>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered)) {
                                return const Color.fromARGB(255, 255, 251, 251).withOpacity(0.04);
                              }
                              if (states.contains(MaterialState.focused) || states.contains(MaterialState.pressed)) {
                                return const Color.fromARGB(255, 255, 251, 251).withOpacity(0.12);
                              }
                              return null;
                            },
                          ),
                        ),
                        
                        onPressed: () async {
                          // Replace 'email' and 'password' with the actual values entered by the user
                          final message = await signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
                          print(message);
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            fontSize: 20,
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


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  // final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/img/home_background.png'), // Replace with your provided image path
            fit: BoxFit.cover, // Adjust as needed
          ),
        ),
      ),
    );
  }
}