import 'package:stockmark/features/news/domain/entities/news_entity.dart';

/// News Detail Entity - ข้อมูลรายละเอียดข่าว
class NewsDetailEntity {
  // ===== ข้อมูลพื้นฐาน =====
  final String id;
  final String title;
  final String imageUrl;
  final String content;
  final String? quote;

  // ===== Source Info =====
  final String sourceName;
  final String sourceLogo;
  final String publishedAt;
  final String readTime;

  // ===== Tags =====
  final List<String> tags;

  // ===== Related Data =====
  final List<String> relatedStockSymbols;

  // ===== Stats =====
  final int likeCount;
  final int commentCount;
  final bool isHot;
  final bool isBookmarked;

  // ===== Constructor =====
  const NewsDetailEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.content,
    this.quote,
    required this.sourceName,
    required this.sourceLogo,
    required this.publishedAt,
    required this.readTime,
    this.tags = const [],
    this.relatedStockSymbols = const [],
    this.likeCount = 0,
    this.commentCount = 0,
    this.isHot = false,
    this.isBookmarked = false,
  });

  // ===== Factory: สร้างจาก NewsEntity =====
  factory NewsDetailEntity.fromNewsEntity(
    NewsEntity news, {
    String? content,
    String? quote,
    List<String>? tags,
    List<String>? relatedStockSymbols,
    int likeCount = 0,
    int commentCount = 0,
    bool isHot = false,
  }) {
    return NewsDetailEntity(
      id: news.id,
      title: news.title,
      imageUrl: news.imageUrl,
      content: content ?? '',
      quote: quote,
      sourceName: news.source, // ✅ แก้ไข
      sourceLogo: news.sourceLogoUrl, // ✅ แก้ไข
      publishedAt: news.timeAgo, // ✅ แก้ไข
      readTime: '5 min read',
      tags: tags ?? [],
      relatedStockSymbols: relatedStockSymbols ?? [],
      likeCount: likeCount,
      commentCount: commentCount,
      isHot: isHot, // ✅ รับจาก parameter
      isBookmarked: false,
    );
  }

  // ===== CopyWith =====
  NewsDetailEntity copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? content,
    String? quote,
    String? sourceName,
    String? sourceLogo,
    String? publishedAt,
    String? readTime,
    List<String>? tags,
    List<String>? relatedStockSymbols,
    int? likeCount,
    int? commentCount,
    bool? isHot,
    bool? isBookmarked,
  }) {
    return NewsDetailEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      content: content ?? this.content,
      quote: quote ?? this.quote,
      sourceName: sourceName ?? this.sourceName,
      sourceLogo: sourceLogo ?? this.sourceLogo,
      publishedAt: publishedAt ?? this.publishedAt,
      readTime: readTime ?? this.readTime,
      tags: tags ?? this.tags,
      relatedStockSymbols: relatedStockSymbols ?? this.relatedStockSymbols,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
      isHot: isHot ?? this.isHot,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  // ===== Getters =====

  String get formattedLikeCount {
    if (likeCount >= 1000) {
      return '${(likeCount / 1000).toStringAsFixed(1)}K';
    }
    return likeCount.toString();
  }

  String get formattedCommentCount {
    if (commentCount >= 1000) {
      return '${(commentCount / 1000).toStringAsFixed(1)}K';
    }
    return commentCount.toString();
  }

  bool get hasQuote => quote != null && quote!.isNotEmpty;

  bool get hasRelatedStocks => relatedStockSymbols.isNotEmpty;
}
