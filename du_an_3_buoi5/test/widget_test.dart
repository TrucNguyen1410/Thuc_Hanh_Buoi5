import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// Tạo một widget giả lập để test UI hiển thị bài đăng
class TestPostWidget extends StatelessWidget {
  final String description;
  const TestPostWidget({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Text(description),
    );
  }
}

void main() {
  testWidgets('Test hiển thị mô tả bài đăng', (WidgetTester tester) async {
    // Build widget
    await tester.pumpWidget(const MaterialApp(
      home: Scaffold(
        body: TestPostWidget(description: 'Hello Flutter'),
      ),
    ));

    // Kiểm tra xem chữ "Hello Flutter" có xuất hiện không
    expect(find.text('Hello Flutter'), findsOneWidget);
  });
}