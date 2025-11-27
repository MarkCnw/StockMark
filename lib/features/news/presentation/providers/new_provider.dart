import 'package:flutter/material.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/domain/repositories/news_repository.dart';

class NewProvider extends ChangeNotifier {
  final NewsRepository repository;

  NewProvider(this.repository);

  // ===== STATE =====
  List<NewsEntity> _news = [];
  List<NewsEntity> _hotNews = [];
  bool _isLoading = false;
  bool _isHotNewsLoading = false;
  String? _errorMessage;

  // ===== GETTERS =====
  List<NewsEntity> get news => _news;
  List<NewsEntity> get hotNews => _hotNews;
  bool get isLoading => _isLoading;
  bool get isHotNewsLoading => _isHotNewsLoading;
  String? get errorMessage => _errorMessage;

  // ✅ เพิ่ม getter นี้
  bool get isEmpty => _news.isEmpty && _hotNews.isEmpty;

  // ✅ เพิ่ม getter สำหรับ error (optional)
  bool get hasError => _errorMessage != null;

  // ===== ACTIONS =====

  Future<void> loadNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _news = await repository.getNews();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _news = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHotNews() async {
    _isHotNewsLoading = true;
    notifyListeners();

    try {
      _hotNews = await repository.getHotNews();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _hotNews = [];
    } finally {
      _isHotNewsLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadAllNews() async {
    _isLoading = true;
    _isHotNewsLoading = true;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getNews(),
        repository.getHotNews(),
      ]);

      _news = results[0];
      _hotNews = results[1];
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _news = [];
      _hotNews = [];
    } finally {
      _isLoading = false;
      _isHotNewsLoading = false;
      notifyListeners();
    }
  }
}
