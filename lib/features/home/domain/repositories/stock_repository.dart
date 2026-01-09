import 'package:stockmark/features/home/domain/entities/stock_detail_entity.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';

abstract class StockRepository {
  Future<List<StockEntity>> getStocks();
  Future<List<StockEntity>> searchStocks(String query);
  Future<StockEntity> getSP500Daily();
  // ✅ 2. เพิ่มคำสั่งนี้ลงไป
  Future<StockDetailEntity?> getStockDetail(String symbol);
  
  Future<List<double>> getStockChart(String symbol); // ✅ เพิ่มบรรทัดนี้
}
