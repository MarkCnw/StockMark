import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  // URL สำหรับดึงราคา S&P 500
  final String quoteBaseUrl = "https://query2.finance.yahoo.com/v7/finance/quote";
  
  // URL สำหรับดึงรายการหุ้น (Most Active)
  final String screenerBaseUrl = "https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved";

  // 1. ฟังก์ชันดึง S&P 500 (ตัวเดิมที่คุณใช้อยู่)
  Future<Map<String, dynamic>> fetchSP500() async {
    final url = Uri.parse("$quoteBaseUrl?symbols=%5EGSPC"); 

    try {
      print("🚀 Fetching S&P 500 (Yahoo): $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['quoteResponse']['result'];

        if (result != null && (result as List).isNotEmpty) {
          return result[0] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("❌ Exception: $e");
    }

    return {
      'symbol': '^GSPC',
      'shortName': 'S&P 500',
      'regularMarketPrice': 0.0,
      'regularMarketChangePercent': 0.0,
    };
  }

  // 2. ✅ เพิ่มฟังก์ชันนี้กลับเข้าไป (แก้ Error Undefined Method)
  Future<List<dynamic>> fetchMostActive() async {
    // ใช้ Yahoo Screener ดึงหุ้น Most Actives ฟรีๆ
    final url = Uri.parse("$screenerBaseUrl?scrIds=most_actives&count=20&lang=en-US&region=US");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final quotes = json['finance']['result'][0]['quotes'];
        return quotes as List<dynamic>;
      }
    } catch (e) {
      print("Error fetching most active: $e");
    }
    return [];
  }
}