import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class GetTopGainersUsecase {
  final MoversRepository repository;

  GetTopGainersUsecase(this.repository);

  Future<List<StockEntity>> call() async {
    return await repository.getTopGainers();
  }

  
}
