import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stockmark/core/constants/app_colors.dart';
import 'package:stockmark/features/home/domain/entities/stock_entity.dart';
import 'package:stockmark/features/home/presentation/providers/movers_provider.dart';

class TopMoversSection extends StatefulWidget {
  const TopMoversSection({super.key});

  @override
  State<TopMoversSection> createState() => _TopMoversSectionState();
}

class _TopMoversSectionState extends State<TopMoversSection> {
  // ตัวแปรสำหรับสลับแท็บ Gainers (true) / Losers (false)
  bool showGainers = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<MoversProvider>(
      builder: (context, provider, _) {
        // ถ้ากำลังโหลด ให้โชว์ Loading ตรงกลาง
        if (provider.isLoading) {
          return const SizedBox(
            height: 200,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        // ถ้ามี Error
        if (provider.errorMessage != null) {
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Text(
                'Error: ${provider.errorMessage}',
                style: const TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ==================================================
            // 🟢 ส่วนที่ 1: Top Movers (Gainers & Losers)
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Text(
                'Top Movers',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),

            // ปุ่มสลับแท็บ (Toggle Buttons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildTabButton(
                      context: context,
                      label: 'Gainers',
                      isSelected: showGainers,
                      color: const Color(0xFF00C853), // สีเขียว
                      onTap: () => setState(() => showGainers = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTabButton(
                      context: context,
                      label: 'Losers',
                      isSelected: !showGainers,
                      color: const Color(0xFFFF3D00), // สีแดงส้ม
                      onTap: () => setState(() => showGainers = false),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ลิสต์รายการหุ้น Top Movers
            SizedBox(
              height: 180, // ความสูงของการ์ด
              child: _buildStockList(
                showGainers ? provider.gainers : provider.losers,
              ),
            ),

            // ==================================================
            // 🔥 ส่วนที่ 2: Trending Now (Most Active)
            // ==================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
              child: Row(
                children: [
                  Text(
                    'Trending Now',
                    style: Theme.of(context).textTheme.titleLarge
                        ?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.local_fire_department,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),

            // ลิสต์รายการหุ้น Trending
            SizedBox(
              height: 180,
              child: _buildStockList(provider.trending),
            ),
          ],
        );
      },
    );
  }

  // Widget สำหรับสร้างลิสต์แนวนอน
  Widget _buildStockList(List<StockEntity> stocks) {
    if (stocks.isEmpty) {
      return const Center(
        child: Text(
          'No data available',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        return _StockCard(
          symbol: stock.symbol,
          name: stock.name,
          price: stock.price,
          change: stock.change,
        );
      },
    );
  }

  // Widget ปุ่มกดสลับแท็บ
  Widget _buildTabButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withOpacity(0.2) // พื้นหลังจางๆ เมื่อเลือก
              : (isDark
                    ? AppColors.darkTabUnselected
                    : AppColors.lightTabUnselected),
          borderRadius: BorderRadius.circular(25),
          border: isSelected
              ? Border.all(color: color, width: 1.5)
              : Border.all(color: Colors.transparent, width: 1.5),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? color // สีตัวอักษรตามธีมปุ่ม
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
              fontWeight: FontWeight.w700,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

// การ์ดแสดงข้อมูลหุ้นแต่ละตัว
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // เลือกสีตามการเปลี่ยนแปลง
    final changeColor = isPositive
        ? const Color(0xFF00C853)
        : const Color(0xFFFF3D00);

    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.lightCard,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black12 : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // โลโก้และชื่อย่อ
          Row(
            children: [
              // ✅ ใส่โค้ดใหม่: โหลดรูปโลโก้ (พร้อมกันเหนียว ถ้าไม่มีรูปให้โชว์ตัวอักษรเหมือนเดิม)
              ClipOval(
                child: Image.network(
                  // 💡 URL มหัศจรรย์: แค่เปลี่ยน symbol ก็ได้โลโก้เลย (ฟรี)
                  'https://assets.parqet.com/logos/symbol/$symbol?format=png',
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // กรณีโหลดรูปไม่ได้ (เช่น SPY หรือหุ้นแปลกๆ) ให้กลับมาโชว์ตัวอักษรย่อ
                    return Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.darkIconBg
                            : AppColors.lightIconBg,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        symbol.substring(0, 1),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),

          // ชื่อเต็มบริษัท
          Text(
            name,
            style: TextStyle(
              color: isDark ? Colors.white60 : Colors.black54,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 8),

          // ราคาและการเปลี่ยนแปลง
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '\$${price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: changeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isPositive
                          ? Icons.arrow_drop_up
                          : Icons.arrow_drop_down,
                      color: changeColor,
                      size: 16,
                    ),
                    Text(
                      '${change.abs().toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: changeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
