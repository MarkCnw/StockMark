import 'package:stockmark/features/home/domain/entities/stock_entity.dart';

abstract class MoversRepository {
  Future<List<StockEntity>> getTopGainers();
  Future<List<StockEntity>> getTopLosers();
}
