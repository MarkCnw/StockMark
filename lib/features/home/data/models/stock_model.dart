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
      symbol: json['symbol'] as String? ?? 'N/A',
      name: json['name'] as String? ?? json['symbol'] as String? ?? 'N/A',
      
      // ✅ เช็คให้ชัวร์ว่าอ่าน key 'price' (ของ FMP)
      price: (json['price'] as num?)?.toDouble() ?? 
             (json['c'] as num?)?.toDouble() ?? 0.0, 

      // ✅ เช็ค changesPercentage (ของ FMP)
      change: _parseChange(json),
    );
  }

  static double _parseChange(Map<String, dynamic> json) {
    if (json['changesPercentage'] != null) {
      return (json['changesPercentage'] as num).toDouble();
    } else if (json['change'] != null) {
      return double.tryParse(json['change'].toString()) ?? 0.0;
    } else if (json['dp'] != null) {
      return (json['dp'] as num).toDouble();
    }
    return 0.0;
  }
}