import 'package:flutter/material.dart';
import 'package:stockmark/features/home/domain/repositories/stock_repository.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';

class StockProvider extends ChangeNotifier {
  final StockRepository repository;

  List<StockEntity> stocks = [];
  bool isLoading = false;

  StockProvider(this.repository);

  Future<void> loadStocks() async {
    isLoading = true;
    notifyListeners();

    stocks = await repository.getStocks();

    isLoading = false;
    notifyListeners();
  }
}
