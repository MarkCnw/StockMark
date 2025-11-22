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

  Future<StockEntity> getSP500Daily() async {
    final prefs = await SharedPreferences.getInstance();

    // 1. หาวันที่ปัจจุบัน (เอาแค่ ปี-เดือน-วัน ตัดเวลาทิ้ง)
    final String todayDate = DateTime.now().toIso8601String().split(
      'T',
    )[0];

    // 2. เช็คว่า "วันที่บันทึกล่าสุด" ตรงกับ "วันนี้" ไหม?
    final String? lastFetchDate = prefs.getString('sp500_date');
    final String? cachedData = prefs.getString('sp500_data');

    if (lastFetchDate == todayDate && cachedData != null) {
      // 🟢 ถ้าตรงกัน: ใช้ของเดิม (ไม่ต้องเปลืองเน็ต)
      print("📦 ใช้ข้อมูลเก่าจากเครื่อง (Cached)");
      final jsonMap = jsonDecode(cachedData);
      final model = StockModel.fromJson(jsonMap);
      return _mapToEntity(model);
    } else {
      // 🔴 ถ้าไม่ตรง (คนละวัน): ยิง API ใหม่
      print("🌐 ยิง API ใหม่ (New Fetch)");
      try {
        final apiData = await api.fetchSP500();
        final model = StockModel.fromJson(apiData);

        // 3. เซฟข้อมูลใหม่ลงเครื่อง
        await prefs.setString('sp500_date', todayDate); // จดวันที่
        await prefs.setString(
          'sp500_data',
          jsonEncode(apiData),
        ); // จดข้อมูล

        return _mapToEntity(model);
      } catch (e) {
        // ถ้าเน็ตหลุด ให้พยายามเอาของเก่ามาโชว์แก้ขัดไปก่อน (ถ้ามี)
        if (cachedData != null) {
          final jsonMap = jsonDecode(cachedData);
          return _mapToEntity(StockModel.fromJson(jsonMap));
        }
        rethrow;
      }
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
