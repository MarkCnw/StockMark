import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StockApiService {
  final String _apiKey = dotenv.env['FINNHUB_API_KEY'] ?? '';
  final String baseUrl = "https://finnhub.io/api/v1";

  // 📌 ดึงหุ้น 10 อันดับ (ตัวอย่าง: Most Active ยังไม่มี API ตรงตัว ต้องเลือก symbol เอง)
  Future<List<dynamic>> fetchMostActive() async {
    final url = Uri.parse("$baseUrl/stock/symbol?exchange=US");

    final response = await http.get(
      url,
      headers: {"X-Finnhub-Token": _apiKey},
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load stocks");
    }

    final List data = jsonDecode(response.body);

    // 📌 ตัวอย่าง: เอาแค่ 10 ตัวแรก
    return data.take(10).toList();
  }

  Future<Map<String, dynamic>> fetchSP500() async {
    // ใช้ symbol '^GSPC' สำหรับ S&P 500 Index (หรือ 'SPY' ถ้าตัวนี้ไม่ขึ้น)
    final url = Uri.parse(
      "$baseUrl/quote/%5EGSPC?apikey=$_apiKey",
    ); // %5E คือเครื่องหมาย ^

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final item = data.first;
          return {
            'symbol': 'S&P 500',
            'name': 'Standard & Poor\'s 500',
            'price': (item['price'] as num).toDouble(),
            'change': (item['changesPercentage'] as num)
                .toDouble(), // FMP ใช้ key นี้
          };
        }
      }
    } catch (e) {
      print("Error fetching S&P 500: $e");
    }

    // ถ้าพลาด ให้ส่งค่า 0 กลับไปก่อน (จะได้ไม่แดง)
    return {
      'symbol': 'S&P 500',
      'name': 'Standard & Poor\'s 500',
      'price': 0.0,
      'change': 0.0,
    };
  }

  // 📌 ดึงราคาหุ้นแบบ simple
  Future<double> fetchPrice(String symbol) async {
    final url = Uri.parse("$baseUrl/quote?symbol=$symbol");

    final response = await http.get(
      url,
      headers: {"X-Finnhub-Token": _apiKey},
    );

    final decoded = jsonDecode(response.body);

    return decoded["c"] * 1.0; // c = current price
  }
}
