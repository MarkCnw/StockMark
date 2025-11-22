import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MoversApiService {
  final String _apiKey = dotenv.env['FINNHUB_API_KEY'] ?? '';
  final String baseUrl = "https://finnhub.io/api/v1";

  // 📌 รายชื่อหุ้นยอดนิยม (Hard-code)
  static const List<Map<String, String>> trendingStocks = [
    {"symbol": "AAPL", "name": "Apple Inc."},
    {"symbol": "MSFT", "name": "Microsoft Corp."},
    {"symbol": "GOOGL", "name": "Alphabet Inc."},
    {"symbol": "AMZN", "name": "Amazon.com Inc."},
    {"symbol": "NVDA", "name": "NVIDIA Corp."},
    {"symbol": "TSLA", "name": "Tesla Inc."},
    {"symbol": "META", "name": "Meta Platforms Inc."},
    {"symbol": "AMD", "name": "Advanced Micro Devices"},
    {"symbol": "NFLX", "name": "Netflix Inc."},
    {"symbol": "INTC", "name": "Intel Corp."},
  ];

  // 📌 ดึงราคาหุ้นทีละตัวจาก Finnhub
  Future<Map<String, dynamic>> fetchQuote(String symbol) async {
    final url = Uri.parse("$baseUrl/quote?symbol=$symbol");

    try {
      final response = await http.get(
        url,
        headers: {"X-Finnhub-Token": _apiKey},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // ✅ ดึงข้อมูล
        final currentPrice = data["c"]?.toDouble() ?? 0.0;
        final previousClose = data["pc"]?.toDouble() ?? 0.0;
        
        // ✅ คำนวณ % change เอง (เทียบกับวันก่อน)
        double percentChange = 0.0;
        if (previousClose > 0) {
          percentChange = ((currentPrice - previousClose) / previousClose) * 100;
        }
        
        print("📊 $symbol: Current=$currentPrice, PrevClose=$previousClose, Change=${percentChange.toStringAsFixed(2)}%");
        
        return {
          "symbol": symbol,
          "price": currentPrice,
          "change": percentChange,
        };
      }
    } catch (e) {
      print("❌ Error fetching $symbol: $e");
    }

    return {
      "symbol": symbol,
      "price": 0.0,
      "change": 0.0,
    };
  }

  // 📌 ดึงหุ้นทั้งหมด (เรียก API ทีละตัว)
  Future<List<Map<String, dynamic>>> fetchTrending() async {
    List<Map<String, dynamic>> results = [];

    for (var stock in trendingStocks) {
      final quote = await fetchQuote(stock["symbol"]!);
      results.add({
        "symbol": stock["symbol"],
        "name": stock["name"],
        "price": quote["price"],
        "change": quote["change"],
      });

      // ⏱️ Delay เล็กน้อยเพื่อไม่โดน Rate Limit
      await Future.delayed(const Duration(milliseconds: 300));
    }

    return results;
  }
}