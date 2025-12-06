import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stockmark/core/errors/exceptions.dart';

class StockApiService {
  // ✅ แก้ไข: ลบ space ออกจาก URL
  static const String _chartBaseUrl =
      "https://query1.finance.yahoo.com/v8/finance/chart";
  static const String _quoteBaseUrl =
      "https://query2.finance.yahoo. com/v7/finance/quote";

  /// Fetch S&P 500 data
  Future<Map<String, dynamic>> fetchSP500() async {
    // ✅ แก้ไข: ใช้ static const แทน
    final url = Uri.parse("$_chartBaseUrl/SPY? interval=1d&range=1d");

    try {
      debugPrint("🌐 Fetching S&P 500 from: $url");

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw const NetworkException('Connection timeout');
            },
          );

      debugPrint("📡 Response status: ${response.statusCode}");

      switch (response.statusCode) {
        case 200:
          return _parseSP500Response(response.body);
        case 401:
          throw const UnauthorizedException();
        case 404:
          throw const NotFoundException('S&P 500 data not found');
        case 429:
          throw const ServerException(
            'Too many requests.  Please try again later.',
          );
        case 500:
        case 502:
        case 503:
          throw ServerException(
            'Server is temporarily unavailable',
            statusCode: response.statusCode,
          );
        default:
          throw ServerException(
            'Failed to fetch S&P 500: ${response.statusCode}',
            statusCode: response.statusCode,
          );
      }
    } on SocketException catch (e) {
      debugPrint("❌ SocketException: $e");
      throw const NetworkException();
    } on FormatException catch (e) {
      debugPrint("❌ FormatException: $e");
      throw const ServerException('Invalid data format');
    } on http.ClientException catch (e) {
      debugPrint("❌ ClientException: $e");
      throw const NetworkException();
    } catch (e) {
      debugPrint("❌ Unknown error: $e");
      rethrow;
    }
  }

  /// Parse S&P 500 response
  Map<String, dynamic> _parseSP500Response(String body) {
    try {
      final json = jsonDecode(body);
      final result = json['chart']?['result'];

      if (result == null || result.isEmpty) {
        debugPrint("❌ No result in response");
        throw const NotFoundException('S&P 500 data not found');
      }

      final meta = result[0]['meta'];

      if (meta == null) {
        debugPrint("❌ No meta in response");
        throw const ServerException('Invalid response format');
      }

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

      debugPrint(
        "✅ Parsed: Price=\$${price.toStringAsFixed(2)}, Change=${change.toStringAsFixed(2)}%",
      );

      return {
        'symbol': 'SPY',
        'shortName': 'SPDR S&P 500 ETF Trust',
        'regularMarketPrice': price,
        'regularMarketChangePercent': change,
      };
    } catch (e) {
      debugPrint("❌ Parse error: $e");
      rethrow;
    }
  }

  /// Fetch most active stocks
  Future<List<dynamic>> fetchMostActive() async {
    const symbols =
        "NVDA,TSLA,AAPL,AMZN,MSFT,GOOGL,META,AMD,NFLX,INTC,PLTR,COIN,MSTR";
    // ✅ แก้ไข: ใช้ static const
    final url = Uri.parse("$_quoteBaseUrl? symbols=$symbols");

    try {
      debugPrint("🌐 Fetching stocks from: $url");

      final response = await http
          .get(url)
          .timeout(
            const Duration(seconds: 15),
            onTimeout: () {
              throw const NetworkException('Connection timeout');
            },
          );

      debugPrint("📡 Response status: ${response.statusCode}");

      switch (response.statusCode) {
        case 200:
          final json = jsonDecode(response.body);
          final result = json['quoteResponse']?['result'];

          if (result == null) {
            throw const NotFoundException('Stock data not found');
          }

          debugPrint("✅ Fetched ${(result as List).length} stocks");
          return result;
        case 401:
          throw const UnauthorizedException();
        case 404:
          throw const NotFoundException('Stock data not found');
        default:
          throw ServerException(
            'Failed to fetch stocks',
            statusCode: response.statusCode,
          );
      }
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const ServerException('Invalid data format');
    } on http.ClientException {
      throw const NetworkException();
    }
  }
}
