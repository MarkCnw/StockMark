import 'package:flutter/material.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/domain/repositories/news_repository.dart';

class NewProvider extends ChangeNotifier {
  final NewsRepository repository;

  List<NewsEntity> news = [];
  List<NewsEntity> hotNews = []; // 🔥 เพิ่ม Hot News
  bool isLoading = true;
  bool isHotNewsLoading = true; // 🔥 Loading state สำหรับ Hot News

  NewProvider(this.repository);

  Future<void> loadNews() async {
    isLoading = true;
    notifyListeners();

    try {
      news = await repository.getNews();
    } catch (e) {
      news = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  // 🔥 โหลด Hot News
  Future<void> loadHotNews() async {
    isHotNewsLoading = true;
    notifyListeners();

    try {
      hotNews = await repository. getHotNews();
    } catch (e) {
      hotNews = [];
    } finally {
      isHotNewsLoading = false;
      notifyListeners();
    }
  }

  // 🔥 โหลดทั้งสองอย่างพร้อมกัน
  Future<void> loadAllNews() async {
    await Future.wait([
      loadNews(),
      loadHotNews(),
    ]);
  }
}