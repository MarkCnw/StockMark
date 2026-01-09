import 'package:stockmark/features/home/domain/entities/stock_detail_entity.dart';

class StockDetailModel extends StockDetailEntity {
  StockDetailModel({
    required super.symbol,
    required super.name,
    required super.price,
    required super.change,
    required super.changePercent,
    required super.open,
    required super.high,
    required super.low,
    required super.volume,
    required super.peRatio,
    required super.marketCap,
    required super.fiftyTwoWeekHigh,
    required super.fiftyTwoWeekLow,
    required super.about,
  });

  factory StockDetailModel.fromJson(Map<String, dynamic> json) {
    return StockDetailModel(
      symbol: json['symbol'] ?? '',
      name: json['shortName'] ?? json['longName'] ?? '',
      price: (json['regularMarketPrice'] as num?)?.toDouble() ?? 0.0,
      change: (json['regularMarketChange'] as num?)?.toDouble() ?? 0.0,
      changePercent:
          (json['regularMarketChangePercent'] as num?)?.toDouble() ?? 0.0,
      open: (json['regularMarketOpen'] as num?)?.toDouble() ?? 0.0,
      high: (json['regularMarketDayHigh'] as num?)?.toDouble() ?? 0.0,
      low: (json['regularMarketDayLow'] as num?)?.toDouble() ?? 0.0,
      volume: (json['regularMarketVolume'] as num?)?.toDouble() ?? 0.0,
      peRatio: (json['trailingPE'] as num?)?.toDouble() ?? 0.0,
      marketCap: (json['marketCap'] as num?)?.toDouble() ?? 0.0,
      fiftyTwoWeekHigh:
          (json['fiftyTwoWeekHigh'] as num?)?.toDouble() ?? 0.0,
      fiftyTwoWeekLow:
          (json['fiftyTwoWeekLow'] as num?)?.toDouble() ?? 0.0,
      about: json['about'] ?? 'No description.',
    );
  }
}
