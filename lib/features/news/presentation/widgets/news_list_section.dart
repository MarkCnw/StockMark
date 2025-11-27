import 'package:flutter/material.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/core/constants/app_dimensions.dart';
import 'package:stockmark/core/constants/app_radius.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/constants/app_string.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/core/theme/app_text_styles.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'package:stockmark/features/news/presentation/widgets/source_row.dart';

/// Latest News Section - แสดงข่าวล่าสุดแบบ Vertical List
class LatestNewsSection extends StatelessWidget {
  final List<NewsEntity> news;
  final void Function(NewsEntity)? onNewsTap;

  const LatestNewsSection({super.key, required this.news, this.onNewsTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        const SizedBox(height: AppSpacing.sm),
        _buildNewsList(context),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(AppStrings.latestNews, style: context.titleLarge),
    );
  }

  Widget _buildNewsList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(AppSpacing.lg),
      itemCount: news.length,
      separatorBuilder: (_, __) => Divider(
        height: AppSpacing.xxxl,
        thickness: AppDimensions.dividerThickness,
        color: context.dividerColor,
      ),
      itemBuilder: (context, index) {
        final item = news[index];
        return _NewsCard(
          news: item,
          onTap: onNewsTap != null ? () => onNewsTap!(item) : null,
        );
      },
    );
  }
}

/// News Card - การ์ดข่าวปกติ
class _NewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback? onTap;

  const _NewsCard({required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: _buildContent(context)),
            const SizedBox(width: AppSpacing.md),
            _buildImage(context),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          news.title,
          style: AppTextStyles.newsTitle(isDark: context.isDark),
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppSpacing.md),
        SourceRow(
          source: news.source,
          logoUrl: news.sourceLogoUrl,
          timeAgo: news.timeAgo,
        ),
      ],
    );
  }

  Widget _buildImage(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Image.network(
        news.imageUrl,
        width: AppDimensions.newsImageSize,
        height: AppDimensions.newsImageSize,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildImagePlaceholder(context),
      ),
    );
  }

  Widget _buildImagePlaceholder(BuildContext context) {
    return Container(
      width: AppDimensions.newsImageSize,
      height: AppDimensions.newsImageSize,
      color: context.isDark ? AppColors.darkIconBg : AppColors.lightIconBg,
      child: Icon(
        Icons.image_not_supported_outlined,
        color: context.textSecondaryColor,
      ),
    );
  }
}
