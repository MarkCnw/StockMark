import 'package:stockmark/core/errors/exceptions.dart';
import 'package:stockmark/features/news/data/datasources/news_api_service.dart';
import 'package:stockmark/features/news/data/models/news_model.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  
  final NewsApiService apiService;

  NewsRepositoryImpl(this.apiService);

  @override
  Future<List<NewsEntity>> getNews() async {
    return _getNewsFromApi(() => apiService.fetchNews());
  }

  // ✅ เพิ่มฟังก์ชันนี้ตามที่ Interface สั่งมา
  @override
  Future<List<NewsEntity>> getHotNews() async {
    return _getNewsFromApi(() => apiService.fetchHotNews());
  }

  // Helper function ลดโค้ดซ้ำ
  Future<List<NewsEntity>> _getNewsFromApi(Future<List<dynamic>> Function() apiCall) async {
    try {
      final rawData = await apiCall();
      return rawData.map((item) => NewsModel.fromJson(item)).toList();
    } on ServerException {
      print("⚠️ Server Failure");
      return [];
    } catch (e) {
      print("⚠️ Unknown Error: $e");
      return [];
    }
  }
}