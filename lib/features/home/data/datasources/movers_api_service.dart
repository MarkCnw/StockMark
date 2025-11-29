import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stockmark/core/errors/exceptions.dart';

class MoversApiService {
  final String baseUrl =
      "https://query2. finance.yahoo.com/v1/finance/screener/predefined/saved";

  Future<List<dynamic>> fetchGainers() async {
    return _fetchFromYahoo("day_gainers");
  }

  Future<List<dynamic>> fetchLosers() async {
    return _fetchFromYahoo("day_losers");
  }

  Future<List<dynamic>> fetchTrending() async {
    return _fetchFromYahoo("most_actives");
  }

  Future<List<dynamic>> _fetchFromYahoo(String type) async {
    final url = Uri.parse(
      "$baseUrl?scrIds=$type&count=10&lang=en-US&region=US",
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['finance']? ['result'];
        
        if (result == null || result.isEmpty) {
          throw NotFoundException('No $type data available');
        }
        
        return result[0]['quotes'] as List<dynamic>;
      } else if (response.statusCode == 401) {
        throw const UnauthorizedException();
      } else if (response.statusCode == 404) {
        throw const NotFoundException();  // ✅ แก้ไขแล้ว
      } else {
        throw ServerException(
          'Server error ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException();
    } on FormatException {
      throw const ServerException('Invalid data format');
    }
  }
}