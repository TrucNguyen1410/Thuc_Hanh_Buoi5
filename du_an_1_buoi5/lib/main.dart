// lib/main.dart
import 'package:flutter/material.dart';
import 'recipe_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ứng dụng Nấu ăn',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        // Cấu hình một chút theme cho đẹp
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.orange,
        ),
      ),
      home: const RecipeListScreen(), // Gọi màn hình danh sách đầu tiên
      debugShowCheckedModeBanner: false,
    );
  }
}