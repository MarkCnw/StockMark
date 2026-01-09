import 'package:flutter/material.dart';
import 'package:stockmark/features/home/domain/entities/stock_detail_entity.dart';
import 'package:stockmark/features/home/domain/repositories/stock_repository.dart';

class StockDetailProvider extends ChangeNotifier {
  final StockRepository repository;

  StockDetailProvider({required this.repository});

  StockDetailEntity? _detail;
  bool _isLoading = false;
  String? _errorMessage;
  List<double> _chartData = [];

  // Getters สำหรับ UI เรียกใช้
  StockDetailEntity? get stockDetail => _detail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<double> get chartData => _chartData;

  // ฟังก์ชันโหลดข้อมูล (เรียกเมื่อเข้าหน้า Detail)
  Future<void> loadStockDetail(String symbol) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // ✅ 2. สั่งโหลด 2 อย่างพร้อมกัน (Detail + Chart)
      // ใช้ Future.wait เพื่อความเร็ว (ไม่ต้องรอทีละอัน)
      final results = await Future.wait([
        repository.getStockDetail(symbol),
        repository.getStockChart(symbol),
      ]);

      _detail = results[0] as StockDetailEntity?;
      _chartData = results[1] as List<double>; // เก็บข้อมูลกราฟ
    } catch (e) {
      _errorMessage = e.toString();
      _detail = null;
      _chartData = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
