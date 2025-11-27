import 'package:flutter/material.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/core/constants/app_dimensions.dart';
import 'package:stockmark/core/constants/app_font_sizes.dart';
import 'package:stockmark/core/constants/app_opacity.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/core/theme/app_text_styles.dart';

/// Source Row - แสดงโลโก้ + ชื่อสำนักข่าว + เวลา
/// Reusable Widget - ใช้ได้ทั้ง HotNewsCard และ NewsCard
class SourceRow extends StatelessWidget {
  final String source;
  final String logoUrl;
  final String timeAgo;
  final bool isLight;

  const SourceRow({
    super.key,
    required this.source,
    required this.logoUrl,
    required this.timeAgo,
    this.isLight = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isLight
        ? Colors.white.withOpacity(AppOpacity.almostOpaque)
        : context.textSecondaryColor;
    final dotColor = isLight
        ? Colors.white.withOpacity(AppOpacity.semiOpaque)
        : context.textSecondaryColor;

    return Row(
      children: [
        _SourceLogo(logoUrl: logoUrl, isLight: isLight),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: Text(
            source,
            style: AppTextStyles.newsSource(
              isDark: context.isDark,
            ).copyWith(color: textColor),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          '•',
          style: TextStyle(color: dotColor, fontSize: AppFontSize.xs),
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          timeAgo,
          style: AppTextStyles.newsTime(
            isDark: context.isDark,
          ).copyWith(color: dotColor),
        ),
      ],
    );
  }
}

/// Source Logo - โลโก้สำนักข่าว
class _SourceLogo extends StatelessWidget {
  final String logoUrl;
  final bool isLight;

  const _SourceLogo({required this.logoUrl, this.isLight = false});

  @override
  Widget build(BuildContext context) {
    const size = AppDimensions.sourceLogoSize;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: isLight
            ? null
            : Border.all(
                color: context.isDark
                    ? AppColors.borderDark
                    : AppColors.borderLight,
                width: AppDimensions.borderWidth,
              ),
      ),
      child: ClipOval(
        child: Image.network(
          logoUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(context, size),
        ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: isLight
            ? AppColors.textSecondaryLight
            : (context.isDark
                  ? AppColors.darkIconBg
                  : AppColors.lightIconBg),
        shape: BoxShape.circle,
      ),
      child: Icon(
        Icons.newspaper,
        size: AppDimensions.iconXs,
        color: isLight ? Colors.white : context.textSecondaryColor,
      ),
    );
  }
}
