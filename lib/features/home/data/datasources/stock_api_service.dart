import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stockmark/core/errors/exceptions.dart';

class StockApiService {
  // ✅ แก้ URL ให้ถูกต้อง (ลบเว้นวรรคออก)
  final String chartBaseUrl =
      "https://query1.finance.yahoo.com/v8/finance/chart";
  final String quoteBaseUrl =
      "https://query2.finance.yahoo.com/v7/finance/quote";

  Future<Map<String, dynamic>> fetchSP500() async {
    final url = Uri.parse("$chartBaseUrl/SPY?interval=1d&range=1d");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['chart']['result'];

        if (result != null && (result as List).isNotEmpty) {
          final meta = result[0]['meta'];

          final double price =
              (meta['regularMarketPrice'] as num?)?.toDouble() ??
              (meta['chartPreviousClose'] as num?)?.toDouble() ??
              0.0;

          final double prevClose =
              (meta['previousClose'] as num?)?.toDouble() ??
              (meta['chartPreviousClose'] as num?)?.toDouble() ??
              price;

          double change = 0.0;
          if (prevClose > 0) {
            change = ((price - prevClose) / prevClose) * 100;
          }

          return {
            'symbol': 'SPY',
            'shortName': 'SPDR S&P 500 ETF Trust',
            'regularMarketPrice': price,
            'regularMarketChangePercent': change,
          };
        }

        throw const NotFoundException('S&P 500 data not found');
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else {
        throw ServerException(
          'Failed to fetch S&P 500',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const ServerException('Invalid data format');
    }
  }

  Future<List<dynamic>> fetchMostActive() async {
    const symbols =
        "NVDA,TSLA,AAPL,AMZN,MSFT,GOOGL,META,AMD,NFLX,INTC,PLTR,COIN,MSTR";
    final url = Uri.parse("$quoteBaseUrl?symbols=$symbols");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['quoteResponse']['result'] as List<dynamic>;
      } else {
        throw ServerException(
          'Failed to fetch stocks',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException();
    }
  }

  // ✅ เพิ่มฟังก์ชันนี้ครับ: ดึงรายละเอียดหุ้นรายตัว
  Future<Map<String, dynamic>> fetchStockDetail(String symbol) async {
    // ใช้ Quote API เพื่อดึงข้อมูลละเอียด (Open, High, Low, P/E, MarketCap ฯลฯ)
    final url = Uri.parse("$quoteBaseUrl?symbols=$symbol");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['quoteResponse']['result'];

        if (result != null && (result as List).isNotEmpty) {
          // ส่งคืนข้อมูลตัวแรกที่เจอ (เพราะเราค้นแค่ 1 symbol)
          return result[0] as Map<String, dynamic>;
        }
      }
      // ถ้าไม่เจอหรือไม่สำเร็จ ให้โยน Error หรือคืนค่าว่างตามแต่จะออกแบบ
      // ในที่นี้ขอคืนค่าว่างไปก่อนเพื่อให้ Repo จัดการต่อ
    } catch (e) {
      print("❌ Error fetching detail: $e");
    }
    return {}; // คืน Map ว่างถ้ามีปัญหา
  }

  // ✅ เพิ่มฟังก์ชันนี้: ดึงกราฟย้อนหลัง (คืนค่าเป็น List ของราคา)
  Future<List<double>> fetchStockChart(String symbol) async {
    // range=1mo (1 เดือน), interval=1d (วันละจุด)
    final url = Uri.parse("$chartBaseUrl/$symbol?range=1mo&interval=1d");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['chart']['result'];

        if (result != null && (result as List).isNotEmpty) {
          final quote = result[0]['indicators']['quote'][0];

          // ดึงเฉพาะราคาปิด (close) มาใส่ List
          if (quote['close'] != null) {
            // กรองค่า null ออก (บางวันตลาดปิดหรือข้อมูลแหว่ง)
            final List<dynamic> closes = quote['close'];
            return closes
                .where((price) => price != null)
                .map((price) => (price as num).toDouble())
                .toList();
          }
        }
      }
    } catch (e) {
      print("❌ Error fetching chart: $e");
    }
    return []; // คืนค่าว่างถ้ามีปัญหา
  }

  // ✅ เพิ่มฟังก์ชันนี้: ดึงคำอธิบายบริษัท (About)
  Future<String> fetchCompanyAbout(String symbol) async {
    // ใช้ endpoint พิเศษชื่อ quoteSummary และขอ module 'assetProfile'
    final url = Uri.parse(
      "https://query2.finance.yahoo.com/v10/finance/quoteSummary/$symbol?modules=assetProfile"
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        // แกะกล่อง JSON ที่ซับซ้อนเพื่อเอา text ออกมา
        final result = json['quoteSummary']['result'];
        if (result != null && (result as List).isNotEmpty) {
          return result[0]['assetProfile']['longBusinessSummary'] ?? 'No description available.';
        }
      }
    } catch (e) {
      print("About Error: $e");
    }
    
    return "No description available."; // ถ้าหาไม่เจอให้คืนค่า default
  }
}
