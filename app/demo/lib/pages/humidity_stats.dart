class HumidityData {
  final double humidity;
  final DateTime time;

  HumidityData({required this.humidity, required this.time});
}

class HumidityStatistics {
  late double maxHumidity;
  late double minHumidity;
  late double averageHumidity;

  void calculateStatistics(List<Map<String, dynamic>> dataList) {
    if (dataList.isEmpty) {
      maxHumidity = 0;
      minHumidity = 0;
      averageHumidity = 0;
      return;
    }

    maxHumidity = dataList.map<double>((data) => data['data']['humidity'].toDouble()).reduce((value, element) => value > element ? value : element);
    minHumidity = dataList.map<double>((data) => data['data']['humidity'].toDouble()).reduce((value, element) => value < element ? value : element);

    final sum = dataList.map<double>((data) => data['data']['humidity'].toDouble()).reduce((value, element) => value + element);
    averageHumidity = sum / dataList.length;
  }
}