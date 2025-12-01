// lib/recipe.dart
import 'package:flutter/material.dart';

// 1. Định nghĩa class Recipe như yêu cầu
class Recipe {
  final String id;
  final String title;       // Tên món
  final String description; // Mô tả ngắn
  final String imageUrl;    // Link ảnh
  final List<String> ingredients; // Danh sách nguyên liệu
  final List<String> steps;       // Các bước thực hiện

  Recipe({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.ingredients,
    required this.steps,
  });
}

// 2. Tạo danh sách tĩnh (List<Recipe>) để sử dụng trong ứng dụng
final List<Recipe> defaultRecipes = [
  Recipe(
    id: 'r1',
    title: 'Phở Bò',
    description: 'Món ăn truyền thống nổi tiếng của Việt Nam.',
    imageUrl: 'https://cdn2.fptshop.com.vn/unsafe/1920x0/filters:format(webp):quality(75)/cach_nau_pho_bo_nam_dinh_0_1d94be153c.png',
    ingredients: ['Bánh phở', 'Thịt bò', 'Hành tây', 'Gừng', 'Gia vị phở'],
    steps: [
      'Hầm xương bò để lấy nước dùng.',
      'Trần bánh phở qua nước sôi.',
      'Thái thịt bò mỏng và xếp lên bát.',
      'Chan nước dùng nóng và thưởng thức.',
    ],
  ),
  Recipe(
    id: 'r2',
    title: 'Bánh Mì',
    description: 'Bánh mì giòn tan với nhân thịt và pate.',
    imageUrl: 'https://static.vinwonders.com/production/banh-mi-sai-gon-2.jpg',
    ingredients: ['Bánh mì', 'Pate', 'Thịt nguội', 'Dưa leo', 'Rau mùi'],
    steps: [
      'Nướng lại bánh mì cho giòn.',
      'Phết pate và bơ vào ruột bánh.',
      'Xếp thịt, dưa leo và rau vào.',
      'Thêm tương ớt nếu thích cay.',
    ],
  ),
  Recipe(
    id: 'r3',
    title: 'Gỏi Cuốn',
    description: 'Món khai vị thanh mát và tốt cho sức khỏe.',
    imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/03/Summer_roll.jpg/640px-Summer_roll.jpg',
    ingredients: ['Bánh tráng', 'Tôm', 'Thịt ba chỉ', 'Bún tươi', 'Rau sống'],
    steps: [
      'Luộc tôm và thịt chín tới.',
      'Làm ướt bánh tráng.',
      'Xếp rau, bún, tôm, thịt lên bánh tráng.',
      'Cuốn chặt tay và chấm với nước mắm chua ngọt.',
    ],
  ),
];