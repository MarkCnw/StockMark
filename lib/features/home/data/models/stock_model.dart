class StockModel {
  final String symbol;   // ชื่อย่อหุ้น เช่น AAPL
  final String name;     // ชื่อบริษัท
  final double price;    // ราคาปัจจุบัน
  final double change;   // เปอร์เซ็นต์การเปลี่ยนแปลง

  const StockModel({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  // ฟังก์ชันจำลองจาก JSON (ใช้ในอนาคตเมื่อมี API จริง)
  factory StockModel.fromJson(Map<String, dynamic> json) {
    return StockModel(
      symbol: json['symbol'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      change: (json['change'] as num).toDouble(),
    );
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
