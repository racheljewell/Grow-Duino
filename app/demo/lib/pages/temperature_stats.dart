class TemperatureData {
  final double temperature;
  final DateTime time;

  TemperatureData({required this.temperature, required this.time});
}

class TemperatureStatistics {
  late double maxTemperature;
  late double minTemperature;
  late double averageTemperature;

  void calculateStatistics(List<Map<String, dynamic>> dataList) {
    if (dataList.isEmpty) {
      maxTemperature = 0;
      minTemperature = 0;
      averageTemperature = 0;
      return;
    }

    maxTemperature = dataList.map<double>((data) => data['data']['temperature'].toDouble()).reduce((value, element) => value > element ? value : element);
    minTemperature = dataList.map<double>((data) => data['data']['temperature'].toDouble()).reduce((value, element) => value < element ? value : element);

    final sum = dataList.map<double>((data) => data['data']['temperature'].toDouble()).reduce((value, element) => value + element);
    averageTemperature = sum / dataList.length;
    averageTemperature = double.parse(averageTemperature.toStringAsFixed(1));
  }
}
