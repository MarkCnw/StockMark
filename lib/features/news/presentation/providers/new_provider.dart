import 'package:flutter/material.dart';
import 'package:stockmark/core/errors/error_handler.dart';
import 'package:stockmark/core/errors/failures.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/domain/repositories/news_repository.dart';

class NewProvider extends ChangeNotifier {
  final NewsRepository repository;

  // ✅ แก้ไข Constructor ให้ถูกต้อง
  NewProvider({required this.repository});

  // ===== STATE =====
  List<NewsEntity> _news = [];
  List<NewsEntity> _hotNews = [];
  bool _isLoading = false;
  bool _isHotNewsLoading = false;
  Failure? _failure; // ✅ เปลี่ยนจาก String?  _errorMessage

  // ===== GETTERS =====
  List<NewsEntity> get news => _news;
  List<NewsEntity> get hotNews => _hotNews;
  bool get isLoading => _isLoading;
  bool get isHotNewsLoading => _isHotNewsLoading;
  bool get hasError => _failure != null;

  // ✅ ใช้ ErrorHandler แปลงเป็นข้อความ
  String get errorMessage =>
      _failure != null ? ErrorHandler.getErrorMessage(_failure!) : '';

  // ===== ACTIONS =====

  Future<void> loadNews() async {
    _isLoading = true;
    notifyListeners();

    try {
      _news = await repository.getNews();
    } catch (e) {
      _failure = ErrorHandler.handleException(e);
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
    } catch (e) {
      _failure = ErrorHandler.handleException(e);
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
      // โหลด 2 อย่างพร้อมกันเพื่อความรวดเร็ว
      final results = await Future.wait([
        repository.getNews(),
        repository.getHotNews(),
      ]);

      _news = results[0];
      _hotNews = results[1];
    } catch (e) {
      _failure = ErrorHandler.handleException(e);
      // ถ้าโหลดไม่ผ่าน ให้เคลียร์ข้อมูลเก่า (หรือจะเก็บไว้ก็ได้)
      _news = [];
      _hotNews = [];
    } finally {
      _isLoading = false;
      _isHotNewsLoading = false;
      notifyListeners();
    }
  }
}
