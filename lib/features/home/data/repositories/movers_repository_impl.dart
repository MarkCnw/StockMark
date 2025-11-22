import 'package:stockmark/features/home/data/datasources/movers_api_service.dart';
import 'package:stockmark/features/home/data/models/stock_model.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class MoversRepositoryImpl implements MoversRepository {
  final MoversApiService api;

  MoversRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getTopGainers() async {
    // เรียก fetchTrending (ที่เราทำ Loop ยิง 10 ตัว)
    final data = await api.fetchTrending();

    return data.map((item) {
      // 1. แปลงเป็น Model
      final model = StockModel.fromJson(item);
      
      // 2. แปลงเป็น Entity เลย (❌ ห้ามมี .where กรองราคาตรงนี้เด็ดขาด!)
      return StockEntity(
        symbol: model.symbol,
        name: model.name,
        price: model.price,
        change: model.change,
      );
    }).toList();
  }

  @override
  Future<List<StockEntity>> getTopLosers() async {
    return []; // ไม่ได้ใช้
  }
}