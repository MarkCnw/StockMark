import 'package:stockmark/features/home/data/datasources/movers_api_service.dart';
import 'package:stockmark/features/home/data/models/stock_model.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class MoversRepositoryImpl implements MoversRepository {
  final MoversApiService api;

  MoversRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getTopGainers() async {
    final data = await api.fetchGainers();
    return _mapToEntity(data);
  }

  @override
  Future<List<StockEntity>> getTopLosers() async {
    final data = await api.fetchLosers();
    return _mapToEntity(data);
  }

  @override
  Future<List<StockEntity>> getTrending() async {
    final data = await api.fetchTrending();
    return _mapToEntity(data);
  }

  // Helper function ช่วยแปลงร่าง (จะได้ไม่ต้องเขียนซ้ำ)
  List<StockEntity> _mapToEntity(List<dynamic> data) {
    return data.map((item) {
      final model = StockModel.fromJson(item);
      return StockEntity(
        symbol: model.symbol,
        name: model.name,
        price: model.price,
        change: model.change,
      );
    }).toList();
  }
}
