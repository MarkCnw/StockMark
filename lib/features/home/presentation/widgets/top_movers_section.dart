import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/providers/stock_provider.dart';

class TopMoversSection extends StatefulWidget {
  const TopMoversSection({super.key});

  @override
  State<TopMoversSection> createState() => _TopMoversSectionState();
}

class _TopMoversSectionState extends State<TopMoversSection> {
  bool showGainers = true; // true = Gainers, false = Losers

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
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

        // Tabs (Gainers/Losers)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _buildTabButton(
                  label: 'Gainers',
                  isSelected: showGainers,
                  onTap: () => setState(() => showGainers = true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTabButton(
                  label: 'Losers',
                  isSelected: !showGainers,
                  onTap: () => setState(() => showGainers = false),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Horizontal Stock Cards
        SizedBox(
          height: 160,
          child: Consumer<StockProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              // Filter gainers or losers
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
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF2B6BE5)
              : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.grey.shade600,
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

    return Container(
      color: Colors.white,
      width: 160,
      height: 160,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Circle
          CircleAvatar(
            radius: 20,

            child: Text(
              symbol.substring(0, 1),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Symbol
          Text(
            symbol,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),

          // Company Name
          Text(
            name,
            // style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const Spacer(),

          // Price
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),

          // Change Percentage
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
