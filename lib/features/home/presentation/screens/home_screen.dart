import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/search_box.dart';
import '../widgets/stock_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<StockProvider>().loadStocks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stock Market')),
      body: Column(
        children: const [
          SearchBox(),
          Expanded(child: StockList()),
        ],
      ),
    );
  }
}
