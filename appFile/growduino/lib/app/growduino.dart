import 'package:flutter/material.dart';
import 'package:growduino/ui/login/login_page.dart';

class GrowduinoApp extends StatelessWidget {
  GrowduinoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const GrowduinoHomePage(),
    );
  }
}

class GrowduinoHomePage extends StatefulWidget {
  const GrowduinoHomePage({Key? key}) : super(key: key);

  @override
  _GrowduinoHomePageState createState() => _GrowduinoHomePageState();
}

class _GrowduinoHomePageState extends State<GrowduinoHomePage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  buildTextField(
                    labelText: 'Username',
                    labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 63, 39)),
                    borderColor: const Color.fromARGB(255, 1, 63, 39),
                    borderWidth: 1.0,
                    isObscure: false,
                  ),
                  const SizedBox(height: 30),
                  buildTextField(
                    labelText: 'Password',
                    labelStyle: const TextStyle(fontSize: 20, color: Color.fromARGB(255, 1, 63, 39)),
                    borderColor: const Color.fromARGB(255, 1, 63, 39),
                    borderWidth: 1.0,
                    isObscure: true, // Set isObscure to true
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
                      onPressed: () {
                        // Add your sign-in logic here
                        String username = _usernameController.text;
                        String password = _passwordController.text;

                        print('Username: $username');
                        print('Password: $password');
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
    );
  }

  Widget buildTextField({
    required String labelText,
    required TextStyle labelStyle,
    required Color borderColor,
    required double borderWidth,
    required bool isObscure, // New parameter to determine if the text should be obscured
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 25.0, right: 25.0),
      child: TextField(
        controller: labelText == 'Username' ? _usernameController : _passwordController,
        obscureText: isObscure, // Set obscureText property
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
}
