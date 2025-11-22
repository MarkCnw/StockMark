import 'package:flutter/material.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
// Import UseCases ที่เราสร้างไว้
import 'package:stockmark/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:stockmark/features/home/domain/usecases/get_top_losers_usecase.dart';

class MoversProvider extends ChangeNotifier {
  // 1. เรียกใช้ UseCase แทน Repository
  final GetTopGainersUsecase getTopGainersUsecase;
  final GetTopLosersUsecase getTopLosersUsecase;

  // 2. แยก State ชัดเจน (รองรับ Tab Switch)
  List<StockEntity> gainers = [];
  List<StockEntity> losers = [];
  
  bool isLoading = false;
  String? errorMessage; // เก็บ Error ไว้โชว์ User

  MoversProvider({
    required this.getTopGainersUsecase,
    required this.getTopLosersUsecase,
  });

  Future<void> loadMovers() async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // ⚡ แก้ตรงนี้: เรียกแค่ Gainers (Trending) ตัวเดียวพอ!
      // ไม่ต้องรอ Losers แล้ว เพราะ UI เราไม่ได้โชว์
      gainers = await getTopGainersUsecase();
      
      // losers = ... (ไม่ต้องโหลด)
      
    } catch (e) {
      errorMessage = "Failed to load data: $e";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}