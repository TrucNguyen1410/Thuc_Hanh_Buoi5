// lib/recipe_list_screen.dart
import 'package:flutter/material.dart';
import 'recipe.dart';
import 'recipe_item.dart';

class RecipeListScreen extends StatelessWidget {
  const RecipeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Công thức Nấu ăn'),
        backgroundColor: Colors.orange, // Màu sắc cho đẹp mắt
      ),
      // Sử dụng ListView.builder để hiển thị danh sách
      body: ListView.builder(
        itemCount: defaultRecipes.length,
        itemBuilder: (ctx, index) {
          // Trả về Widget riêng cho mỗi mục (RecipeItem)
          return RecipeItem(recipe: defaultRecipes[index]);
        },
      ),
    );
  }
}