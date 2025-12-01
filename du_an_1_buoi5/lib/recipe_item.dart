// lib/recipe_item.dart
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_detail_screen.dart';

class RecipeItem extends StatelessWidget {
  final Recipe recipe;

  // Nhận dữ liệu công thức qua constructor
  const RecipeItem({super.key, required this.recipe});

  // Hàm xử lý khi ấn vào món ăn -> Chuyển màn hình
  void selectRecipe(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecipeDetailScreen(recipe: recipe),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4, // Độ bóng của thẻ
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () => selectRecipe(context), // Xử lý sự kiện onTop
        borderRadius: BorderRadius.circular(15),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Hình ảnh nhỏ (dùng ClipRRect để bo tròn ảnh)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  recipe.imageUrl,
                  height: 80,
                  width: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (ctx, error, stack) => const Icon(Icons.fastfood),
                ),
              ),
              const SizedBox(width: 15),
              // Thông tin tên và mô tả
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipe.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      recipe.description,
                      style: const TextStyle(color: Colors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}