import 'package:flutter/material.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/domain/repositories/news_repository.dart';

class NewProvider extends ChangeNotifier {
  final NewsRepository repository;

  List<NewsEntity> news = [];
  bool isLoading = true;

  NewProvider(this.repository);

  Future<void> loadNews() async {
    // 1. ประกาศเริ่มงาน (Start)
    isLoading = true;
    notifyListeners();

    try {
      // 2. วิ่งไปเอาของ (Fetch) และ 3. รับของเข้าคลัง (Assign)
      // ✅ ใช้ await เพื่อรอของจาก repository
      news = await repository.getNews(); 
      
    } catch (e) {
      // (แถม) กันเหนียวเผื่อสะดุดล้ม
      print("Error loading news: $e");
    }

    // 4. ประกาศจบงาน (Finish)
    isLoading = false;
    notifyListeners();
  }
}
