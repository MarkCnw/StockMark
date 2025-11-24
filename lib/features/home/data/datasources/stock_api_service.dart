import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  // ✅ ใช้ URL ตัวนี้ตัวเดียวหากินได้ทั้งแอพ (ไม่โดนบล็อก)
  final String quoteBaseUrl =
      "https://query2.finance.yahoo.com/v7/finance/quote";

  // 1. ฟังก์ชันดึง S&P 500 (เหมือนเดิม)
  Future<Map<String, dynamic>> fetchSP500() async {
    final url = Uri.parse("$quoteBaseUrl?symbols=%5EGSPC");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['quoteResponse']['result'];
        if (result != null && (result as List).isNotEmpty) {
          return result[0] as Map<String, dynamic>;
        }
      }
    } catch (e) {
      print("❌ Exception S&P500: $e");
    }
    return {}; // ส่งค่าว่างไปก่อน (เดี๋ยว Repository จัดการต่อ)
  }

  // 2. ✅ แก้ฟังก์ชันนี้ใหม่: ใช้ Quote แทน Screener
  Future<List<dynamic>> fetchMostActive() async {
    // รายชื่อหุ้น Tech & Popular ที่คนไทยชอบเทรด (เพิ่มลดได้ตามใจชอบ)
    const symbols =
        "NVDA,TSLA,AAPL,AMZN,MSFT,GOOGL,META,AMD,NFLX,INTC,PLTR,COIN,MSTR";

    // ยิงทีเดียวได้ครบทุกตัว (Yahoo ใจดี ให้ยิงแบบนี้ได้ฟรีๆ)
    final url = Uri.parse("$quoteBaseUrl?symbols=$symbols");

    try {
      print("🚀 Fetching Trending (Yahoo Quote): $url");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['quoteResponse']['result'];
        return result as List<dynamic>;
      } else {
        print("❌ Error Trending: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching trending: $e");
    }
    return [];
  }
}
