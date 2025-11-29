import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_colors.dart';

import 'package:stockmark/core/constants/app_dimensions.dart';
import 'package:stockmark/core/constants/app_dutation.dart';
import 'package:stockmark/core/constants/app_font_sizes.dart';
import 'package:stockmark/core/constants/app_opacity.dart';
import 'package:stockmark/core/constants/app_radius.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/constants/app_string.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/presentation/providers/movers_provider.dart';

/// Top Movers Section - แสดงหุ้นที่มีการเปลี่ยนแปลงมากที่สุด
class TopMoversSection extends StatefulWidget {
  const TopMoversSection({super.key});

  @override
  State<TopMoversSection> createState() => _TopMoversSectionState();
}

class _TopMoversSectionState extends State<TopMoversSection> {
  bool _showGainers = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<MoversProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const _LoadingState();
        }

        if (provider.errorMessage != null) {//กฟกฟก
          return _ErrorState(message: provider.errorMessage!);
        }

        return _buildContent(provider);
      },
    );
  }

  Widget _buildContent(MoversProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ===== TOP MOVERS =====
        _buildSectionHeader(AppStrings.topMovers),
        _buildToggleButtons(),
        const SizedBox(height: AppSpacing.lg),
        _StockList(
          stocks: _showGainers ? provider.gainers : provider.losers,
        ),

        // ===== TRENDING =====
        _buildSectionHeaderWithIcon(
          AppStrings.trendingNow,
          Icons.local_fire_department,
        ),
        _StockList(stocks: provider.trending),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Text(title, style: context.headlineSmall),
    );
  }

  Widget _buildSectionHeaderWithIcon(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing.lg,
        AppSpacing.lg,
      ),
      child: Row(
        children: [
          Text(title, style: context.headlineSmall),
          const SizedBox(width: AppSpacing.sm),
          Icon(icon, color: AppColors.warning),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: _TabButton(
              label: AppStrings.gainers,
              isSelected: _showGainers,
              color: AppColors.stockUp,
              onTap: () => setState(() => _showGainers = true),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _TabButton(
              label: AppStrings.losers,
              isSelected: !_showGainers,
              color: AppColors.stockDown,
              onTap: () => setState(() => _showGainers = false),
            ),
          ),
        ],
      ),
    );
  }
}

/// Loading State
class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimensions.stockCardHeight + AppSpacing.xl,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Error State
class _ErrorState extends StatelessWidget {
  final String message;

  const _ErrorState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: Text(
          '${AppStrings.error}: $message',
          style: context.bodyMedium.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}

/// Stock List - รายการหุ้นแนวนอน
class _StockList extends StatelessWidget {
  final List<StockEntity> stocks;

  const _StockList({required this.stocks});

  @override
  Widget build(BuildContext context) {
    if (stocks.isEmpty) {
      return SizedBox(
        height: AppDimensions.stockCardHeight,
        child: Center(
          child: Text(
            AppStrings.noDataAvailable,
            style: context.bodyMedium.copyWith(
              color: context.textSecondaryColor,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: AppDimensions.stockCardHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        itemCount: stocks.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.md),
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return _StockCard(
            symbol: stock.symbol,
            name: stock.name,
            price: stock.price,
            change: stock.change,
          );
        },
      ),
    );
  }
}

/// Tab Button - ปุ่มสลับ Gainers/Losers
class _TabButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TabButton({
    required this.label,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(AppOpacity.light)
              : (context.isDark
                    ? AppColors.darkTabUnselected
                    : AppColors.lightTabUnselected),
          borderRadius: BorderRadius.circular(AppRadius.xxl),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: AppDimensions.borderWidthThick,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: context.labelLarge.copyWith(
              color: isSelected ? color : context.textSecondaryColor,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Stock Card - การ์ดแสดงข้อมูลหุ้น
class _StockCard extends StatelessWidget {
  final String symbol;
  final String name;
  final double price;
  final double change;

  const _StockCard({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = change >= 0;
    final changeColor = isPositive
        ? AppColors.stockUp
        : AppColors.stockDown;

    return Container(
      width: AppDimensions.stockCardWidth,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: _buildDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHeader(context),
          _buildCompanyName(context),
          const SizedBox(height: AppSpacing.sm),
          _buildPriceSection(context, changeColor, isPositive),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.cardColor,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: [
        BoxShadow(
          color: context.isDark
              ? Colors.black.withOpacity(AppOpacity.subtle)
              : Colors.grey.withOpacity(AppOpacity.subtle),
          blurRadius: AppDimensions.shadowBlurMd,
          offset: AppDimensions.shadowOffset,
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _StockLogo(symbol: symbol),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            symbol,
            style: context.titleSmall,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildCompanyName(BuildContext context) {
    return Text(
      name,
      style: context.bodySmall,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildPriceSection(
    BuildContext context,
    Color changeColor,
    bool isPositive,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${price.toStringAsFixed(2)}',
          style: context.titleMedium.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSpacing.xs),
        _ChangeChip(
          change: change,
          color: changeColor,
          isPositive: isPositive,
        ),
      ],
    );
  }
}

/// Stock Logo - โลโก้หุ้น
class _StockLogo extends StatelessWidget {
  final String symbol;

  const _StockLogo({required this.symbol});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        'https://assets.parqet.com/logos/symbol/$symbol? format=png',
        width: AppDimensions.stockLogoSize,
        height: AppDimensions.stockLogoSize,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildPlaceholder(context),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return Container(
      width: AppDimensions.stockLogoSize,
      height: AppDimensions.stockLogoSize,
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.darkIconBg
            : AppColors.lightIconBg,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        symbol.isNotEmpty ? symbol.substring(0, 1) : '',
        style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Change Chip - แสดงการเปลี่ยนแปลงของราคา
class _ChangeChip extends StatelessWidget {
  final double change;
  final Color color;
  final bool isPositive;

  const _ChangeChip({
    required this.change,
    required this.color,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(AppOpacity.subtle),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.arrow_drop_up : Icons.arrow_drop_down,
            color: color,
            size: AppDimensions.iconSm,
          ),
          Text(
            '${change.abs().toStringAsFixed(2)}%',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
              fontSize: AppFontSize.sm,
            ),
          ),
        ],
      ),
    );
  }
}
