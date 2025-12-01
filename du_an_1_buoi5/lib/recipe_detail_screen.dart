// lib/recipe_detail_screen.dart
import 'package:flutter/material.dart';
import 'recipe.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;

  // Nhận đối tượng công thức qua constructor
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    // Scaffold với AppBar có nút "Quay lại" (Flutter tự động thêm)
    return Scaffold(
      appBar: AppBar(
        title: Text(recipe.title),
      ),
      body: SingleChildScrollView( // Cho phép cuộn nếu nội dung dài
        child: Column(
          children: [
            // 1. Hình ảnh lớn
            SizedBox(
              height: 250,
              width: double.infinity,
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stack) => const Center(child: Text('Không tải được ảnh')),
              ),
            ),
            const SizedBox(height: 10),

            // 2. Tiêu đề
            Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            // 3. Danh sách nguyên liệu
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: const Text(
                'Nguyên liệu:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            // Dùng Column và map để hiển thị list nguyên liệu
            Column(
              children: recipe.ingredients.map((ingredient) {
                return Card(
                  color: Colors.orange[50],
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 8, color: Colors.orange),
                        const SizedBox(width: 10),
                        Text(ingredient, style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),

            // 4. Các bước thực hiện
            Container(
              padding: const EdgeInsets.all(10),
              width: double.infinity,
              child: const Text(
                'Các bước thực hiện:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
              ),
            ),
            // Hiển thị các bước
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: recipe.steps.asMap().entries.map((entry) {
                  int index = entry.key;
                  String step = entry.value;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text('#${index + 1}', style: const TextStyle(color: Colors.white)),
                    ),
                    title: Text(step),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}