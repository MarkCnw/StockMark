class StockModel {
  final String symbol;
  final String name;
  final double price;
  final double change;

  const StockModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      // FMP ใช้ 'symbol'
      symbol: json['symbol'] as String? ?? 'N/A',
      
      // FMP ใช้ 'name'
      name: json['name'] as String? ?? json['symbol'] as String? ?? 'N/A',
      
      // FMP ใช้ 'price' (Number)
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      
      // ⚠️ จุดสำคัญ: FMP ใช้ 'changesPercentage' (มี s และเป็น number)
      // AlphaVantage ใช้ 'change_percentage' (String มี %)
      // Finnhub ใช้ 'dp'
      change: _parseChange(json),
    );
  }

  // Helper function เพื่อรองรับ API หลายเจ้า
  static double _parseChange(Map<String, dynamic> json) {
    if (json['changesPercentage'] != null) {
      // ของ FMP (มาเป็นตัวเลขเลย เช่น 1.5)
      return (json['changesPercentage'] as num).toDouble();
    } else if (json['change_percentage'] != null) {
      // ของ AlphaVantage (มาเป็น string "1.5%")
      String val = json['change_percentage'].toString().replaceAll('%', '');
      return double.tryParse(val) ?? 0.0;
    } else if (json['dp'] != null) {
      // ของ Finnhub
      return (json['dp'] as num).toDouble();
    }
    return 0.0;
  }
}