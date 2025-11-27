import 'package:flutter/material.dart';
import 'package:stockmark/features/home/data/repositories/stock_repository_impl.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/usecases/get_sp500_usecase.dart';

class StockProvider extends ChangeNotifier {
  final GetSp500UseCase getSp500UseCase;

  StockEntity? sp500; // ✅ เหลือแค่ตัวนี้ตัวเดียว (พระเอกของเรา)
  bool isLoading = false;

  // ตัด repository ออก เพราะไม่ได้ใช้แล้ว
  StockProvider({
    required this.getSp500UseCase,
    required StockRepositoryImpl repository,
  });

  Future<void> loadData() async {
    isLoading = true;
    notifyListeners();

    try {
      // โหลดแค่ S&P 500 อย่างเดียว
      sp500 = await getSp500UseCase();
    } catch (e) {
      print("Error loading S&P 500: $e");
    }

    isLoading = false;
    notifyListeners();
  }
}
