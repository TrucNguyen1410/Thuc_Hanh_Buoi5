// lib/weather_screen.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'weather_model.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();
  
  // Biến Future để quản lý trạng thái cho FutureBuilder
  Future<Weather>? _weatherFuture;

  @override
  void initState() {
    super.initState();
    _loadLastCity(); // Tự động tải thành phố cũ khi mở app
  }

  // 1. Hàm đọc dữ liệu từ SharedPreferences (Lưu trữ dữ liệu)
  Future<void> _loadLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCity = prefs.getString('last_city');
    if (lastCity != null && lastCity.isNotEmpty) {
      _cityController.text = lastCity;
      _searchWeather(lastCity); // Tự động tìm kiếm
    }
  }

  // 2. Hàm lưu thành phố vào SharedPreferences
  Future<void> _saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_city', city);
  }

  // 3. Hàm gọi API (Tích hợp API & Xử lý lỗi try-catch)
  Future<Weather> fetchWeather(String city) async {
    // --- THAY API KEY CỦA BẠN VÀO DƯỚI ĐÂY ---
    const String apiKey = '29af88b57f8b3c3a2e979493ef0f96a8'; 
    // ------------------------------------------
    
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric&lang=vi');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Thành công: Lưu tên thành phố và trả về dữ liệu
        _saveLastCity(city);
        final jsonBody = json.decode(response.body);
        return Weather.fromJson(jsonBody);
      } else {
        // Lỗi từ server (ví dụ: sai tên thành phố)
        throw Exception('Không tìm thấy thành phố này.');
      }
    } catch (e) {
      // Bắt lỗi mạng hoặc lỗi khác
      throw Exception('Lỗi kết nối hoặc tên thành phố không đúng.');
    }
  }

  // Hàm kích hoạt tìm kiếm
  void _searchWeather(String city) {
    if (city.isEmpty) return;
    
    // Cập nhật trạng thái để FutureBuilder chạy lại
    setState(() {
      _weatherFuture = fetchWeather(city);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tin tức Thời tiết'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 4. Input nhập tên thành phố
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'Nhập tên thành phố (VD: Hanoi)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    // Ẩn bàn phím và tìm kiếm
                    FocusScope.of(context).unfocus();
                    _searchWeather(_cityController.text);
                  },
                ),
              ),
              onSubmitted: (value) => _searchWeather(value),
            ),
            const SizedBox(height: 10),
            
            // Nút bấm tìm kiếm (ElevatedButton)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  _searchWeather(_cityController.text);
                },
                child: const Text('Xem Thời Tiết'),
              ),
            ),
            const SizedBox(height: 30),

            // 5. FutureBuilder xử lý các trạng thái (Loading, Error, Success)
            Expanded(
              child: _weatherFuture == null
                  ? const Center(child: Text('Hãy nhập tên thành phố để xem thời tiết.'))
                  : FutureBuilder<Weather>(
                      future: _weatherFuture,
                      builder: (context, snapshot) {
                        // Trạng thái đang tải (Loading)
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        // Trạng thái lỗi (Error)
                        else if (snapshot.hasError) {
                          // Hiển thị SnackBar báo lỗi như yêu cầu
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(snapshot.error.toString().replaceAll('Exception: ', '')),
                                backgroundColor: Colors.red,
                              ),
                            );
                          });
                          
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error_outline, size: 50, color: Colors.red),
                                const SizedBox(height: 10),
                                Text(
                                  'Có lỗi xảy ra:\n${snapshot.error.toString().replaceAll('Exception: ', '')}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }
                        // Trạng thái thành công (Success)
                        else if (snapshot.hasData) {
                          final weather = snapshot.data!;
                          return _buildWeatherInfo(weather);
                        } else {
                          return const Center(child: Text('Không có dữ liệu'));
                        }
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget hiển thị thông tin thời tiết khi thành công
  Widget _buildWeatherInfo(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          weather.cityName,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        // Load icon từ OpenWeatherMap
        Image.network(
          'https://openweathermap.org/img/wn/${weather.iconCode}@2x.png',
          width: 100,
          height: 100,
          errorBuilder: (_,__,___) => const Icon(Icons.wb_sunny, size: 80),
        ),
        Text(
          '${weather.temperature.toStringAsFixed(1)}°C',
          style: const TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.blue),
        ),
        const SizedBox(height: 10),
        Text(
          weather.description.toUpperCase(), // Mô tả (VD: Mây rải rác)
          style: const TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
        ),
        const SizedBox(height: 20),
        Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    const Icon(Icons.water_drop, color: Colors.blue),
                    const SizedBox(height: 5),
                    Text('${weather.humidity}%'),
                    const Text('Độ ẩm'),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}