import 'package:flutter/material.dart';
import '../data/auth_repository.dart';
import '../data/post_repository.dart';
import '../models/post_model.dart';
import 'upload_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final postRepo = PostRepository();
    final authRepo = AuthRepository();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kho Ảnh Cộng Đồng'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authRepo.signOut(),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_a_photo),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadScreen()));
        },
      ),
      // StreamBuilder lắng nghe thay đổi từ Firestore theo thời gian thực
      body: StreamBuilder<List<Post>>(
        stream: postRepo.getPostsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Chưa có ảnh nào. Hãy đăng ngay!'));
          }

          final posts = snapshot.data!;
          
          // GridView.builder tạo bố cục lưới
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 cột
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.8, // Tỷ lệ khung hình
            ),
            itemCount: posts.length,
            itemBuilder: (context, index) {
              final post = posts[index];
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Image.network(
                        post.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) {
                          if (progress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        post.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}