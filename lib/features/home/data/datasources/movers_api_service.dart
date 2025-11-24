import 'dart:convert';
import 'package:http/http.dart' as http;

class MoversApiService {
  // ✅ ไม่ต้องใช้ API Key แล้ว! (Yahoo ใจป้ำ)
  final String baseUrl = "https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved";

  Future<List<dynamic>> fetchTrending() async {
    // scrIds=most_actives คือดึงหุ้นที่มีการซื้อขายสูงสุด (Trending ตัวจริง)
    // count=10 คือเอา 10 ตัว
    final url = Uri.parse("$baseUrl?scrIds=most_actives&count=10&lang=en-US&region=US");
    
    return _fetchData(url);
  }

  Future<List<dynamic>> _fetchData(Uri url) async {
    try {
      print("🚀 Sending to Yahoo: $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // ⚠️ โครงสร้าง Yahoo ซับซ้อนนิดนึง: finance -> result -> [0] -> quotes
        final quotes = json['finance']['result'][0]['quotes'];
        return quotes as List<dynamic>;
      } else {
        print("❌ Error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("API Error: $e");
      return [];
    }
  }
}