

class StockEntity { //🧱 Entity คือแบบจำลองข้อมูลที่สะอาด ไม่ผูกกับ data layer
  final String symbol;
  final String name;
  final double price;
  final double change;

  StockEntity({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });
}
