import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class GetTopLosersUsecase {
  final MoversRepository repository;

  GetTopLosersUsecase(this.repository);

  Future<List<StockEntity>> call() {
    return repository.getTopLosers();
  }
}
