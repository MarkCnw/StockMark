import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';
import '../../../watchlist/presentation/widgets/search_box.dart';
import '../../../watchlist/presentation/widgets/watchlist_item.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StockProvider>().loadStocks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: Column(
        children: const [
          SearchBox(),
          
        ],
      ),
    );
  }
}
