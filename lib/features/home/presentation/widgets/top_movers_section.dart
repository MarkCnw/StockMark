import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import '../../../home/presentation/providers/stock_provider.dart';

class TopMoversSection extends StatefulWidget {
  const TopMoversSection({super.key});

  @override
  State<TopMoversSection> createState() => _TopMoversSectionState();
}

class _TopMoversSectionState extends State<TopMoversSection> {
  bool showGainers = true;

  @override
  Widget build(BuildContext context) {
    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Text(
            'Top Movers',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  context: context,
                  label: 'Gainers',
                  isSelected: showGainers,
                  onTap: () => setState(() => showGainers = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTabButton(
                  context: context,
                  label: 'Losers',
                  isSelected: !showGainers,
                  onTap: () => setState(() => showGainers = false),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: Consumer<StockProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final filteredStocks = showGainers
                  ? provider.stocks.where((s) => s.change > 0).toList()
                  : provider.stocks.where((s) => s.change < 0).toList();

              if (filteredStocks.isEmpty) {
                return const Center(child: Text('No data available'));
              }

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filteredStocks.length,
                itemBuilder: (context, index) {
                  final stock = filteredStocks[index];
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

  Widget _buildTabButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.primaryBlueDark : AppColors.primaryBlue)
              : (isDark
                  ? AppColors.darkTabUnselected
                  : AppColors.lightTabUnselected),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? Colors.white
                  : (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
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