import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/core/constants/app_dimensions.dart';
import 'package:stockmark/core/constants/app_font_sizes.dart';
import 'package:stockmark/core/constants/app_opacity.dart';
import 'package:stockmark/core/constants/app_radius.dart';
import 'package:stockmark/core/constants/app_spacing.dart';

import 'package:stockmark/core/constants/app_string.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/features/home/presentation/providers/stock_provider.dart';

/// Market Overview Section - แสดงข้อมูล S&P 500
class MarketOverviewSection extends StatelessWidget {
  const MarketOverviewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(context),
        _buildContent(),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.xxl,
        AppSpacing. lg,
        AppSpacing. lg,
      ),
      child: Text(AppStrings.marketOverview, style: context.headlineSmall),
    );
  }

  Widget _buildContent() {
    return Consumer<StockProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const _LoadingCard();
        }

        if (provider. sp500 == null) {
          return const _ErrorCard();
        }

        final stock = provider.sp500!;
        return _MarketCard(
          name: stock.name,
          symbol: stock.symbol,
          price: stock.price,
          change: stock.change,
          isPositive: stock.change >= 0,
        );
      },
    );
  }
}

/// Market Card - การ์ดแสดงข้อมูลตลาด
class _MarketCard extends StatelessWidget {
  final String name;
  final String symbol;
  final double price;
  final double change;
  final bool isPositive;

  const _MarketCard({
    required this.name,
    required this. symbol,
    required this.price,
    required this.change,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: _buildDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderRow(),
          const SizedBox(height: AppSpacing.xl),
          _buildPrice(),
          const SizedBox(height: AppSpacing.sm),
          _buildChangeRow(context),
        ],
      ),
    );
  }

  BoxDecoration _buildDecoration(BuildContext context) {
    return BoxDecoration(
      color: context.isDark ? AppColors.darkCard : AppColors.primaryBlue,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      boxShadow: [
        BoxShadow(
          color: AppColors.primaryBlue.withOpacity(AppOpacity.medium),
          blurRadius: AppDimensions.shadowBlurLg,
          offset: AppDimensions.shadowOffsetLg,
        ),
      ],
    );
  }

  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment. spaceBetween,
      children: [
        Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: AppFontSize.xl,
            fontWeight: FontWeight.w500,
          ),
        ),
        _SymbolChip(symbol: symbol),
      ],
    );
  }

  Widget _buildPrice() {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: const TextStyle(
        color: Colors.white,
        fontSize: AppFontSize. displayLg,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildChangeRow(BuildContext context) {
    final changeColor = isPositive ?  AppColors.stockUp : AppColors.stockDown;
    final displayColor = context.isDark ? changeColor : Colors.white;

    return Row(
      children: [
        Icon(
          isPositive ? Icons.arrow_upward : Icons. arrow_downward,
          color: displayColor,
          size: AppDimensions.iconMd,
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(
          '${isPositive ?  '+' : ''}${change. toStringAsFixed(2)}%',
          style: TextStyle(
            color: displayColor,
            fontSize: AppFontSize. xl,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Symbol Chip - ป้ายแสดง Symbol
class _SymbolChip extends StatelessWidget {
  final String symbol;

  const _SymbolChip({required this. symbol});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing. sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(AppOpacity.light),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        symbol,
        style: const TextStyle(
          color: Colors.white,
          fontSize: AppFontSize.sm,
          fontWeight: FontWeight. bold,
        ),
      ),
    );
  }
}

/// Loading Card - การ์ดแสดงสถานะโหลด
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}

/// Error Card - การ์ดแสดงข้อผิดพลาด
class _ErrorCard extends StatelessWidget {
  const _ErrorCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(AppSpacing. xxl),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
      ),
      child: Center(
        child: Text(
          AppStrings.unableToLoadMarketData,
          style: context.bodyMedium.copyWith(color: AppColors.error),
        ),
      ),
    );
  }
}