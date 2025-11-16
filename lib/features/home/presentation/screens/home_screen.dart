import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/stock_provider.dart';
import '../widgets/top_movers_section.dart';
import '../widgets/market_overview_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<StockProvider>().loadStocks());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text(
          'Home'
          // style: TextStyle(
          //   color: Colors.black87,
          //   fontWeight: FontWeight.w600,
          // ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined, ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [

              TopMoversSection(),

              // Market Overview Section
              MarketOverviewSection(),

              SizedBox(height: 100), // เว้นที่สำหรับ Bottom Navigation
            ],
          ),
        ),
      ),
    );
  }
}