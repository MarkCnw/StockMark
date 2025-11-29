import 'package:flutter/material.dart';
import 'package:stockmark/core/errors/error_handler.dart';
import 'package:stockmark/core/errors/failures.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/usecases/get_sp500_usecase.dart';

class StockProvider extends ChangeNotifier {
  final GetSp500UseCase getSp500UseCase;

  StockProvider({required this.getSp500UseCase});

  // ===== STATE =====
  StockEntity? _sp500;
  bool _isLoading = false;
  Failure? _failure; // ✅ เพิ่ม Failure

  // ===== GETTERS =====
  StockEntity? get sp500 => _sp500;
  bool get isLoading => _isLoading;
  bool get hasError => _failure != null;
  String get errorMessage =>
      _failure != null ? ErrorHandler.getErrorMessage(_failure!) : '';

  // ===== ACTIONS =====
  Future<void> loadData() async {
    _isLoading = true;
    _failure = null;
    notifyListeners();

    try {
      _sp500 = await getSp500UseCase();
    } catch (e) {
      // ✅ ใช้ ErrorHandler
      _failure = ErrorHandler.handleException(e);
      _sp500 = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
