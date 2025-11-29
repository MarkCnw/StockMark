import 'package:flutter/material.dart';
import 'package:stockmark/core/errors/error_handler.dart';
import 'package:stockmark/core/errors/failures.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class MoversProvider extends ChangeNotifier {
  final MoversRepository repository;

  MoversProvider({required this.repository});

  // ===== STATE =====
  List<StockEntity> _gainers = [];
  List<StockEntity> _losers = [];
  List<StockEntity> _trending = [];
  bool _isLoading = false;
  Failure? _failure;

  // ===== GETTERS =====
  List<StockEntity> get gainers => _gainers;
  List<StockEntity> get losers => _losers;
  List<StockEntity> get trending => _trending;
  bool get isLoading => _isLoading;
  Failure? get failure => _failure;
  
  bool get hasError => _failure != null;
  bool get isEmpty => _gainers.isEmpty && _losers.isEmpty && _trending. isEmpty;
  String get errorMessage => 
      _failure != null ? ErrorHandler.getErrorMessage(_failure!) : '';

  // ===== ACTIONS =====
  Future<void> loadMovers() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getTopGainers(),
        repository. getTopLosers(),
        repository.getTrending(),
      ]);

      _gainers = results[0];
      _losers = results[1];
      _trending = results[2];
    } catch (e) {
      _failure = ErrorHandler.handleException(e);
      _gainers = [];
      _losers = [];
      _trending = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Retry loading 
  Future<void> retry() async {
    await loadMovers();
  }

  /// Clear error state
  void clearError() {
    _failure = null;
    notifyListeners();
  }
}