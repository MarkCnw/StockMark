import 'package:flutter/material.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/core/constants/app_dimensions.dart';
import 'package:stockmark/core/constants/app_font_sizes.dart';
import 'package:stockmark/core/constants/app_opacity.dart';
import 'package:stockmark/core/constants/app_radius.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/constants/app_string.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/core/theme/app_text_styles.dart';
import 'package:stockmark/features/news/domain/entities/news_entity.dart';
import 'source_row.dart';

/// Hot News Section - แสดง Hot News แบบ Horizontal List
class HotNewsSection extends StatelessWidget {
  final List<NewsEntity> hotNews;
  final void Function(NewsEntity)? onNewsTap;

  const HotNewsSection({super.key, required this.hotNews, this.onNewsTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildHeader(context), _buildHorizontalList()],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      child: Row(
        children: [
          const Text('🔥', style: TextStyle(fontSize: AppFontSize.xl)),
          const SizedBox(width: AppSpacing.sm),
          Text(AppStrings.hotNews, style: context.titleLarge),
        ],
      ),
    );
  }

  Widget _buildHorizontalList() {
    return SizedBox(
      height: AppDimensions.hotNewsCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: hotNews.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final news = hotNews[index];
          return _HotNewsCard(
            news: news,
            onTap: onNewsTap != null ? () => onNewsTap!(news) : null,
          );
        },
      ),
    );
  }
}

/// Hot News Card - การ์ดข่าวเด่น
class _HotNewsCard extends StatelessWidget {
  final NewsEntity news;
  final VoidCallback? onTap;

  const _HotNewsCard({required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppDimensions.hotNewsCardWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(AppOpacity.light),
              blurRadius: AppDimensions.shadowBlurLg,
              offset: AppDimensions.shadowOffset,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Stack(
            children: [
              _buildBackgroundImage(context),
              _buildGradientOverlay(),
              _buildContent(),
              const Positioned(
                top: AppSpacing.sm,
                left: AppSpacing.sm,
                child: _HotBadge(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundImage(BuildContext context) {
    return Positioned.fill(
      child: Image.network(
        news.imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          color: context.cardColor,
          child: Icon(
            Icons.image_not_supported_outlined,
            color: context.textSecondaryColor,
            size: AppDimensions.iconXl,
          ),
        ),
      ),
    );
  }

  Widget _buildGradientOverlay() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(AppOpacity.mostlyOpaque),
            ],
            stops: const [0.3, 1.0],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Positioned(
      left: AppSpacing.md,
      right: AppSpacing.md,
      bottom: AppSpacing.md,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            news.title,
            style: AppTextStyles.labelLarge(
              isDark: true,
            ).copyWith(color: Colors.white),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.sm),
          SourceRow(
            source: news.source,
            logoUrl: news.sourceLogoUrl,
            timeAgo: news.timeAgo,
            isLight: true,
          ),
        ],
      ),
    );
  }
}

/// Hot Badge - ป้าย HOT
class _HotBadge extends StatelessWidget {
  const _HotBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.error,
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🔥', style: TextStyle(fontSize: AppFontSize.xxs)),
          SizedBox(width: AppSpacing.xs),
          Text(
            AppStrings.hot,
            style: TextStyle(
              color: Colors.white,
              fontSize: AppFontSize.xxs,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
