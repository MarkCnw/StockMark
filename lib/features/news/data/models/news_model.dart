import 'package:stockmark/features/news/domain/entities/news_entity.dart';

class NewsModel extends NewsEntity {
  NewsModel({
    required super.id,
    required super.title,
    required super.imageUrl,
    required super.source, // ✅ เปลี่ยนจาก category เป็น source
    required super.sourceLogoUrl, // ✅ เพิ่มตัวนี้
    required super.timeAgo,
    required super.url,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    // 1. ดึงรูปภาพ (เหมือนเดิม)
    String imgUrl = '';
    if (json['thumbnail'] != null &&
        json['thumbnail']['resolutions'] != null &&
        (json['thumbnail']['resolutions'] as List).isNotEmpty) {
      final resolutions = json['thumbnail']['resolutions'] as List;
      imgUrl = resolutions.length > 1
          ? resolutions[1]['url']
          : resolutions[0]['url'];
    }

    // 2. แปลงเวลา (เหมือนเดิม)
    String timeAgoStr = '';
    if (json['providerPublishTime'] != null) {
      final int timestamp = json['providerPublishTime'];
      final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      final diff = DateTime.now().difference(date);

      if (diff.inMinutes < 60) {
        timeAgoStr = "${diff.inMinutes}m ago";
      } else if (diff.inHours < 24) {
        timeAgoStr = "${diff.inHours}h ago";
      } else {
        timeAgoStr = "${diff.inDays}d ago";
      }
    }

    // 3. ดึงชื่อสำนักข่าว (Publisher)
    String sourceName = json['publisher'] ?? 'News';

    return NewsModel(
      id: json['uuid'] ?? '',
      title: json['title'] ?? 'No Title',
      imageUrl: imgUrl.isNotEmpty
          ? imgUrl
          : 'https://via.placeholder.com/200',

      // ✅ Map ข้อมูลใหม่
      source: sourceName,
      // 💡 ใช้บริการฟรี ui-avatars สร้างโลโก้จากตัวอักษรแรกของชื่อสำนักข่าว
      sourceLogoUrl:
          'https://ui-avatars.com/api/?name=$sourceName&background=random&color=fff&size=128',

      timeAgo: timeAgoStr,
      url: json['link'] ?? 'https://finance.yahoo.com',
    );
  }
}
