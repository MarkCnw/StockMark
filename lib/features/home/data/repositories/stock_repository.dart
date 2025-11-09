

import 'package:stockmark/features/home/domain/entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getStocks();
  Future<List<StockEntity>> searchStocks(String query);
}
