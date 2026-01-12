import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Màn hình Leaderboard với bảng xếp hạng người dùng
class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF1E1E1E) : const Color(0xFF6C63FF),
        elevation: 0,
        title: Text(
          '🏆 Leaderboard',
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          labelStyle: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          tabs: const [
            Tab(text: 'Today'),
            Tab(text: 'This Week'),
            Tab(text: 'All Time'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildLeaderboard('today'),
          _buildLeaderboard('week'),
          _buildLeaderboard('alltime'),
        ],
      ),
    );
  }

  Widget _buildLeaderboard(String period) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          // Đọc từ collection public `leaderboard` để hiện tất cả users
          // (users collection bị giới hạn quyền đọc theo owner)
          .collection('leaderboard')
          .orderBy('total_xp', descending: true)
          .limit(50)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return _buildEmptyState();
        }

        final users = snapshot.data!.docs;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Top 3 Podium
            if (users.length >= 3) _buildTopThree(users),
            const SizedBox(height: 24),

            // Rest of rankings
            ...List.generate(
              users.length,
              (index) {
                final userData = users[index].data() as Map<String, dynamic>;
                final rank = index + 1;

                if (rank <= 3) return const SizedBox.shrink();

                return _buildRankingCard(
                  rank: rank,
                  name: userData['name'] ?? 'User $rank',
                  xp: userData['total_xp'] ?? 0,
                  avatar: userData['avatar'] ??
                      'https://ui-avatars.com/api/?name=User&background=random',
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopThree(List<QueryDocumentSnapshot> users) {
    final first = users[0].data() as Map<String, dynamic>;
    final second = users.length > 1 ? users[1].data() as Map<String, dynamic> : null;
    final third = users.length > 2 ? users[2].data() as Map<String, dynamic> : null;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 2nd Place
          if (second != null)
            _buildPodiumItem(
              rank: 2,
              name: second['name'] ?? 'User 2',
              xp: second['total_xp'] ?? 0,
              height: 100,
              color: Colors.grey[300]!,
            ),

          // 1st Place
          _buildPodiumItem(
            rank: 1,
            name: first['name'] ?? 'User 1',
            xp: first['total_xp'] ?? 0,
            height: 140,
            color: const Color(0xFFFFD700), // Gold
          ),

          // 3rd Place
          if (third != null)
            _buildPodiumItem(
              rank: 3,
              name: third['name'] ?? 'User 3',
              xp: third['total_xp'] ?? 0,
              height: 80,
              color: const Color(0xFFCD7F32), // Bronze
            ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem({
    required int rank,
    required String name,
    required int xp,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        GFAvatar(
          backgroundImage: NetworkImage(
            'https://ui-avatars.com/api/?name=$name&background=random',
          ),
          shape: GFAvatarShape.circle,
          size: rank == 1 ? GFSize.LARGE : GFSize.MEDIUM,
        ),
        const SizedBox(height: 8),
        Text(
          name,
          style: GoogleFonts.poppins(
            fontSize: rank == 1 ? 14 : 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '$xp XP',
          style: GoogleFonts.poppins(
            fontSize: 11,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
          ),
          child: Center(
            child: Text(
              '#$rank',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingCard({
    required int rank,
    required String name,
    required int xp,
    required String avatar,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final titleColor = isDark ? Colors.white : Colors.black87;
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return GFListTile(
      margin: const EdgeInsets.only(bottom: 12),
      color: cardColor,
      avatar: GFAvatar(
        backgroundImage: NetworkImage(avatar),
        shape: GFAvatarShape.circle,
      ),
      title: Text(
        name,
        style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: titleColor,
        ),
      ),
      subTitle: Text(
        '$xp XP',
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: subtitleColor,
        ),
      ),
      icon: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _getRankColor(rank).withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            '#$rank',
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: _getRankColor(rank),
            ),
          ),
        ),
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank <= 10) return const Color(0xFF6C63FF);
    if (rank <= 20) return const Color(0xFF4CAF50);
    return Colors.grey;
  }

  Widget _buildEmptyState() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.grey[300] : Colors.grey[600];
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[500];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            size: 100,
            color: isDark ? Colors.grey[600] : Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            'No rankings yet',
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start learning to see your rank!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: subtitleColor,
            ),
          ),
        ],
      ),
    );
  }
}

