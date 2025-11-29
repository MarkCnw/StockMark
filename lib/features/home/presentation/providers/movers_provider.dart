import 'package:flutter/material.dart';
import 'package:stockmark/core/errors/error_handler.dart';
import 'package:stockmark/core/errors/failures.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class MoversProvider extends ChangeNotifier {
  final MoversRepository repository;

  // ===== STATE =====
  List<StockEntity> _gainers = [];
  List<StockEntity> _losers = [];
  List<StockEntity> _trending = [];
  bool _isLoading = false;
  Failure? _failure; // ✅ เปลี่ยนจาก String? errorMessage

  // ===== GETTERS =====
  List<StockEntity> get gainer => _gainers;
  List<StockEntity> get losers => _losers;
  List<StockEntity> get trending => _trending;
  bool get isLoading => _isLoading;
  String get errorMessage =>
      _failure != null ? ErrorHandler.getErrorMessage(_failure!) : '';

  MoversProvider({
    required this.repository,
  }); // ✅ Constructor ต้องรับแบบ named parameter

  Future<void> loadMovers() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();
    try {
      // โหลด 3 อย่างพร้อมกัน
      final results = await Future.wait([
        repository.getTopGainers(),
        repository.getTopLosers(),
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
    }
    _isLoading = false;
    notifyListeners();
  }
}
