import 'dart:convert';
import 'package:http/http.dart' as http;

class MoversApiService {
  final String baseUrl = "https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved";

  // 1. ดึงหุ้นบวก (Gainers)
  Future<List<dynamic>> fetchGainers() async {
    return _fetchFromYahoo("day_gainers");
  }

  // 2. ดึงหุ้นลบ (Losers)
  Future<List<dynamic>> fetchLosers() async {
    return _fetchFromYahoo("day_losers");
  }

  // 3. ดึงหุ้นฮิต (Trending/Most Actives)
  Future<List<dynamic>> fetchTrending() async {
    return _fetchFromYahoo("most_actives");
  }

  Future<List<dynamic>> _fetchFromYahoo(String type) async {
    final url = Uri.parse("$baseUrl?scrIds=$type&count=10&lang=en-US&region=US");
    try {
      print("🚀 Yahoo Fetching: $type");
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // โครงสร้าง Yahoo Screener
        return json['finance']['result'][0]['quotes'] as List<dynamic>;
      }
    } catch (e) {
      print("Error fetching $type: $e");
    }
    return [];
  }
}