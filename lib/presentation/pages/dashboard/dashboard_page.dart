import 'package:flutter/material.dart';
import '../../../domain/services/analytics_service.dart';
import 'widgets/stat_card.dart';
import 'widgets/skill_progress_card.dart';
import 'widgets/heatmap_widget.dart';
import 'widgets/weak_skills_card.dart';

/// Dashboard hiển thị dữ liệu HỌC TẬP THỰC TẾ
/// ❌ KHÔNG FAKE DATA
/// ✅ Tất cả từ database
class DashboardPage extends StatefulWidget {
  final String userId;
  final AnalyticsService analyticsService;
  
  const DashboardPage({
    super.key,
    required this.userId,
    required this.analyticsService,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isLoading = true;
  DashboardData? _dashboardData;
  List<SkillWeakness>? _weakSkills;
  Map<DateTime, int>? _heatmap;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load tất cả data song song
      final results = await Future.wait([
        widget.analyticsService.getDashboardData(widget.userId),
        widget.analyticsService.detectWeakSkills(widget.userId),
        widget.analyticsService.getStudyHeatmap(widget.userId),
      ]);

      if (!mounted) return;
      setState(() {
        _dashboardData = results[0] as DashboardData;
        _weakSkills = results[1] as List<SkillWeakness>;
        _heatmap = results[2] as Map<DateTime, int>;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : const Color(0xFFF5F7FA);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: Column(
        children: [
          // Gradient Header
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              left: 20,
              right: 20,
              bottom: 20,
            ),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.bar_chart_rounded,
                    color: Colors.white,
                    size: 26,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Theo dõi tiến độ học tập',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Material(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  child: InkWell(
                    onTap: _loadDashboardData,
                    borderRadius: BorderRadius.circular(12),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(
                        Icons.refresh_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  Widget _buildBody() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3748);

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(_error!, style: TextStyle(color: textColor)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadDashboardData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    if (_dashboardData == null) {
      return Center(
        child: Text('Không có dữ liệu', style: TextStyle(color: textColor)),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadDashboardData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section: Tổng quan
            Text(
              'Tổng quan',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildStatsGrid(),
            
            const SizedBox(height: 24),
            
            // Section: Tiến độ kỹ năng
            Text(
              'Tiến độ kỹ năng',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            SkillProgressCard(
              skillProgress: _dashboardData!.skillProgress,
            ),
            
            const SizedBox(height: 24),
            
            // Section: Heatmap học tập
            Text(
              'Lịch học tập (30 ngày)',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 16),
            HeatmapWidget(
              heatmap: _heatmap ?? {},
            ),
            
            const SizedBox(height: 24),
            
            // Section: Kỹ năng yếu (nếu có)
            if (_weakSkills != null && _weakSkills!.isNotEmpty) ...[
              const Text(
                'Kỹ năng cần cải thiện',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
              const SizedBox(height: 16),
              WeakSkillsCard(
                weakSkills: _weakSkills!,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid() {
    String formatStudyTime(double hours) {
      if (hours <= 0) return '0m';
      final minutes = (hours * 60).round();
      if (minutes < 60) return '${minutes}m';
      return '${hours.toStringAsFixed(1)}h';
    }

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: [
        StatCard(
          icon: Icons.star,
          iconColor: Colors.amber,
          title: 'XP',
          value: _dashboardData!.totalXp.toString(),
        ),
        StatCard(
          icon: Icons.local_fire_department,
          iconColor: Colors.orange,
          title: 'Streak',
          value: _dashboardData!.currentStreak.toString(),
        ),
        StatCard(
          icon: Icons.schedule,
          iconColor: Colors.blue,
          title: 'Học tập',
          value: formatStudyTime(_dashboardData!.totalLearningHours),
        ),
      ],
    );
  }
}

