import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../home/presentation/providers/stock_provider.dart';

class StockList extends StatelessWidget {
  const StockList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StockProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: provider.stocks.length,
          itemBuilder: (context, index) {
            final stock = provider.stocks[index];
            return ListTile(
              title: Text(stock.name),
              subtitle: Text(stock.symbol),
              trailing: Text(
                "\$${stock.price}",
                style: TextStyle(
                  color: stock.change >= 0
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
