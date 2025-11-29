import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stockmark/core/errors/exceptions.dart';

class StockApiService {
  final String chartBaseUrl = "https://query1. finance.yahoo.com/v8/finance/chart";
  final String quoteBaseUrl = "https://query2.finance.yahoo.com/v7/finance/quote";

  Future<Map<String, dynamic>> fetchSP500() async {
    final url = Uri.parse("$chartBaseUrl/SPY? interval=1d&range=1d");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final result = json['chart']['result'];

        if (result != null && result.isNotEmpty) {
          final meta = result[0]['meta'];
          
          final double price = (meta['regularMarketPrice'] as num?)?.toDouble() ?? 
                               (meta['chartPreviousClose'] as num?)?.toDouble() ?? 
                               0.0;
                               
          final double prevClose = (meta['previousClose'] as num?)?.toDouble() ?? 
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
        
        // ✅ ไม่มีข้อมูล
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
    const symbols = "NVDA,TSLA,AAPL,AMZN,MSFT,GOOGL,META,AMD,NFLX,INTC,PLTR,COIN,MSTR";
    final url = Uri.parse("$quoteBaseUrl? symbols=$symbols");

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return json['quoteResponse']['result'] as List<dynamic>;
      } else {
        throw ServerException(
          'Failed to fetch stocks',
          statusCode: response. statusCode,
        );
      }
    } on SocketException {
      throw const NetworkException();
    }
  }
}