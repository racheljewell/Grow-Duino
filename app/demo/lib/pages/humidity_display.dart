import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:demo/pages/humidity_stats.dart';

class HumidityDisplay extends StatefulWidget {
  const HumidityDisplay({Key? key}) : super(key: key);

  @override
  _HumidityDisplayState createState() => _HumidityDisplayState();
}

class _HumidityDisplayState extends State<HumidityDisplay> {
  List<Map<String, dynamic>> dataList = [];
  late Timer timer;
  late HumidityStatistics stats; // Variable to store statistics

  @override
  void initState() {
    super.initState();
    stats = HumidityStatistics(); // Initialize stats variable
    // Fetch data immediately when the widget initializes
    fetchDataFromFirestore();

    // Fetch data every 30 seconds
    timer = Timer.periodic(const Duration(seconds: 30), (Timer t) => fetchDataFromFirestore());
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed to avoid memory leaks
    timer.cancel();
    super.dispose();
  }

  Future<void> fetchDataFromFirestore() async {
    final url = Uri.parse('http://10.0.2.2:5001/grow-duino/us-central1/getData');

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        setState(() {
          dataList = jsonData['list'].cast<Map<String, dynamic>>();
          print(dataList);
          calculateStatistics(); // Calculate statistics when data is fetched
        });
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to fetch data');
    }
  }

  void calculateStatistics() {
    stats.calculateStatistics(dataList);
  }

  Widget _buildNumberDisplayBox(String number) {
    return Container(
      child: Container(
        decoration: BoxDecoration( 
          color: const Color.fromARGB(255, 135, 174, 143),
          borderRadius: BorderRadius.circular(20.0),
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
          width: 80, // Width of each rectangle
          height: 40, // Height of each rectangle
          margin: const EdgeInsets.all(5.0),
        child: Center(
          child: Text(
              number,
              style: const TextStyle(
                color: Color.fromARGB(255, 51, 51, 51),
                fontSize: 20,
              ),
            ),
        ), 
        )
    );
  }

  Widget _buildHotdogBox(String title, String number) {
    return Center(
      child: Container(
        width: 350, // Width of each rectangle
        height: 68, // Height of each rectangle
        margin: const EdgeInsets.all(5.0), // Margin between rectangles
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 217, 217, 217), // Color of the rectangles
          borderRadius: BorderRadius.circular(20), // Border radius to make rectangles "hotdog" shaped
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color.fromARGB(255, 51, 51, 51),
                  fontSize: 28.0,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 25),
                  child: _buildNumberDisplayBox(number),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildSquareBox() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 63, 39),
          borderRadius: BorderRadius.circular(20.0),
        ),
        width: 375, // Total width of the container
        height: 275, // Height of each rectangle
        margin: const EdgeInsets.only(top: 18.0), // Margin between rectangles
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildHotdogBox("High", stats.maxHumidity.toString()),
            _buildHotdogBox("Low", stats.minHumidity.toString()),
            _buildHotdogBox("Average", stats.averageHumidity.toString()),
          ],
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: const Color.fromARGB(255, 180, 228, 196)),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Humidity", style: TextStyle(color: Color.fromARGB(255, 255, 251, 251))),
          backgroundColor: const Color.fromARGB(255, 1, 63, 39),
        ),
        backgroundColor: const Color.fromARGB(255, 180, 228, 196),
        body: dataList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                    child: LineChart1(humidityValues: dataList.map<double>((data) => data['data']['humidity'].toDouble()).toList()),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(0.5),
                    child: Center(
                      child:_buildSquareBox(),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class LineChart1 extends StatelessWidget {
  final List<double> humidityValues;

  const LineChart1({required this.humidityValues});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Stack(
        children: <Widget>[
          Column(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), // Border color
                    borderRadius: BorderRadius.circular(10), // Border radius
                  ),
                  child: _LineChart(isShowingMainData: true, humidityValues: humidityValues),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({required this.isShowingMainData, required this.humidityValues});

  final bool isShowingMainData;
  final List<double> humidityValues;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.0,
      child: Container(
        padding: const EdgeInsets.all(24.0), // Add padding around the chart
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey), // Border color
          borderRadius: BorderRadius.circular(10), // Border radius
          color: const Color.fromARGB(255, 255, 251, 251)
        ),
        child: LineChart(
          isShowingMainData ? sampleData1(humidityValues) : sampleData2(humidityValues),
          duration: const Duration(milliseconds: 250),
        ),
      ),
    );
  }

  LineChartData sampleData1(List<double> humidityValues) {
    final spots = List.generate(humidityValues.length, (index) {
      return FlSpot(index.toDouble(), humidityValues[index].toDouble());
    });

    return LineChartData(
      lineTouchData: lineTouchData1,
      gridData: gridData,
      titlesData: titlesData1,
      borderData: borderData,
      lineBarsData: [
        LineChartBarData(
          isCurved: true,
          color: const Color.fromARGB(255, 1, 63, 39),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(show: false),
          spots: spots,
        ),
      ],
      minX: 0,
      maxX: humidityValues.length.toDouble() - 1,
      maxY: 100, // Max value for y-axis
      minY: 40, // Min value for y-axis
    );
  }

  LineChartData sampleData2(List<double> humidityValues) {
    // Sample data 2 if needed
    return sampleData1(humidityValues); // Returning the same data for now
  }

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) => Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          axisNameWidget: const Text(
            'Time'
          ),
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          axisNameWidget: const Text(
            'Humidity (%)'
          ),
          sideTitles: leftTitles(),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.green, width: 1),
          left: BorderSide(color: Colors.green, width: 1),
          right: BorderSide(color: Colors.transparent),
          top: BorderSide(color: Colors.transparent),
        ),
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    final time = DateTime.now().add(Duration(minutes: value.toInt())); // Assuming value represents minutes
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return Text('$hour:$minute', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16));
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 40:
        text = '40';
        break;
      case 60:
        text = '60';
        break;
      case 80:
        text = '80';
        break;
      case 100:
        text = '100';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 20, // Adjust interval to match your desired range
        reservedSize: 20,
      );
}


