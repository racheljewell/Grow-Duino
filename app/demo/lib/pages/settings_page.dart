import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late LightSettings _lightSettings;
  late HumiditySettings _humiditySettings;
  late TemperatureSettings _temperatureSettings;
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    _lightSettings = LightSettings('', '');
    _humiditySettings = HumiditySettings('', '');
    _temperatureSettings = TemperatureSettings('', '');
    _initializeSettings();
    super.initState();
  }

  Future<void> _initializeSettings() async {
    try {
      Map<String, dynamic> responseData = await pullSettings();
      _saveData(responseData);
      await _loadData(); // Load saved data
    } catch (e) {
      print('Error: $e');
    } finally {
      // Set loading state to false after settings are fetched
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? jsonData = prefs.getString('settingsData');
    if (jsonData != null) {
      Map<String, dynamic> settingsData = jsonDecode(jsonData);
      setState(() {
        _humiditySettings = HumiditySettings(
            settingsData['minHumidity'] ?? '',
            settingsData['maxHumidity'] ?? ''
        );
        _temperatureSettings = TemperatureSettings(
            settingsData['minTemperature'] ?? '',
            settingsData['maxTemperature'] ?? ''
        );
        _lightSettings = LightSettings(
            settingsData['lightsOn'] ?? '',
            settingsData['lightsOff'] ?? '',
        );
      });
    }
  }

  Future<Map<String, dynamic>> pullSettings() async {
    final response = await http.post(
      Uri.parse('https://getsettings-7frthucguq-uc.a.run.app'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load settings');
    }
  }

  Widget _buildSettingsCard(String title, String min, String max) {
    return Card(
      color: const Color.fromARGB(255, 217, 217, 217),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 1, 63, 39),
                  fontSize: 28.0,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildSlider(title, min, max), // Pass title to identify slider
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title == 'Lighting' ? "On: ${min}" : "Minimum: $min",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 1, 63, 39),
                    fontSize: 14.0,
                  ),
                ),
                Text(
                  title == 'Lighting' ? "Off: ${max}" : "Maximum: $max",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 1, 63, 39),
                    fontSize: 14.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String title, String min, String max) {
    double minValue;
    double maxValue;
    int divisions;

    if (title == 'Humidity') {
      minValue = double.tryParse(_humiditySettings.min) ?? 0;
      maxValue = double.tryParse(_humiditySettings.max) ?? 100;
      divisions = 100;
    } else if (title == 'Temperature') {
      minValue = double.tryParse(_temperatureSettings.min) ?? 0;
      maxValue = double.tryParse(_temperatureSettings.max) ?? 100;
      divisions = 100;
    } else {
      minValue = timeToMinutes(_lightSettings.on).toDouble();
      maxValue = timeToMinutes(_lightSettings.off).toDouble();
      divisions = 144;
    }

    return RangeSlider(
      values: RangeValues(minValue, maxValue),
      min: title != 'Lighting' ? 0.0 : 0.0, // Minimum value for temperature slider
      max: title != 'Lighting' ? 100.0 : 1440.0, // Maximum value for time slider (24 hours in minutes)
      divisions: divisions,
      activeColor: const Color.fromARGB(255, 1, 63, 39),
      labels: RangeLabels(
        title == 'Temperature' ? min : (title == 'Humidity' ? min : minutesToTime(minValue.toInt())),
        title == 'Temperature' ? max : (title == 'Humidity' ? max : minutesToTime(maxValue.toInt())),
      ),
      onChanged: (value) {
        setState(() {
          if (title == 'Humidity') {
            _humiditySettings.min = value.start.round().toString();
            _humiditySettings.max = value.end.round().toString();
          } else if (title == 'Temperature') {
            _temperatureSettings.min = value.start.round().toString();
            _temperatureSettings.max = value.end.round().toString();
          } else {
            _lightSettings.on = minutesToTime(value.start.round());
            _lightSettings.off = minutesToTime(value.end.round());
          }
        });
      },
    );
  }

  // Convert "hh:mm:ss" string to minutes
  int timeToMinutes(String time) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    return hours * 60 + minutes;
  }

  // Convert minutes to "hh:mm" string
  String minutesToTime(int minutes) {
    int hours = (minutes ~/ 60) % 24;
    int remainingMinutes = minutes % 60;
    return '$hours:${remainingMinutes.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromARGB(255, 180, 228, 196)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Settings", style: TextStyle(color: Color.fromARGB(255, 255, 251, 251))),
          backgroundColor: const Color.fromARGB(255, 1, 63, 39),
          leading: BackButton(
            color: const Color.fromARGB(255, 255, 251, 251),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Drawer Header'),
              ),
              ListTile(
                title: const Text("Home"),
                onTap: () {
                  // Navigate to profile page
                },
              ),
              ListTile(
                title: const Text('Item 2'),
                onTap: () {
                  // Handle item 2 tap
                },
              ),
            ],
          ),
        ),
        body: _isLoading ? const Center(child: CircularProgressIndicator()) : Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSettingsCard("Lighting", _lightSettings.on, _lightSettings.off),
              _buildSettingsCard('Humidity', _humiditySettings.min, _humiditySettings.max),
              _buildSettingsCard('Temperature', _temperatureSettings.min, _temperatureSettings.max),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              Map<String, dynamic> settingsData = convertSettingsToJson(_lightSettings, _humiditySettings, _temperatureSettings);
              final success = await pushSettings(settingsData);
              if (success) {
                print("Success");
                _showConfirmationMessage(); // Show confirmation message
              }
            } catch (e) {
              print('Error: $e');
            }
          },
          backgroundColor: const Color.fromARGB(255, 1, 63, 39),
          child: const Icon(
            Icons.save,
            color: Color.fromARGB(255, 255, 251, 251),
          ),
        ),
      ),
    );
  }

  void _saveData(Map<String, dynamic> responseData) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> settingsData = responseData['settings'];
    String jsonData = jsonEncode(settingsData);
    await prefs.setString('settingsData', jsonData);
    setState(() {
      _humiditySettings = HumiditySettings(
          settingsData['minHumidity'].toString(),
          settingsData['maxHumidity'].toString()
      );
      _temperatureSettings = TemperatureSettings(
          settingsData['minTemperature'].toString(),
          settingsData['maxTemperature'].toString()
      );
      List<String> onT = settingsData['lightsOn'].split(':');
      List<String> offT = settingsData['lightsOff'].split(':');
      String onTime = "${onT[0]}:${onT[1]}";
      String offTime = "${offT[0]}:${offT[1]}";

      _lightSettings = LightSettings(
        onTime,
        offTime,
      );
    });
  }

  void _showConfirmationMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully', style: TextStyle(color: Colors.black),),
        duration: Duration(seconds: 2), // Set the duration for the snackbar
        behavior: SnackBarBehavior.floating, // Set behavior to floating
        padding: EdgeInsets.only(bottom: 16, right: 16), // Adjust padding to position it at the bottom right
      ),
    );
  }
}

Future<bool> pushSettings(Map<String, dynamic> settingsData) async {
  final url = Uri.parse('https://savesettings-7frthucguq-uc.a.run.app');
  final headers = <String, String>{
    'Content-Type': 'application/json; charset=UTF-8',
  };
  final body = jsonEncode(settingsData);

  final response = await http.post(url, headers: headers, body: body);

  if (response.statusCode == 200) {
    print("Save Success");
    return true; // Indicate success
  } else {
    print(response.body);
    return false; // Indicate failure
  }
}

class LightSettings {
  String on;
  String off;

  LightSettings(this.on, this.off);
}

class HumiditySettings {
  String min;
  String max;

  HumiditySettings(this.min, this.max);
}

class TemperatureSettings {
  String min;
  String max;

  TemperatureSettings(this.min, this.max);
}

Map<String, dynamic> convertSettingsToJson(LightSettings lightSettings, HumiditySettings humiditySettings, TemperatureSettings temperatureSettings) {
  return {
    'lightsOn': "${lightSettings.on}:00",
    'lightsOff': "${lightSettings.off}:00",
    'minHumidity': int.parse(humiditySettings.min),
    'maxHumidity': int.parse(humiditySettings.max),
    'minTemperature': int.parse(temperatureSettings.min),
    'maxTemperature': int.parse(temperatureSettings.max),
  };
}
