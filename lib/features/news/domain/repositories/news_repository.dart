import 'package:stockmark/features/news/domain/entities/news_entity.dart';

abstract class NewsRepository {
  Future<List<NewsEntity>> getNews();
}
