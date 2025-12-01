// lib/weather_model.dart

class Weather {
  final String cityName;
  final double temperature;
  final String description;
  final String iconCode;
  final int humidity;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.description,
    required this.iconCode,
    required this.humidity,
  });

  // Hàm chuyển đổi JSON từ API thành đối tượng Weather
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'] ?? '',
      // Nhiệt độ trả về độ K hoặc C tùy setting, convert sang double cho chắc
      temperature: (json['main']['temp'] as num).toDouble(),
      // Lấy mô tả từ phần tử đầu tiên của mảng weather
      description: json['weather'][0]['description'] ?? '',
      iconCode: json['weather'][0]['icon'] ?? '01d',
      humidity: json['main']['humidity'] ?? 0,
    );
  }
}