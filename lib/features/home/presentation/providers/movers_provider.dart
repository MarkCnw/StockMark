import 'package:flutter/material.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

// ในไฟล์ lib/features/home/presentation/providers/movers_provider.dart

class MoversProvider extends ChangeNotifier {
  final MoversRepository repository; 

  List<StockEntity> gainers = [];
  List<StockEntity> losers = [];
  List<StockEntity> trending = [];
  
  bool isLoading = false;
  String? errorMessage; // ✅ เพิ่มตัวนี้ แก้ Error 1

  MoversProvider({required this.repository}); // ✅ Constructor ต้องรับแบบ named parameter

  Future<void> loadMovers() async {
    // ... (logic เดิม) ...
    try {
      // โหลด 3 อย่างพร้อมกัน
      final results = await Future.wait([
        repository.getTopGainers(),
        repository.getTopLosers(),
        repository.getTrending(),
      ]);

      gainers = results[0];
      losers = results[1];
      trending = results[2];
      
    } catch (e) {
      print("Error loading movers: $e");
      errorMessage = "Failed to load market data."; // ✅ แก้ Error 1
    }

    isLoading = false;
    notifyListeners();
  }
}