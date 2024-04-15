import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'profile_page.dart';
import 'package:demo/components/theme/app_theme.dart';
import 'package:provider/provider.dart';

class GrowduinoApp extends StatelessWidget {
  GrowduinoApp({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<bool?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Navigate to the home page or perform any other actions upon successful sign-in
      return true;
    } catch (e) {
      // Handle sign-in errors
      print('Sign-in error: $e');
      return false;
      // Show error message to the user
      // You can use Flutter's SnackBar or showDialog for this purpose
    }
  }

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
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) => MaterialApp(
        title: 'GrowDuino App',
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,
        home: Scaffold(
          body: Stack(
            children: [
              const LoginPage(),
              Center(
                child: Container(
                  width: 300,
                  height: 650,
                  decoration: BoxDecoration(
                    color: context.theme.appColors.background.withOpacity(0.5),
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
                        ),
                      ),
                      const SizedBox(height: 85),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.appColors.secondary,
                                width: 1.0),
                          ),
                          labelText: 'Username',
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: context.theme.appColors.onSecondary),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.appColors.secondary),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.appColors.secondary,
                                width: 1.0 * 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.appColors.secondary,
                                width: 1.0),
                          ),
                          labelText: 'Password',
                          labelStyle: TextStyle(
                              fontSize: 20,
                              color: context.theme.appColors.onSecondary),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.appColors.secondary),
                            borderRadius: BorderRadius.circular(45.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: context.theme.appColors.secondary,
                                width: 1.0 * 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        decoration: BoxDecoration(
                          color: context.theme.appColors.primary,
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
                        child: Builder(builder: (context) {
                          return TextButton(
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                const Size(100, 50),
                              ),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  context.theme.appColors.onPrimary),
                              overlayColor:
                                  MaterialStateProperty.resolveWith<Color?>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.hovered)) {
                                    return context.theme.appColors.onPrimary
                                        .withOpacity(0.04);
                                  }
                                  if (states.contains(MaterialState.focused) ||
                                      states.contains(MaterialState.pressed)) {
                                    return context.theme.appColors.onPrimary
                                        .withOpacity(0.12);
                                  }
                                  return null;
                                },
                              ),
                            ),
                            onPressed: () async {
                              try {
                                final message =
                                    await signInWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                if (message != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Profile()),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Login failed. Please check your email and password.'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                }
                              } catch (e) {
                                // Handle any errors that occur during sign-in
                                print("Error signing in: $e");
                              }
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

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
            image: AssetImage('lib/assets/img/home_background.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
