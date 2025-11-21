import 'package:stockmark/features/home/data/datasources/movers_api_service.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/movers_repository.dart';

class MoversRepositoryImpl implements MoversRepository {
  final MoversApiService api;

  MoversRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getTopGainers() {
   
    throw UnimplementedError();
  }

  @override
  Future<List<StockEntity>> getTopLosers()async {
    final data.Map()
  }

}
