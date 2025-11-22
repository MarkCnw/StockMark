import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MoversApiService {
  final String _apiKey = dotenv.env['FMP_KEY'] ?? '';
  final String baseUrl = "https://financialmodelingprep.com/api/v3";

  Future<List<dynamic>> fetchTrending() async {
    // 💡 ไม้ตาย: ระบุชื่อหุ้นดังๆ เองเลย (Big Tech & Popular)
    // วิธีนี้ฟรีแน่นอน และข้อมูลดูดีด้วย เพราะเป็นหุ้นที่คนรู้จัก
    const symbols = "AAPL,NVDA,TSLA,AMZN,MSFT,GOOGL,META,AMD,NFLX,INTC,COIN";
    
    final url = Uri.parse("$baseUrl/quote/$symbols?apikey=$_apiKey");
    return _fetchData(url);
  }

  Future<List<dynamic>> _fetchData(Uri url) async {
    try {
      print("🚀 Sending: $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as List<dynamic>;
      } else {
        print("❌ Error: ${response.statusCode} ${response.body}");
        return [];
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
}