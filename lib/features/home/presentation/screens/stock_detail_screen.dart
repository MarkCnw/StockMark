import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/core/constants/app_radius.dart';
import 'package:stockmark/core/constants/app_spacing.dart';
import 'package:stockmark/core/extensions/context_extensions.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/domain/entities/stock_detail_entity.dart';
import 'package:stockmark/features/home/presentation/providers/stock_detail_provider.dart';
import 'package:stockmark/features/home/presentation/widgets/stock_chart.dart';

class StockDetailScreen extends StatefulWidget {
  final StockEntity stock; // รับข้อมูลเบื้องต้นจากหน้า Home

  const StockDetailScreen({super.key, required this.stock});

  @override
  State<StockDetailScreen> createState() => _StockDetailScreenState();
}

class _StockDetailScreenState extends State<StockDetailScreen> {
  @override
  void initState() {
    super.initState();
    // 🚀 สั่งโหลดข้อมูลทันทีที่เข้าหน้า
    Future.microtask(
      () => context.read<StockDetailProvider>().loadStockDetail(
        widget.stock.symbol,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: _buildAppBar(context),

      // ✅ ห่อด้วย Consumer เพื่อรอรับข้อมูลจริง
      body: Consumer<StockDetailProvider>(
        builder: (context, provider, child) {
          // 1. สถานะกำลังโหลด
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. สถานะ Error
          if (provider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    provider.errorMessage!,
                    style: TextStyle(color: AppColors.error),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        provider.loadStockDetail(widget.stock.symbol),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final detail = provider.stockDetail;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: AppSpacing.xxxl),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xxxl),
                // ใช้ข้อมูลจาก API (detail) ถ้ายังไม่มีให้ใช้ของเก่า (widget.stock)
                _buildHeader(context, detail),

                const SizedBox(height: AppSpacing.xxxl),
                _buildChartSection(context),
                if (detail != null) ...[
                  _buildAboutSection(context, detail.about),
                  const SizedBox(height: AppSpacing.xxl),
                ],


                const SizedBox(height: AppSpacing.xxl),

                // แสดง Grid ข้อมูลสถิติเฉพาะเมื่อโหลดเสร็จแล้ว
                if (detail != null) ...[
                  _buildSectionTitle(context, 'Key Statistics'),
                  _buildStatsGrid(context, detail),
                ],

                const SizedBox(height: AppSpacing.xxl),
                _buildSectionTitle(context, 'Related News'),
                _buildRelatedNews(context),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: context.iconColor),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(widget.stock.symbol, style: context.titleLarge),
      actions: [
        IconButton(
          icon: Icon(Icons.star_border, color: context.iconColor),
          onPressed: () {},
        ),
      ],
    );
  }

  // สร้าง Widget ใหม่สำหรับส่วน About
  Widget _buildAboutSection(BuildContext context, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About ${widget.stock.symbol}', // เช่น About AAPL
            style: context.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // ใช้ Text แบบจำกัดบรรทัด แล้วมีปุ่ม Read More ก็ได้
          Text(
            description,
            style: context.bodyMedium.copyWith(
              color: AppColors.textSecondaryLight,
              height: 1.5, // เพิ่มระยะห่างบรรทัดให้อ่านง่าย
            ),
            maxLines: 4, // โชว์แค่ 4 บรรทัดพอ
            overflow: TextOverflow.ellipsis, // ถ้าเกินให้ขึ้น ...
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, StockDetailEntity? detail) {
    final price = detail?.price ?? widget.stock.price;
    final change = detail?.change ?? widget.stock.change;

    final isPositive = change >= 0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. โลโก้ (ขนาด fix เท่าเดิม)
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.lightIconBg,
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://assets.parqet.com/logos/symbol/${widget.stock.symbol}?format=png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          // 2. ราคาและชื่อ (✅ แก้ไข: ใช้ Expanded ห่อ และลบ Spacer ทิ้ง)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: context.headlineSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  detail?.name ?? widget.stock.name,
                  maxLines: 1, // ✅ บังคับโชว์บรรทัดเดียว
                  overflow:
                      TextOverflow.ellipsis, // ✅ ถ้าชื่อยาวให้ขึ้น ...
                  style: context.bodyMedium.copyWith(
                    color: AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: AppSpacing.md), // เว้นระยะนิดนึงก่อนถึงขวา
          // 3. เปอร์เซ็นต์ (ขวาสุด Fix ขนาดตามเนื้อหา)
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isPositive ? '+' : ''}${change.toStringAsFixed(2)}% ',
                style: TextStyle(
                  color: isPositive
                      ? AppColors.stockUp
                      : AppColors.stockDown,
                  fontWeight: FontWeight.bold,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'Today',
                style: context.bodySmall.copyWith(
                  fontSize: 15,
                  color: AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChartSection(BuildContext context) {
    // 1. ดึงข้อมูลกราฟจาก Provider
    final provider = context.watch<StockDetailProvider>();
    final chartData = provider.chartData;

    // คำนวณสี (ถ้าไม่มีข้อมูลให้ใช้สีเขียวไปก่อน)
    final isPositive = (chartData.isNotEmpty)
        ? chartData.last >= chartData.first
        : true;

    return Container(
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ), // เพิ่ม padding ให้กราฟไม่ชิดขอบการ์ด
      // decoration: BoxDecoration(
      //   color: context.cardColor,
      //   borderRadius: BorderRadius.circular(AppRadius.xl),
      //   boxShadow: [
      //     BoxShadow(
      //       color: Colors.black.withOpacity(0.05),
      //       blurRadius: 20,
      //       offset: const Offset(0, 10),
      //     ),
      //   ],
      // ),
      child: chartData.isEmpty
          ? const Center(
              child: CircularProgressIndicator(),
            ) // กำลังโหลดกราฟ
          : StockChart(data: chartData, isPositive: isPositive),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        title,
        style: context.titleMedium.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, StockDetailEntity detail) {
    // ✅ นำข้อมูลจริงมาแสดง
    final stats = {
      'Open': detail.open.toStringAsFixed(2),
      'High': detail.high.toStringAsFixed(2),
      'Low': detail.low.toStringAsFixed(2),
      'Vol': _formatVolume(detail.volume),
      'P/E': detail.peRatio.toStringAsFixed(2),
      'Mkt Cap': _formatVolume(detail.marketCap),
    };

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final key = stats.keys.elementAt(index);
        final value = stats.values.elementAt(index);
        return Container(
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: AppColors.borderLight.withOpacity(0.5),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                key,
                style: context.bodySmall.copyWith(
                  color: AppColors.textSecondaryLight,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: context.titleSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRelatedNews(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: const Center(
          child: Text("News specific to this stock will appear here."),
        ),
      ),
    );
  }

  // Helper function ย่อตัวเลข (เช่น 1M, 1B)
  String _formatVolume(double num) {
    if (num >= 1e12) return '${(num / 1e12).toStringAsFixed(1)}T';
    if (num >= 1e9) return '${(num / 1e9).toStringAsFixed(1)}B';
    if (num >= 1e6) return '${(num / 1e6).toStringAsFixed(1)}M';
    if (num >= 1e3) return '${(num / 1e3).toStringAsFixed(1)}K';
    return num.toStringAsFixed(0);
  }
}
