import 'dart:async';
import 'package:flutter/material.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/usecases/search_stocks_usecase.dart';

class StockProvider extends ChangeNotifier {
  final SearchStocksUseCase searchUseCase;
  List<StockEntity> stocks = [];
  bool isLoading = false;
  bool isSearching = false; // ✅ เพิ่มตัวแปรนี้

  Timer? _debounce;

  StockProvider(this.searchUseCase);

  Future<void> loadStocks() async {
    isLoading = true;
    isSearching = false; // ✅ loadStocks ไม่ใช่การค้นหา
    notifyListeners();
    
    stocks = await searchUseCase.call('');
    isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      isLoading = true;
      isSearching = true; // ✅ ตั้งค่าว่ากำลังค้นหา
      notifyListeners();

      stocks = await searchUseCase.call(query);
      isLoading = false;
      notifyListeners();
    });
  }

  // ✅ เพิ่ม method สำหรับ reset
  void resetSearch() {
    stocks = [];
    isSearching = false;
    notifyListeners();
  }
}