import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class StockApiService {
  final String _apiKey = dotenv.env['FINNHUB_API_KEY'] ?? '';
  final String baseUrl = "https://finnhub.io/api/v1";

  // 📌 ดึงหุ้น 10 อันดับ (ตัวอย่าง: Most Active ยังไม่มี API ตรงตัว ต้องเลือก symbol เอง)
  Future<List<dynamic>> fetchMostActive() async {
    final url = Uri.parse(
      "$baseUrl/stock/symbol?exchange=US",
    );

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

  // 📌 ดึงราคาหุ้นแบบ simple
  Future<double> fetchPrice(String symbol) async {
    final url = Uri.parse(
      "$baseUrl/quote?symbol=$symbol",
    );

    final response = await http.get(
      url,
      headers: {"X-Finnhub-Token": _apiKey},
    );

    final decoded = jsonDecode(response.body);

    return decoded["c"] * 1.0; // c = current price
  }
}
