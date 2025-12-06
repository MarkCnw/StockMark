import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stockmark/features/home/data/datasources/stock_api_service.dart';

import 'package:stockmark/features/home/data/models/stock_model.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/repositories/stock_repository.dart';

class StockRepositoryImpl implements StockRepository {
  final StockApiService api;

  StockRepositoryImpl(this.api);

  @override
  Future<List<StockEntity>> getStocks() async {
    try {
      final data = await api.fetchMostActive();
      return data.map((item) {
        final model = StockModel.fromJson(item);
        return StockEntity(
          symbol: model.symbol,
          name: model.name,
          price: model.price,
          change: model.change,
        );
      }).toList();
    } catch (e) {
      debugPrint("❌ getStocks error: $e");
      rethrow;
    }
  }

  @override
  Future<StockEntity> getSP500Daily() async {
    final prefs = await SharedPreferences.getInstance();
    final String todayDate = DateTime.now().toIso8601String().split(
      'T',
    )[0];

    final String? lastFetchDate = prefs.getString('sp500_date_v3');
    final String? cachedData = prefs.getString('sp500_data_v3');

    // 1. ลองใช้ Cache ก่อน
    if (lastFetchDate == todayDate && cachedData != null) {
      try {
        final jsonMap = jsonDecode(cachedData);
        final model = StockModel.fromJson(jsonMap);

        if (model.price > 0.1) {
          debugPrint("📦 Using cached S&P 500 data");
          return _mapToEntity(model);
        }
      } catch (e) {
        debugPrint("⚠️ Cache corrupted, fetching new data");
      }
    }

    // 2.  Fetch ใหม่จาก API
    debugPrint("🌐 Fetching new S&P 500 data");
    try {
      final apiData = await api.fetchSP500();
      final model = StockModel.fromJson(apiData);

      // Save to cache
      if (model.price > 0.1) {
        await prefs.setString('sp500_date_v3', todayDate);
        await prefs.setString('sp500_data_v3', jsonEncode(apiData));
        debugPrint("💾 Saved to cache");
      }

      return _mapToEntity(model);
    } catch (e) {
      debugPrint("❌ API failed: $e");

      // 3. Fallback to cache if API fails
      if (cachedData != null) {
        debugPrint("📦 Using old cache as fallback");
        final jsonMap = jsonDecode(cachedData);
        return _mapToEntity(StockModel.fromJson(jsonMap));
      }

      rethrow;
    }
  }

  StockEntity _mapToEntity(StockModel model) {
    return StockEntity(
      symbol: model.symbol,
      name: model.name,
      price: model.price,
      change: model.change,
    );
  }

  @override
  Future<List<StockEntity>> searchStocks(String query) async {
    return [];
  }
}
