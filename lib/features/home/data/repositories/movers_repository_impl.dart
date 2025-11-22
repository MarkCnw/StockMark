import 'package:stockmark/features/home/data/datasources/movers_api_service.dart';
import 'package:stockmark/features/home/data/models/stock_model.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class MoversRepositoryImpl implements MoversRepository {
  final MoversApiService api;

  MoversRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getTopGainers() async {
    
    final data = await api.fetchTrending();

    return data
        .map((item) => StockModel.fromJson(item))
        
        .map((model) => StockEntity(
              symbol: model.symbol,
              name: model.name,
              price: model.price,
              change: model.change,
            ))
        .toList();
  }

  @override
  Future<List<StockEntity>> getTopLosers() async {
    // ไม่ได้ใช้ แต่ต้องมีไว้กัน Error (ส่งค่าว่างไป)
    return [];
  }
}