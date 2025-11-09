class StockApiService {
  Future<List<Map<String, dynamic>>> fetchStocks() async {
    
    return [
      {"symbol": "AAPL", "name": "Apple Inc.", "price": 189.98, "change": 2.45},
      {"symbol": "GOOGL", "name": "Alphabet Inc.", "price": 141.76, "change": 1.87},
      {"symbol": "MSFT", "name": "Microsoft Corp.", "price": 330.50, "change": -0.92},
    ];
  }
}
