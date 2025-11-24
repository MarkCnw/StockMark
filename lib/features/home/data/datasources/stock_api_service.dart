import 'dart:convert';
import 'package:http/http.dart' as http;

class StockApiService {
  // ✅ ใช้ URL ของ Yahoo Finance (ตัวเดียวกับ Trending)
  final String quoteBaseUrl =
      "https://query2.finance.yahoo.com/v7/finance/quote";

  // URL สำหรับดึงรายการหุ้น (Most Active)
  final String screenerBaseUrl =
      "https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved";

  // 1. ฟังก์ชันดึง S&P 500 (ต้นเหตุที่ราคาเป็น 0)
  Future<Map<String, dynamic>> fetchSP500() async {
    final url = Uri.parse("$quoteBaseUrl?symbols=%5EGSPC");

    try {
      print("🚀 Fetching S&P 500 (Yahoo): $url");

      // ✅ เพิ่ม headers เพื่อหลอก Yahoo ว่าเราคือคน (User-Agent)
      final response = await http.get(
        url,
        headers: {
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
          "Accept": "application/json",
        },
      );

      print(
        "📡 Status Code: ${response.statusCode}",
      ); // ดูว่าตอบอะไรกลับมา

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['quoteResponse']['result'];

        if (result != null && (result as List).isNotEmpty) {
          final data = result[0];
          print(
            "✅ Yahoo S&P 500 Data: ${data['regularMarketPrice']}",
          ); // ถ้าขึ้นบรรทัดนี้ คือรอด!
          return data as Map<String, dynamic>;
        } else {
          print("⚠️ Result is empty");
        }
      } else {
        print("❌ Yahoo Error: ${response.body}");
      }
    } catch (e) {
      print("❌ Exception S&P 500: $e");
    }

    // ถ้าพัง ส่งค่า 0 ไปก่อน
    return {
      'symbol': '^GSPC',
      'shortName': 'S&P 500',
      'regularMarketPrice': 0.0,
      'regularMarketChangePercent': 0.0,
    };
  }

  // 2. ฟังก์ชันดึง Most Active (อันนี้ใช้ได้อยู่แล้ว แต่อย่าลืมใส่ไว้กัน Error)กฟไกฟกฟกฟไกฟกฟก
  Future<List<dynamic>> fetchMostActive() async {
    // ใช้รายชื่อหุ้นดัง (Quote) แทน Screener เพื่อความชัวร์
    const symbols =
        "NVDA,TSLA,AAPL,AMZN,MSFT,GOOGL,META,AMD,NFLX,INTC,PLTR,COIN,MSTR";
    final url = Uri.parse("$quoteBaseUrl?symbols=$symbols");

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['quoteResponse']['result'] as List<dynamic>;
      }
    } catch (e) {
      print("Error fetching trending: $e");
    }
    return [];
  }
}
