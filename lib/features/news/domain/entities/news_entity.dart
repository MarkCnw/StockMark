// ignore_for_file: public_member_api_docs, sort_constructors_first
class NewsEntity {
  final String id;
  final String title; // หัวข้อข่าว
  final String imageUrl; // รูปภาพด้านซ้าย
  final String source; // หมวดหมู่ (Cloud, Finance)
  final String sourceLogoUrl; // รูปโลโก้สำนักข่าว
  final String timeAgo;

  NewsEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.source,
    required this.sourceLogoUrl,
    required this.timeAgo,
  });
}
