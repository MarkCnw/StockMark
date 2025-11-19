import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';
import 'package:stockmark/features/home/data/repositories/stock_repository.dart';
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
  Future<List<StockEntity>> searchStocks(String query) async {
    // เดี๋ยวค่อยทำทีหลัง
    return [];
  }
}
