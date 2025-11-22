import 'package:flutter/material.dart';
import '../widgets/market_overview_section.dart'; // การ์ด S&P 500
import '../widgets/top_movers_section.dart';      // รายการ Gainers/Losers

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('S&P 500 Dashboard'), // ตั้งชื่อให้เท่ๆ
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              
              // 1. แสดงดัชนีหลัก (S&P 500 Card)
              MarketOverviewSection(),

              SizedBox(height: 16),

              // 2. แสดงหุ้นที่มีการเคลื่อนไหวสูงสุด (Top Movers)
              TopMoversSection(),

              SizedBox(height: 100), // พื้นที่เผื่อด้านล่าง
            ],
          ),
        ),
      ),
    );
  }
}