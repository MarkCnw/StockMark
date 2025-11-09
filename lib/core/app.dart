import 'package:flutter/material.dart';
import 'package:stockmark/core/app_theme.dart';
import 'package:stockmark/features/home/presentation/screens/home_screen.dart';

class StockMarkApp extends StatelessWidget {
  const StockMarkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StockMark',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
