import 'package:demo/pages/settings_page.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: Center(
        child: Builder(
          builder: (context) {
            return TextButton(
              style: TextButton.styleFrom(
                foregroundColor: const Color.fromARGB(255, 255, 251, 251), minimumSize: const Size(100, 50),
                backgroundColor: const Color.fromARGB(255, 1, 63, 39),
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                textStyle: const TextStyle(fontSize: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: const BorderSide(color: Colors.white),
                ),
              ),
              onPressed: () async {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
              },
              child: const Text('Sign In'),
            );
          },
        ),
      ),
    );
  }
}
