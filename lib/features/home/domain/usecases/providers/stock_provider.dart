import 'dart:async';

import 'package:flutter/material.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/usecases/search_stocks_usecase.dart';

class StockProvider extends ChangeNotifier {
  final SearchStocksUseCase searchUseCase;
  List<StockEntity> stocks = [];
  bool isLoading = false;

  Timer? _debounce;

  StockProvider(this.searchUseCase);

  Future<void> loadStocks() async {
    isLoading = true;
    stocks = await searchUseCase.call('');
    isLoading = false;
    notifyListeners();
  }

  void search(String query) {
    // ยกเลิก Timer เดิมก่อน
    _debounce?.cancel();

    // ถ้าผู้ใช้หยุดพิมพ์ 400ms ค่อยค้นหา
    _debounce = Timer(const Duration(milliseconds: 400), () async {
      isLoading = true;
      notifyListeners();

      stocks = await searchUseCase.call(query);
      isLoading = false;
      notifyListeners();
    });
  }
}
