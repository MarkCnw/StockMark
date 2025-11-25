import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';
import 'package:stockmark/features/home/data/models/stock_model.dart';
import 'package:stockmark/features/home/domain/repositories/stock_repository.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApiService api;

  StockRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getStocks() async {
    final data = await api.fetchMostActive();
    return data.map((item) {
      final model = StockModel.fromJson(item); // ใช้ Model ช่วยแปลง
      return StockEntity(
        symbol: model.symbol,
        name: model.name,
        price: model.price,
        change: model.change,
      );
    }).toList();
  }

  @override
  Future<StockEntity> getSP500Daily() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDate = DateTime.now().toIso8601String().split(
      'T',
    )[0];

    // ✅ แก้ตรงนี้: เปลี่ยน key เป็น _v3 เพื่อให้มันหาของเก่าไม่เจอ
    final String? lastFetchDate = prefs.getString('sp500_date_v3');
    final String? cachedData = prefs.getString('sp500_data_v3');

    // 1. ลองเช็คของเก่าก่อน
    if (lastFetchDate == todayDate && cachedData != null) {
      try {
        final jsonMap = jsonDecode(cachedData);
        final model = StockModel.fromJson(jsonMap);

        if (model.price > 0.1) {
          print("📦 ใช้ข้อมูลเก่าจากเครื่อง (Cached)");
          return _mapToEntity(model);
        }
      } catch (e) {
        print("⚠️ Cache เสียหาย -> สั่งยิงใหม่!");
      }
    }

    // 2. ยิงใหม่
    print("🌐 ยิง API ใหม่ (New Fetch S&P 500)");
    try {
      final apiData = await api.fetchSP500();
      final model = StockModel.fromJson(apiData);

      if (model.price > 0.1) {
        // ✅ แก้ตรงนี้: บันทึกด้วย key ใหม่ _v3
        await prefs.setString('sp500_date_v3', todayDate);
        await prefs.setString('sp500_data_v3', jsonEncode(apiData));
      }

      return _mapToEntity(model);
    } catch (e) {
      if (cachedData != null) {
        final jsonMap = jsonDecode(cachedData);
        return _mapToEntity(StockModel.fromJson(jsonMap));
      }
      rethrow;
    }
  }

  StockEntity _mapToEntity(StockModel model) {
    return StockEntity(
      symbol: model.symbol,
      name: model.name,
      price: model.price,
      change: model.change,
    );
  }

  @override
  Future<List<StockEntity>> searchStocks(String query) async {
    return [];
  }
}
