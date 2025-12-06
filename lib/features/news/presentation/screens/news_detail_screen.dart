import 'package:flutter/material.dart';
import 'package:stockmark/core/constants/app_dimensions.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';

class NewsDetailScreen extends StatelessWidget {
  final NewsEntity news;

  const NewsDetailScreen({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ===== AppBar ปกติ =====
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            ClipOval(
              child: Image.network(
                news.sourceLogoUrl,
                width: 24,
                height: 24,
                errorBuilder: (_, __, ___) => Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                news.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {},
          ),
        ],
      ),

      // ===== Body =====
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            Image.network(
              news.imageUrl,
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 250,
                color: Colors.grey[300],
                child: const Icon(Icons.image, size: 50),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    news.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Source Row
                  Row(
                    children: [
                      ClipOval(
                        child: Image.network(
                          news.sourceLogoUrl,
                          width: 28,
                          height: 28,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(news.source),
                      const Text(' • '),
                      Text(news.timeAgo),
                    ],
                  ),
                 

                  //เส้นคั่นตรงนี้
                  Divider(
                    height: AppSpacing.xxxl,
                    thickness: AppDimensions.dividerThickness,
                    color: context.dividerColor,
                  ),
                  // Content
                  const Text(
                    ""
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
