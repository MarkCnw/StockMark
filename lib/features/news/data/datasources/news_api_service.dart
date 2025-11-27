import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:stockmark/core/errors/exceptions.dart';

class NewsApiService {
  // ✅ ใช้ Search API แทน News API (เสถียรกว่า)
  // q=market คือค้นหาข่าวเกี่ยวกับตลาดหุ้นทั่วไป
  final String _baseUrl =
      "https://query1.finance.yahoo.com/v1/finance/search";

  // 1. ดึงข่าวทั่วไป (20 ข่าว)
  // 1. ดึงข่าวทั่วไป (เปลี่ยน q=market เป็น q=finance หรือ q=aapl)
  Future<List<dynamic>> fetchNews() async {
    // ลองเปลี่ยนคำค้นหาดูครับ
    return _fetchData("$_baseUrl?q=finance&newsCount=20");
  }

  // 2. ดึงข่าวร้อน (5 ข่าว) - เช่นข่าว Tech
  Future<List<dynamic>> fetchHotNews() async {
    return _fetchData("$_baseUrl?q=tech&newsCount=5");
  }

  // ฟังก์ชันกลาง
  Future<List<dynamic>> _fetchData(String url) async {
    try {
      print("🚀 Fetching: $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "User-Agent":
              "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        if (json['news'] != null) {
          final List data = json['news'];
          print(
            "✅ ได้ข่าวมาทั้งหมด: ${data.length} ข่าว",
          ); // เช็คจำนวนตรงนี้
          if (data.isNotEmpty) {
            print("ตัวอย่างข่าวแรก: ${data[0]['title']}"); // เช็คเนื้อหา
          }
          return data;
        }

        print("⚠️ ไม่พบ key 'news' ใน JSON");
        return [];
      } else {
        throw ServerException('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ API Error: $e");
      throw ServerException(e.toString());
    }
  }
}
