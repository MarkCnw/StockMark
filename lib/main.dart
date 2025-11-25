import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/app_theme.dart';
import 'package:stockmark/core/navigation_shell.dart';

// Import Stock
import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';
import 'package:stockmark/features/home/data/repositories/stock_repository_impl.dart';
import 'package:stockmark/features/home/domain/usecases/get_sp500_usecase.dart';
import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';

// Import Movers
import 'package:stockmark/features/home/data/datasources/movers_api_service.dart';
import 'package:stockmark/features/home/data/repositories/movers_repository_impl.dart';
// import UseCase ไม่ต้องใช้แล้ว ลบออกได้เลย
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
    // 1. Setup Stock (S&P 500)
    final stockApi = StockApiService();
    final stockRepo = StockRepositoryImpl(stockApi);
    final getSp500UseCase = GetSp500UseCase(stockRepo);

    // 2. Setup Movers
    final moversApi = MoversApiService();
    final moversRepo = MoversRepositoryImpl(moversApi);

    return MultiProvider(
      providers: [
        // Provider 1: Stock (S&P 500)
        ChangeNotifierProvider(
          create: (_) => StockProvider(
            getSp500UseCase: getSp500UseCase, 
            repository: stockRepo, // ✅ เพิ่มตัวนี้กลับเข้าไปตามที่ StockProvider ต้องการ
          )..loadData(),
        ),

        // Provider 2: Movers List (Gainers/Losers/Trending)
        ChangeNotifierProvider(
          create: (_) => MoversProvider(
            // ✅ ส่ง repository เข้าไป (ตามที่ MoversProvider ต้องการ)
            repository: moversRepo, 
          )..loadMovers(), 
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