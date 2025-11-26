import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';

import 'package:stockmark/features/news/presentation/providers/new_provider.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewProvider>().loadNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Market News',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Consumer<NewProvider>(
        builder: (context, provider, child) {
          // 1. ถ้ากำลังโหลด -> หมุนติ้วๆ
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. ถ้าไม่มีข้อมูล -> บอกว่าว่างเปล่า
          if (provider.news.isEmpty) {
            return const Center(child: Text('No news available'));
          }

          // 3. ถ้ามีข้อมูล -> โชว์รายการข่าว
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: provider.news.length,
            // เส้นคั่นบางๆ ระหว่างแต่ละข่าว
            separatorBuilder: (context, index) => Divider(
              height: 32,
              thickness: 0.5,
              color: Colors.grey[300],
            ),
            itemBuilder: (context, index) {
              final newsItem = provider.news[index];
              return _NewsCard(news: newsItem);
            },
          );
        },
      ),
    );
  }
}

// Widget การ์ดข่าว
class _NewsCard extends StatelessWidget {
  final NewsEntity news;

  const _NewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🟢 ส่วนข้อความ (ด้านซ้าย)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. หัวข้อข่าว (ย้ายขึ้นมาบน)
                Text(
                  news.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),

                // 2. โลโก้สำนักข่าว + ชื่อ + เวลา (ย้ายลงมาล่าง)
                Row(
                  children: [
                    _buildSourceTag(
                      context,
                      news.source,
                      news.sourceLogoUrl,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      news.timeAgo,
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // 🖼️ ส่วนรูปภาพข่าว (ด้านขวา)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              news.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🏷️ Widget แสดงโลโก้ + ชื่อสำนักข่าว
  Widget _buildSourceTag(
    BuildContext context,
    String sourceName,
    String logoUrl,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🖼️ โลโก้สำนักข่าว (วงกลม)
        ClipOval(
          child: Image.network(
            logoUrl,
            width: 25,
            height: 25,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // ถ้าโหลดโลโก้ไม่ได้ แสดงไอคอนแทน
              return Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.newspaper,
                  size: 10,
                  color: Colors.grey[600],
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 6),

        // 📝 ชื่อสำนักข่าว
        Text(
          sourceName,
          style: TextStyle(
            color: Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
