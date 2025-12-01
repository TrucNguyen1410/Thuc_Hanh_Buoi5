import 'package:flutter_test/flutter_test.dart';
// SỬA DÒNG DƯỚI ĐÂY: Thay photo_social_app bằng du_an_3_buoi5
import 'package:du_an_3_buoi5/models/post_model.dart'; 

void main() {
  group('Post Model Test', () {
    test('Post.toMap() should return correct map', () {
      final date = DateTime.now();
      final post = Post(
        id: '123',
        userId: 'user1',
        imageUrl: 'http://image.com/a.jpg',
        description: 'Test Post',
        timestamp: date,
      );

      final map = post.toMap();

      expect(map['userId'], 'user1');
      expect(map['description'], 'Test Post');
      expect(map['timestamp'], date);
    });
  });
}