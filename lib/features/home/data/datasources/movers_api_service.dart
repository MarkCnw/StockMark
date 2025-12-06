import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:stockmark/core/errors/exceptions.dart';

class MoversApiService {
  // ✅ แก้ไข: ใช้ static const ไม่มี space
  static const String _baseUrl = "https://query2.finance.yahoo.com/v1/finance/screener/predefined/saved";

  /// Fetch top gainers
  Future<List<dynamic>> fetchGainers() async {
    return _fetchFromYahoo("day_gainers");
  }

  /// Fetch top losers
  Future<List<dynamic>> fetchLosers() async {
    return _fetchFromYahoo("day_losers");
  }

  /// Fetch trending/most active stocks
  Future<List<dynamic>> fetchTrending() async {
    return _fetchFromYahoo("most_actives");
  }

  /// Generic fetch from Yahoo Finance Screener
  Future<List<dynamic>> _fetchFromYahoo(String type) async {
    // ✅ แก้ไข: ใช้ static const
    final url = Uri. parse("$_baseUrl?scrIds=$type&count=10&lang=en-US&region=US");

    try {
      debugPrint("🌐 Fetching $type from: $url");

      final response = await http.get(url). timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw const NetworkException('Connection timeout');
        },
      );

      debugPrint("📡 $type response status: ${response. statusCode}");

      switch (response. statusCode) {
        case 200:
          return _parseResponse(response.body, type);
        case 401:
          throw const UnauthorizedException();
        case 404:
          throw NotFoundException('$type data not found');
        case 429:
          throw const ServerException('Too many requests.  Please try again later.');
        case 500:
        case 502:
        case 503:
          throw ServerException(
            'Server is temporarily unavailable',
            statusCode: response. statusCode,
          );
        default:
          throw ServerException(
            'Failed to fetch $type',
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

  /// Parse Yahoo Finance response
  List<dynamic> _parseResponse(String body, String type) {
    final json = jsonDecode(body);

    final finance = json['finance'];
    if (finance == null) {
      throw ServerException('Invalid response format for $type');
    }

    final result = finance['result'];
    if (result == null || result.isEmpty) {
      throw NotFoundException('$type data not found');
    }

    final quotes = result[0]['quotes'];
    if (quotes == null) {
      throw NotFoundException('$type quotes not found');
    }

    debugPrint("✅ Parsed ${(quotes as List).length} $type stocks");
    return quotes;
  }
}