class Post {
  final String id;
  final String userId;
  final String imageUrl;
  final String description;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.userId,
    required this.imageUrl,
    required this.description,
    required this.timestamp,
  });

  // Chuyển từ Map (Firestore) sang Object
  factory Post.fromMap(Map<String, dynamic> map, String id) {
    return Post(
      id: id,
      userId: map['userId'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      description: map['description'] ?? '',
      timestamp: (map['timestamp'] as dynamic).toDate(),
    );
  }

  // Chuyển từ Object sang Map để lưu lên Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'imageUrl': imageUrl,
      'description': description,
      'timestamp': timestamp,
    };
  }
}