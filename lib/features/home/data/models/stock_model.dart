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
      // 1. Symbol (Yahoo ใช้ 'symbol')
      symbol: json['symbol'] as String? ?? 'N/A',

      // 2. Name (Yahoo ใช้ 'shortName' หรือ 'longName')
      name: json['shortName'] as String? ?? 
            json['longName'] as String? ?? 
            json['name'] as String? ?? // เผื่อ FMP
            json['symbol'] as String? ?? 
            'N/A',

      // 3. Price (Yahoo ใช้ 'regularMarketPrice')
      price: (json['regularMarketPrice'] as num?)?.toDouble() ?? 
             (json['price'] as num?)?.toDouble() ?? // เผื่อ FMP
             (json['c'] as num?)?.toDouble() ?? // เผื่อ Finnhub
             0.0,

      // 4. Change (Yahoo ใช้ 'regularMarketChangePercent')
      change: (json['regularMarketChangePercent'] as num?)?.toDouble() ?? 
              _parseChange(json),
    );
  }

  // ตัวช่วยแกะค่า Change ของเจ้าเก่าๆ
  static double _parseChange(Map<String, dynamic> json) {
    if (json['changesPercentage'] != null) {
      return (json['changesPercentage'] as num).toDouble();
    } else if (json['change'] != null) {
      return double.tryParse(json['change'].toString()) ?? 0.0;
    }
    return 0.0;
  }

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'name': name,
      'price': price,
      'change': change,
    };
  }
}