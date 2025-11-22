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
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      change: _parseChange(json),
    );
  }

  // ✅ แก้ไขให้รองรับ key 'change' ด้วย
  static double _parseChange(Map<String, dynamic> json) {
    // 1. ถ้ามี 'change' โดยตรง (จาก MoversApiService ของเรา)
    if (json['change'] != null) {
      return (json['change'] as num).toDouble();
    }
    
    // 2. FMP API (changesPercentage)
    if (json['changesPercentage'] != null) {
      return (json['changesPercentage'] as num).toDouble();
    }
    
    // 3. AlphaVantage API (change_percentage เป็น string มี %)
    if (json['change_percentage'] != null) {
      String val = json['change_percentage'].toString().replaceAll('%', '');
      return double.tryParse(val) ?? 0.0;
    }
    
    // 4. Finnhub API (dp)
    if (json['dp'] != null) {
      return (json['dp'] as num).toDouble();
    }
    
    return 0.0;
  }
}