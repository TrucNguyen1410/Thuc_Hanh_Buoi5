import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../data/auth_repository.dart';
import '../data/post_repository.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  File? _imageFile;
  final _descController = TextEditingController();
  final _picker = ImagePicker();
  bool _isUploading = false;

  // Sửa hàm này để nhận nguồn ảnh (Camera hoặc Gallery)
  Future<void> _pickImage(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      print("Lỗi chọn ảnh: $e");
    }
  }

  // Hàm hiển thị Menu lựa chọn
  void _showPickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Chọn từ Thư viện'),
                  onTap: () {
                    _pickImage(ImageSource.gallery);
                    Navigator.of(context).pop(); // Đóng menu
                  }),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Chụp ảnh mới'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.of(context).pop(); // Đóng menu
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _upload() async {
    if (_imageFile == null) return;
    setState(() => _isUploading = true);

    try {
      final userId = AuthRepository().getCurrentUserId();
      if (userId != null) {
        await PostRepository().addPost(_imageFile!, userId, _descController.text);
        
        if (!mounted) return;
        Navigator.pop(context); // Quay về màn hình chính
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng Ảnh Mới')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView( // Thêm cái này để không bị lỗi tràn màn hình khi bàn phím hiện lên
          child: Column(
            children: [
              GestureDetector(
                onTap: () => _showPickerOptions(context), // Gọi menu lựa chọn
                child: Container(
                  height: 250, // Tăng chiều cao lên chút cho đẹp
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey)
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.add_a_photo, size: 50, color: Colors.grey),
                            SizedBox(height: 10),
                            Text("Bấm để chọn ảnh hoặc chụp mới", style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _descController,
                decoration: const InputDecoration(
                  labelText: 'Viết mô tả cho bức ảnh...',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.description),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: _isUploading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _upload,
                        icon: const Icon(Icons.cloud_upload),
                        label: const Text('ĐĂNG BÀI NGAY', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.pink,
                          foregroundColor: Colors.white,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}