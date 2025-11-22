import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/features/home/presentation/providers/movers_provider.dart';

class TopMoversSection extends StatefulWidget {
  const TopMoversSection({super.key});

  @override
  State<TopMoversSection> createState() => _TopMoversSectionState();
}

class _TopMoversSectionState extends State<TopMoversSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. หัวข้อใหม่
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'Trending Now 🔥', 
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
        ),
        
        // 2. ลบ Tab Button ทิ้งไปแล้ว (Code สะอาดขึ้นเยอะ)

        // 3. List รายการหุ้น
        SizedBox(
          height: 180,
          child: Consumer<MoversProvider>(
            builder: (context, provider, _) {
              
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (provider.errorMessage != null) {
                return Center(child: Text(provider.errorMessage!));
              }

              // ✅ ดึงข้อมูล Trending (ที่เราใส่ไว้ใน gainers) มาโชว์เลย
              final currentList = provider.gainers; 

              if (currentList.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: currentList.length,
                itemBuilder: (context, index) {
                  final stock = currentList[index];
                  return _StockCard(
                    symbol: stock.symbol,
                    name: stock.name,
                    price: stock.price,
                    change: stock.change,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _StockCard extends StatelessWidget {
  final String symbol;
  final String name;
  final double price;
  final double change;

  const _StockCard({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? AppColors.darkShadow : AppColors.lightShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor:
                isDark ? AppColors.darkIconBg : AppColors.lightIconBg,
            child: Text(
              symbol.substring(0, 1),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            symbol,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
          ),
          Text(
            name,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
          ),
          Text(
            '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}%',
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}