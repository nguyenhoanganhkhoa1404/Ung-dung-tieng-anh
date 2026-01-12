import 'package:flutter/material.dart';

/// Widget hiển thị heatmap học tập theo ngày
/// Giống GitHub contribution graph
class HeatmapWidget extends StatelessWidget {
  final Map<DateTime, int> heatmap;

  const HeatmapWidget({
    super.key,
    required this.heatmap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLegend(),
            const SizedBox(height: 16),
            _buildGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text(
          'Ít ',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
        ...List.generate(5, (index) {
          return Container(
            margin: const EdgeInsets.only(left: 4),
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: _getColorForIntensity(index / 4),
              borderRadius: BorderRadius.circular(2),
            ),
          );
        }),
        const Text(
          ' Nhiều',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildGrid() {
    // Lấy 30 ngày gần nhất
    final today = DateTime.now();
    final dates = List.generate(30, (index) {
      return today.subtract(Duration(days: 29 - index));
    });

    // Chia thành 6 tuần (5 ngày/tuần để hiển thị đẹp)
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (weekIndex) {
        return Column(
          children: List.generate(5, (dayIndex) {
            final dateIndex = weekIndex * 5 + dayIndex;
            if (dateIndex >= dates.length) {
              return const SizedBox(width: 20, height: 20);
            }
            
            final date = dates[dateIndex];
            final normalizedDate = DateTime(date.year, date.month, date.day);
            final minutes = heatmap[normalizedDate] ?? 0;
            
            return _buildDayCell(normalizedDate, minutes);
          }),
        );
      }),
    );
  }

  Widget _buildDayCell(DateTime date, int minutes) {
    // Tính intensity dựa trên số phút học
    final intensity = _calculateIntensity(minutes);
    
    return Tooltip(
      message: _getTooltipMessage(date, minutes),
      child: Container(
        width: 20,
        height: 20,
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: _getColorForIntensity(intensity),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  /// Tính intensity từ 0.0 đến 1.0
  double _calculateIntensity(int minutes) {
    if (minutes == 0) return 0.0;
    if (minutes < 10) return 0.2;
    if (minutes < 30) return 0.4;
    if (minutes < 60) return 0.6;
    if (minutes < 120) return 0.8;
    return 1.0;
  }

  /// Lấy màu theo intensity
  Color _getColorForIntensity(double intensity) {
    if (intensity == 0) return Colors.grey[200]!;
    return Color.lerp(
      Colors.green[200],
      Colors.green[900],
      intensity,
    )!;
  }

  String _getTooltipMessage(DateTime date, int minutes) {
    final dateStr = '${date.day}/${date.month}/${date.year}';
    if (minutes == 0) {
      return '$dateStr: Chưa học';
    }
    return '$dateStr: ${minutes} phút';
  }
}

