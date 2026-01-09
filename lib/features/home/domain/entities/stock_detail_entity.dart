// ignore_for_file: public_member_api_docs, sort_constructors_first
class StockDetailEntity {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final String about;

  // ข้อมูลสถิติ (Stats)
  final double open;
  final double high;
  final double low;
  final double volume;
  final double peRatio;
  final double marketCap;
  final double fiftyTwoWeekHigh;
  final double fiftyTwoWeekLow;

  StockDetailEntity({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.about,
    required this.open,
    required this.high,
    required this.low,
    required this.volume,
    required this.peRatio,
    required this.marketCap,
    required this.fiftyTwoWeekHigh,
    required this.fiftyTwoWeekLow,
  });
}
