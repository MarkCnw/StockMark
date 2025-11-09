import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/data/repositories/stock_repository.dart';

class SearchStocksUseCase {
  final StockRepository repository;

  SearchStocksUseCase(this.repository);

  Future<List<StockEntity>> call(String query) async {
    if (query.isEmpty) return repository.getStocks();
    return repository.searchStocks(query);
  }
}
