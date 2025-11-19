import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/app_theme.dart';
import 'package:stockmark/core/navigation_shell.dart';

// 🟦 import ทั้งหมด
import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';

import 'package:stockmark/features/home/domain/repositories/stock_repository_impl.dart';
import 'package:stockmark/features/home/domain/usecases/search_stocks_usecase.dart';
import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';

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
    // 🟢 สร้าง dependency ครบ chain
    final api = StockApiService();
    final repo = StockRepositoryImpl(api);
    final searchUseCase = SearchStocksUseCase(repo); // ✅ usecase layer

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          // create: (_) => StockProvider(searchUseCase), // ✅ ใช้ usecase
          create: (_) => StockProvider(repo),
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
