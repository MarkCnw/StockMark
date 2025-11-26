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

    WidgetsBinding. instance.addPostFrameCallback((_) {
      // โหลดทั้ง News และ Hot News
      context.read<NewProvider>().loadAllNews();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context). brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Market News',
          style: TextStyle(
            fontWeight: FontWeight. bold,
            color: isDark ? Colors.white : Colors. black,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: isDark ?  const Color(0xFF121212) : Colors. grey[50],
      ),
      body: Consumer<NewProvider>(
        builder: (context, provider, child) {
          // 1. ถ้ากำลังโหลด -> หมุนติ้วๆ
          if (provider.isLoading && provider.isHotNewsLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: isDark ? Colors.white : Colors.blue,
              ),
            );
          }

          // 2.  ถ้าไม่มีข้อมูล -> บอกว่าว่างเปล่า
          if (provider.news.isEmpty && provider. hotNews.isEmpty) {
            return Center(
              child: Text(
                'No news available',
                style: TextStyle(
                  color: isDark ? Colors. grey[400] : Colors.grey[600],
                ),
              ),
            );
          }

          // 3.  ถ้ามีข้อมูล -> โชว์รายการข่าว
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔥 ส่วน Hot News (เลื่อนแนวนอน)
                if (provider.hotNews.isNotEmpty) ...[
                  _buildHotNewsSection(context, provider.hotNews, isDark),
                  const SizedBox(height: 16),
                ],

                // 📰 ส่วน Latest News (รายการปกติ)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Latest News',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors. white : Colors.grey[800],
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // รายการข่าวปกติ
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount: provider.news.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 32,
                    thickness: 0.5,
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                  ),
                  itemBuilder: (context, index) {
                    final newsItem = provider.news[index];
                    return _NewsCard(news: newsItem);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // 🔥 Section Hot News แนวนอน
  Widget _buildHotNewsSection(
    BuildContext context,
    List<NewsEntity> hotNews,
    bool isDark,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // หัวข้อ Hot News
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
          child: Row(
            children: [
              const Text(
                '🔥',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(width: 8),
              Text(
                'Hot News',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight. bold,
                  color: isDark ?  Colors.white : Colors.grey[800],
                ),
              ),
            ],
          ),
        ),

        // รายการ Hot News แนวนอน
        SizedBox(
          height: 220,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: hotNews.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                  right: index == hotNews.length - 1 ? 0 : 12,
                ),
                child: _HotNewsCard(news: hotNews[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// 🔥 Widget การ์ด Hot News (แนวนอน)
class _HotNewsCard extends StatelessWidget {
  final NewsEntity news;

  const _HotNewsCard({required this.news});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme. of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius. circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius. circular(16),
        child: Stack(
          children: [
            // 🖼️ รูปภาพพื้นหลัง
            Positioned. fill(
              child: Image.network(
                news.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: isDark ? Colors.grey[800] : Colors.grey[300],
                    child: Icon(
                      Icons.image_not_supported,
                      color: isDark ? Colors.grey[600] : Colors.grey,
                      size: 40,
                    ),
                  );
                },
              ),
            ),

            // 🌑 Gradient overlay (ทำให้อ่านข้อความได้ชัด)
            Positioned. fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
            ),

            // 📝 ข้อความด้านล่าง
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // หัวข้อข่าว
                  Text(
                    news. title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight. bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),

                  // โลโก้ + ชื่อสำนักข่าว + เวลา
                  Row(
                    children: [
                      // โลโก้สำนักข่าว
                      ClipOval(
                        child: Image.network(
                          news.sourceLogoUrl,
                          width: 16,
                          height: 16,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 16,
                              height: 16,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.newspaper,
                                size: 8,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 6),

                      // ชื่อสำนักข่าว
                      Flexible(
                        child: Text(
                          news.source,
                          style: TextStyle(
                            color: Colors.white. withOpacity(0.9),
                            fontSize: 11,
                            fontWeight: FontWeight. w500,
                          ),
                          overflow: TextOverflow. ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),

                      Text(
                        '•',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 6),

                      // เวลา
                      Text(
                        news.timeAgo,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 🔥 Badge Hot (มุมบนซ้าย)
            Positioned(
              top: 10,
              left: 10,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize. min,
                  children: [
                    Text(
                      '🔥',
                      style: TextStyle(fontSize: 10),
                    ),
                    SizedBox(width: 4),
                    Text(
                      'HOT',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight. bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 📰 Widget การ์ดข่าวปกติ
class _NewsCard extends StatelessWidget {
  final NewsEntity news;

  const _NewsCard({required this. news});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

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
                // 1. หัวข้อข่าว
                Text(
                  news.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                    color: isDark ? Colors.white : Colors. black,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow. ellipsis,
                ),
                const SizedBox(height: 10),

                // 2. โลโก้สำนักข่าว + ชื่อ + เวลา
                Row(
                  children: [
                    _buildSourceTag(
                      context,
                      news.source,
                      news.sourceLogoUrl,
                      isDark,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '•',
                      style: TextStyle(
                        color: isDark ? Colors.grey[600] : Colors.grey[400],
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      news.timeAgo,
                      style: TextStyle(
                        color: isDark ? Colors.grey[400] : Colors.grey[700],
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
            borderRadius: BorderRadius. circular(12),
            child: Image. network(
              news.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 100,
                  height: 100,
                  color: isDark ? Colors.grey[800] : Colors.grey[300],
                  child: Icon(
                    Icons.image_not_supported,
                    color: isDark ? Colors. grey[600] : Colors.grey,
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
    bool isDark,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 🖼️ โลโก้สำนักข่าว (วงกลม)
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.grey[700]!  : Colors.grey[300]!,
              width: 1,
            ),
          ),
          child: ClipOval(
            child: Image. network(
              logoUrl,
              width: 22,
              height: 22,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: isDark ?  Colors.grey[700] : Colors.grey[300],
                    shape: BoxShape. circle,
                  ),
                  child: Icon(
                    Icons.newspaper,
                    size: 12,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 6),

        // 📝 ชื่อสำนักข่าว
        Text(
          sourceName,
          style: TextStyle(
            color: isDark ? Colors.grey[300] : Colors.grey[700],
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}