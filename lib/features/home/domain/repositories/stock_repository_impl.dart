import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';
import 'package:stockmark/features/home/data/models/stock_model.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/data/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApiService api;

  StockRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getStocks() async {
    try {
      final List<Map<String, dynamic>> rawData = await api.fetchStocks();

      // ✅ แปลงจาก Map → StockModel ก่อน
      final List<StockModel> data = rawData
          .map((json) => StockModel.fromJson(json))
          .toList();

      // ✅ แล้วแปลงต่อเป็น StockEntity (ถ้าต้องการ)
      return data
          .map(
            (e) => StockEntity(
              symbol: e.symbol,
              name: e.name,
              price: e.price,
              change: e.change,
            ),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load stocks: $e');
    }
  }

  @override
  Future<List<StockEntity>> searchStocks(String query) async {
    final all = await getStocks();
    return all
        .where(
          (stock) =>
              stock.name.toLowerCase().contains(query.toLowerCase()) ||
              stock.symbol.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }
}
