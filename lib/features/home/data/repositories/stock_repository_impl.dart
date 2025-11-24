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
      return StockEntity(
        symbol: item['symbol'],
        name: item['shortName'] ?? '',
        price: item['regularMarketPrice']?.toDouble() ?? 0.0,
        change: item['regularMarketChangePercent']?.toDouble() ?? 0.0,
      );
    }).toList();
  }

  @override
  Future<StockEntity> getSP500Daily() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDate = DateTime.now().toIso8601String().split(
      'T',
    )[0];

    final String? lastFetchDate = prefs.getString('sp500_date');
    final String? cachedData = prefs.getString('sp500_data');

    // 1. ลองเช็คของเก่าก่อน
    if (lastFetchDate == todayDate && cachedData != null) {
      try {
        final jsonMap = jsonDecode(cachedData);
        final model = StockModel.fromJson(jsonMap);

        // 🔥 ทีเด็ดอยู่ตรงนี้: เช็คว่า "ราคาต้องมากกว่า 0" ถึงจะยอมใช้ Cache
        if (model.price > 0.1) {
          print("📦 ใช้ข้อมูลเก่าจากเครื่อง (Cached)");
          return _mapToEntity(model);
        } else {
          print("⚠️ ข้อมูลเก่าราคาเป็น 0 -> สั่งยิงใหม่!");
        }
      } catch (e) {
        print("⚠️ Cache เสียหาย -> สั่งยิงใหม่!");
      }
    }

    // 2. ถ้ามาถึงตรงนี้ แปลว่าต้องยิง API ใหม่แน่นอน
    print("🌐 ยิง API ใหม่ (New Fetch S&P 500)");
    try {
      final apiData = await api.fetchSP500();
      final model = StockModel.fromJson(apiData);

      // ถ้าได้ข้อมูลจริง (ราคา > 0) ค่อยบันทึก
      if (model.price > 0.1) {
        await prefs.setString('sp500_date', todayDate);
        await prefs.setString('sp500_data', jsonEncode(apiData));
      }

      return _mapToEntity(model);
    } catch (e) {
      // ถ้าเน็ตหลุดจริงๆ ให้พยายามเอาของเก่าเน่าๆ (ถ้ามี) มาโชว์แก้ขัด
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
    // เดี๋ยวค่อยทำทีหลัง
    return [];
  }
}
