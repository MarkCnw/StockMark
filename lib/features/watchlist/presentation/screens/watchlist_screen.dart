import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/app_routes.dart';
import 'package:stockmark/providers/stock_provider.dart';


class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<StockProvider>(context, listen: false).loadStocks(),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('StockMark')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.detail);
          },
          child: const Text('Go to Stock Detail'),
        ),
      ),
    );
  }
}
