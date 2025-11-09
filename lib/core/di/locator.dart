// import 'package:get_it/get_it.dart';
// import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';
// import 'package:stockmark/features/home/domain/usecases/search_stocks_usecase.dart';
// import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';
// import 'package:stockmark/impl/stock_repository_impl.dart';

// final getIt = GetIt.instance;

// void setupLocator() {
//   // ✅ Data Layer
//   getIt.registerLazySingleton(() => StockApiService());
//   getIt.registerLazySingleton(() => StockRepositoryImpl(getIt()));

//   // ✅ Domain Layer
//   getIt.registerLazySingleton(() => SearchStocksUseCase(getIt()));

//   // ✅ Presentation Layer
//   getIt.registerFactory(() => StockProvider(getIt()));
// }
