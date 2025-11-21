import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MoversApiService {
  final String _apiKey = dotenv.env['ALPHA_VANTAGE_KEY'] ?? '';
  final String baseUrl = "https://www.alphavantage.co/query";

  Future<List<dynamic>> fetchTopGainers() async {
    final url = Uri.parse(
      "$baseUrl?function=TOP_GAINERS_LOSERS&apikey=$_apiKey",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to fetch movers");
    }

    final decoded = jsonDecode(response.body);

    return decoded["top_gainers"] ?? [];
  }
}
