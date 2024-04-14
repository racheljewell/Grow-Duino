import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo/components/theme/app_theme.dart';
import 'humidity_display.dart';
import 'settings_page.dart';
import 'temperature_display.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        home: const ProfileScreen(),
      ),
    );
  }
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late Timer timer;
  late Map<String, dynamic> recentData;
  late double humidityValue;
  late double temperatureValue;
  late double lightsValue;

  @override
  void initState() {
    super.initState();
    recentData = {};
    humidityValue = 0;
    temperatureValue = 0;
    lightsValue = 0;
    fetchRecentData();

    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) => fetchRecentData());
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Future<void> fetchRecentData() async {
    try {
      final response = await http.post(
        Uri.parse('https://getrecentdata-7frthucguq-uc.a.run.app'),
      );
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          recentData = jsonData['data'];
          humidityValue = (recentData['humidity'] ?? 0).toDouble();
          temperatureValue = (recentData['temperature'] ?? 0).toDouble();
          lightsValue = (recentData['lights'] ?? 0).toDouble();
        });
      } else {
        
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch data');
    }
  }

  Widget _buildNumberDisplayBox(
    String imagePath,
    String title,
    String number,
    VoidCallback onPressed,
  ) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.appColors.primary,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 1.5,
              blurRadius: 10,
              offset: const Offset(0, 3),
              blurStyle: BlurStyle.inner,
            ),
          ],
        ),
        width: 350,
        height: 68,
        margin: const EdgeInsets.all(5.0),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(imagePath),
              Text(
                title,
                style: TextStyle(
                  color: context.theme.appColors.onPrimary,
                  fontSize: 24,
                ),
              ),
              Text(
                number,
                style:  TextStyle(
                  color: context.theme.appColors.onPrimary,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void updateThemeMode(ThemeMode themeMode) {
    // 5. Update ThemeMode.
    context.read<AppTheme>().themeMode = themeMode;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AppTheme(),
      builder: (context, _) => MaterialApp(
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
        themeMode: context.watch<AppTheme>().themeMode,

        home: Scaffold(
          appBar: AppBar(
            title: const Text("Profile"),
            backgroundColor: context.theme.appColors.primary,
            foregroundColor: context.theme.appColors.onPrimary,
          ),
          drawer: Drawer(
            backgroundColor: context.theme.appColors.background,
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    color: context.theme.appColors.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        spreadRadius: 1.5,
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                        blurStyle: BlurStyle.inner
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text('GrowDuino',
                      style: TextStyle(
                        color: context.theme.appColors.onPrimary,
                        fontSize: 32.0,
                      ),
                      ),
                      Image.asset('lib/assets/logo/plantLogo.png'),
                    ],
                  ),
                ),
                ListTile(
                  title: Text(
                    "Settings",
                    style: TextStyle(
                      color: context.theme.appColors.onSecondary,
                    ),
                    ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage()));
                  },
                ),
                ListTile(
                  title: Text(
                    "Temperature Stats",
                    style: TextStyle(
                      color: context.theme.appColors.onSecondary,
                    ),
                    ),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const TemperatureDisplay()));
                  },
                ),
                ListTile(
                  title: Text(
                    "Humidity Stats",
                    style: TextStyle(
                      color: context.theme.appColors.onSecondary,
                    ),
                    ),
                  onTap: () {
                    
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const HumidityDisplay()));

                  },
                ),
              ],
            ),
          ),
          body: Expanded(
            child: Scaffold(
              backgroundColor: context.theme.appColors.background,
              body: ListView(
                children: [
                  Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      _buildNumberDisplayBox(
                        "lib/assets/logo/thermometer.png",
                        "Temperature",
                        temperatureValue.toString(),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TemperatureDisplay(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      _buildNumberDisplayBox(
                        "lib/assets/logo/humidity.png",
                        "Humidity",
                        humidityValue.toString(),
                        () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HumidityDisplay(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 70),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: context.theme.appColors.primary,
                            width: 2,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: const Image(
                            image: AssetImage('lib/assets/img/plant.png'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}
