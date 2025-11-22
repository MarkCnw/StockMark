import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/app_theme.dart';
import 'package:stockmark/core/navigation_shell.dart';

// Import ของ Stock (S&P 500 Index)
import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';
import 'package:stockmark/features/home/data/repositories/stock_repository_impl.dart';
import 'package:stockmark/features/home/domain/usecases/get_sp500_usecase.dart';
import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';

// Import ของ Movers (Gainers/Losers)
import 'package:stockmark/features/home/data/datasources/movers_api_service.dart';
import 'package:stockmark/features/home/data/repositories/movers_repository_impl.dart';
import 'package:stockmark/features/home/domain/usecases/get_top_gainers_usecase.dart';
import 'package:stockmark/features/home/domain/usecases/get_top_losers_usecase.dart';
import 'package:stockmark/features/home/presentation/providers/movers_provider.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const StockMarkApp());
}

class StockMarkApp extends StatefulWidget {
  const StockMarkApp({super.key});

  @override
  State<StockMarkApp> createState() => _StockMarkAppState();
}

class _StockMarkAppState extends State<StockMarkApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 1. เตรียมของสำหรับ S&P 500
    final stockApi = StockApiService();
    final stockRepo = StockRepositoryImpl(stockApi);
    final getSp500UseCase = GetSp500UseCase(stockRepo);

    // 2. เตรียมของสำหรับ Top Movers (Gainers/Losers)
    final moversApi = MoversApiService();
    final moversRepo = MoversRepositoryImpl(moversApi);
    final getTopGainers = GetTopGainersUsecase(moversRepo);
    final getTopLosers = GetTopLosersUsecase(moversRepo);

    return MultiProvider(
      providers: [
        // Provider 1: S&P 500 Index
        ChangeNotifierProvider(
          create: (_) => StockProvider(
            getSp500UseCase: getSp500UseCase, repository: stockRepo,
          )..loadData(),
        ),

        // Provider 2: Movers List (Gainers/Losers)
        ChangeNotifierProvider(
          create: (_) => MoversProvider(
            getTopGainersUsecase: getTopGainers,
            getTopLosersUsecase: getTopLosers,
          )..loadMovers(), // โหลดข้อมูลทันที
        ),
      ],
      child: MaterialApp(
        title: 'StockMark',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: NavigationShell(onToggleTheme: _toggleTheme),
      ),
    );
  }
}