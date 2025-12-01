import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudinary_public/cloudinary_public.dart'; 
import '../models/post_model.dart';

class PostRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // --- CẤU HÌNH CLOUDINARY CHÍNH XÁC TỪ HÌNH ẢNH CỦA BẠN ---
  // Cloud Name: drwmzcaqo
  // Upload Preset: unsigned_preset
  final cloudinary = CloudinaryPublic('drwmzcaqo', 'unsigned_preset', cache: false);

  // 1. Lấy danh sách ảnh từ Firestore
  Stream<List<Post>> getPostsStream() {
    return _firestore
        .collection('posts')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return Post.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  // 2. Upload ảnh lên Cloudinary và lưu thông tin vào Firestore
  Future<void> addPost(File imageFile, String userId, String description) async {
    try {
      // BƯỚC 1: Upload ảnh lên Cloudinary
      CloudinaryResponse response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(imageFile.path, resourceType: CloudinaryResourceType.Image),
      );

      // Lấy đường dẫn ảnh trên mạng về
      String downloadUrl = response.secureUrl; 

      // BƯỚC 2: Tạo đối tượng bài viết
      Post newPost = Post(
        id: '', 
        userId: userId,
        imageUrl: downloadUrl, // Lưu link ảnh của Cloudinary
        description: description,
        timestamp: DateTime.now(),
      );

      // BƯỚC 3: Lưu vào Firestore
      await _firestore.collection('posts').add(newPost.toMap());
      
    } catch (e) {
      print("Lỗi khi đăng bài: $e");
      throw Exception('Không thể đăng bài: $e');
    }
  }
}