import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:stockmark/core/constants/app_colors.dart';

class StockChart extends StatelessWidget {
  final List<double> data;
  final bool isPositive;

  const StockChart({
    super.key,
    required this.data,
    required this.isPositive,
  });

  @override
  Widget build(BuildContext context) {
    // กำหนดสีตามสถานะหุ้น (เขียว/แดง)
    final color = isPositive ? AppColors.stockUp : AppColors.stockDown;
    
    // หาค่าสูงสุด-ต่ำสุด เพื่อกำหนดกรอบกราฟไม่ให้ลอยเคว้ง
    double minY = data.reduce((curr, next) => curr < next ? curr : next);
    double maxY = data.reduce((curr, next) => curr > next ? curr : next);
    // เพิ่ม Padding ให้กราฟนิดหน่อย ไม่ให้ชนขอบบนล่าง
    minY -= (minY * 0.002); 
    maxY += (maxY * 0.002);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false), // ปิดเส้นตาราง (Minimal)
        titlesData: const FlTitlesData(show: false), // ปิดตัวเลขแกน X, Y
        borderData: FlBorderData(show: false), // ปิดกรอบ
        minX: 0,
        maxX: data.length.toDouble() - 1,
        minY: minY,
        maxY: maxY,
        lineTouchData: LineTouchData(
          enabled: true, // เอานิ้วลากดูราคาได้
          touchTooltipData: LineTouchTooltipData(
            // ปรับแต่ง Tooltip เวลาจิ้ม
            tooltipRoundedRadius: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '\$${spot.y.toStringAsFixed(2)}',
                  const TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold
                  ),
                );
              }).toList();
            },
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: data.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value);
            }).toList(),
            isCurved: true, // เส้นโค้ง
            color: color, // สีเส้น
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false), // ไม่เอาจุดไข่ปลา
            belowBarData: BarAreaData(
              show: true, // เทสีใต้กราฟ
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.3), // สีเข้มข้างบน
                  color.withOpacity(0.0), // สีจางข้างล่าง
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}