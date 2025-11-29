import 'package:flutter/material.dart';
import 'package:stockmark/core/errors/error_handler.dart';
import 'package:stockmark/core/errors/failures.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/domain/repositories/news_repository.dart';

class NewProvider extends ChangeNotifier {
  final NewsRepository repository;

  NewProvider({required this.repository});

  // ===== STATE =====
  List<NewsEntity> _news = [];
  List<NewsEntity> _hotNews = [];
  bool _isLoading = false;
  bool _isHotNewsLoading = false;
  Failure? _failure;

  // ===== GETTERS =====
  List<NewsEntity> get news => _news;
  List<NewsEntity> get hotNews => _hotNews;
  bool get isLoading => _isLoading;
  bool get isHotNewsLoading => _isHotNewsLoading;
  bool get hasError => _failure != null;
  bool get hasData => _news.isNotEmpty || _hotNews.isNotEmpty;  // ✅ เพิ่ม
  Failure? get failure => _failure;  // ✅ เพิ่ม expose failure

  String get errorMessage =>
      _failure != null ? ErrorHandler.getErrorMessage(_failure!) : '';

  // ===== ACTIONS =====

  /// ✅ Clear error state
  void clearError() {
    _failure = null;
    notifyListeners();
  }

  Future<void> loadNews() async {
    _isLoading = true;
    _failure = null;  // ✅ Reset error ก่อน load
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
    _failure = null;  // ✅ Reset error ก่อน load
    notifyListeners();

    try {
      _hotNews = await repository. getHotNews();
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
    _failure = null;  // ✅ Reset error ก่อน load
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getNews(),
        repository.getHotNews(),
      ]);

      _news = results[0];
      _hotNews = results[1];
    } catch (e) {
      _failure = ErrorHandler.handleException(e);
      _news = [];
      _hotNews = [];
    } finally {
      _isLoading = false;
      _isHotNewsLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Refresh data
  Future<void> refresh() async {
    clearError();
    await loadAllNews();
  }
}