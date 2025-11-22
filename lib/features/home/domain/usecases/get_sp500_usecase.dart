import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/stock_repository.dart';

class GetSp500UseCase {
  final StockRepository repository;

  GetSp500UseCase(this.repository);

  Future<StockEntity> call() {
    return repository.getSP500Daily();
  }
}