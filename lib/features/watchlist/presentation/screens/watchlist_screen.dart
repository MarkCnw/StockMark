import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';

import 'package:stockmark/features/watchlist/presentation/widgets/watchlist_item.dart';

import '../../../watchlist/presentation/widgets/search_box.dart';

class WatchlistScreen extends StatefulWidget {
  const WatchlistScreen({super.key});

  @override
  State<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends State<WatchlistScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StockProvider>().resetSearch());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Watchlist')),
      body: Column(
        children: const [
          SearchBox(),
          Expanded(child: StockList()),
        ],
      ),
    );
  }
}
