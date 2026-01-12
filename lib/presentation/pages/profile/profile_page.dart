import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/l10n/app_localizations.dart';
import '../../../core/routes/app_router.dart';

/// Màn hình Profile với thống kê và cài đặt
class ProfilePage extends StatelessWidget {
  final String userId;

  const ProfilePage({
    super.key,
    required this.userId,
  });

  String _formatLearningTimeFromMinutes(int totalMinutes) {
    if (totalMinutes <= 0) return '0m';
    if (totalMinutes < 60) return '${totalMinutes}m';
    final hours = totalMinutes / 60.0;
    return '${hours.toStringAsFixed(1)}h';
  }

  String _formatLanguageLabel(String code) {
    // Keep as a fallback; UI will prefer localized labels via context.
    return code == 'en' ? 'English' : 'Tiếng Việt';
  }

  Future<void> _setThemeMode(bool dark) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.keyThemeMode, dark ? 'dark' : 'light');
  }

  Future<void> _setBoolSetting(String key, bool value) async {
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(key, value);
  }

  Future<void> _pickLanguage(BuildContext context, String currentCode) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                context.l10n.t('choose_language'),
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(context.l10n.t('lang_vi')),
                trailing: currentCode == 'vi'
                    ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
                    : null,
                onTap: () => Navigator.pop(ctx, 'vi'),
              ),
              ListTile(
                leading: const Icon(Icons.language_rounded),
                title: Text(context.l10n.t('lang_en')),
                trailing: currentCode == 'en'
                    ? const Icon(Icons.check_rounded, color: Color(0xFF6C63FF))
                    : null,
                onTap: () => Navigator.pop(ctx, 'en'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );

    if (selected == null) return;
    final box = Hive.box(AppConstants.settingsBox);
    await box.put(AppConstants.keyLanguage, selected);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${context.l10n.t('selected_prefix')} ${_formatLanguageLabel(selected)}',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _logout(BuildContext context) async {
    // Prefer bloc logout (clears local prefs too), fallback to Firebase signOut
    try {
      context.read<AuthBloc>().add(AuthLogoutRequested());
    } catch (_) {
      await FirebaseAuth.instance.signOut();
    }

    if (context.mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRouter.login,
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final settingsBox = Hive.box(AppConstants.settingsBox);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF121212) : Colors.grey[50];

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, snapshot) {
            final userData =
                snapshot.data?.data() as Map<String, dynamic>? ?? {};
            final fallbackName = user?.displayName ??
                (user?.email?.split('@').first ?? 'User');
            final rawName = (userData['name'] ?? userData['displayName'])
                ?.toString()
                .trim();
            final name = (rawName == null || rawName.isEmpty)
                ? fallbackName
                : rawName;
            final email = user?.email ?? 'email@example.com';

            final totalXp = (userData['total_xp'] ??
                    userData['xp'] ??
                    userData['totalXp'] ??
                    0) as num;
            final currentStreak = (userData['current_streak'] ??
                    userData['streak'] ??
                    userData['currentStreak'] ??
                    0) as num;
            final totalMinutes = (userData['total_learning_minutes'] ??
                    userData['learning_minutes'] ??
                    userData['totalLearningMinutes'] ??
                    0) as num;

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 140),
              child: Column(
                children: [
                  // Header with gradient
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6C63FF), Color(0xFF8B7FFF)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.vertical(
                        bottom: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        GFAvatar(
                          backgroundImage: NetworkImage(
                            user?.photoURL ??
                                'https://ui-avatars.com/api/?name=$name&background=fff&color=6C63FF&size=200',
                          ),
                          shape: GFAvatarShape.circle,
                          size: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          name,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          email,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stats Cards
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: _buildStatCard(
                                context,
                                '⭐ Total XP',
                                '${totalXp.toInt()}',
                                const Color(0xFFFFD700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _buildStatCard(
                                context,
                                '🔥 Streak',
                                '${currentStreak.toInt()} days',
                                const Color(0xFFFF6584),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildStatCard(
                          context,
                          '⏱️ Learning Time',
                          _formatLearningTimeFromMinutes(totalMinutes.toInt()),
                          const Color(0xFF4CAF50),
                          fullWidth: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Settings Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.t('settings'),
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ValueListenableBuilder(
                          valueListenable: settingsBox.listenable(),
                          builder: (context, box, _) {
                            final themeMode =
                                (box.get(AppConstants.keyThemeMode) ?? 'light')
                                    .toString();
                            final isDark = themeMode == 'dark';

                            final notificationsEnabled =
                                (box.get(AppConstants.keyNotificationsEnabled) ??
                                        true) ==
                                    true;
                            final soundEnabled =
                                (box.get(AppConstants.keySoundEnabled) ?? true) ==
                                    true;
                            final languageCode =
                                (box.get(AppConstants.keyLanguage) ?? 'vi')
                                    .toString();

                            return Column(
                              children: [
                                _buildSwitchTile(
                                  context,
                                  icon: Icons.notifications_outlined,
                                  title: context.l10n.t('notifications'),
                                  subtitle: context.l10n.t('notifications_sub'),
                                  value: notificationsEnabled,
                                  onChanged: (v) => _setBoolSetting(
                                    AppConstants.keyNotificationsEnabled,
                                    v,
                                  ),
                                ),
                                _buildSwitchTile(
                                  context,
                                  icon: Icons.volume_up_outlined,
                                  title: context.l10n.t('sound'),
                                  subtitle: context.l10n.t('sound_sub'),
                                  value: soundEnabled,
                                  onChanged: (v) => _setBoolSetting(
                                    AppConstants.keySoundEnabled,
                                    v,
                                  ),
                                ),
                                _buildLanguageTile(
                                  context,
                                  icon: Icons.language_outlined,
                                  title: context.l10n.t('language'),
                                  subtitle: _formatLanguageLabel(languageCode),
                                  onTap: () => _pickLanguage(context, languageCode),
                                ),
                                _buildSwitchTile(
                                  context,
                                  icon: Icons.dark_mode_outlined,
                                  title: context.l10n.t('dark_mode'),
                                  subtitle: context.l10n.t('dark_mode_sub'),
                                  value: isDark,
                                  onChanged: (v) => _setThemeMode(v),
                                ),
                                _buildActionTile(
                                  context,
                                  icon: Icons.help_outline,
                                  title: context.l10n.t('help_support'),
                                  subtitle: context.l10n.t('help_support_sub'),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.l10n.t('help_support'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                _buildActionTile(
                                  context,
                                  icon: Icons.privacy_tip_outlined,
                                  title: context.l10n.t('privacy_policy'),
                                  subtitle: context.l10n.t('privacy_policy_sub'),
                                  onTap: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          context.l10n.t('privacy_policy'),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildLogoutButton(context),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    String value,
    Color color, {
    bool fullWidth = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final labelColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : color.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            fullWidth ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: labelColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTileShell(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF2D3748);
    final subtitleColor = isDark ? Colors.grey[400] : Colors.grey[600];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.3) : Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(isDark ? 0.2 : 0.10),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF), size: 22),
        ),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: GoogleFonts.poppins(
            fontSize: 13,
            color: subtitleColor,
          ),
        ),
        trailing: trailing,
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return _buildTileShell(
      context,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF6C63FF),
      ),
    );
  }

  Widget _buildLanguageTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _buildTileShell(
      context,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildActionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return _buildTileShell(
      context,
      icon: icon,
      title: title,
      subtitle: subtitle,
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return GFButton(
      onPressed: () => _logout(context),
      text: context.l10n.t('logout'),
      fullWidthButton: true,
      size: GFSize.LARGE,
      shape: GFButtonShape.pills,
      color: Colors.red,
      icon: const Icon(
        Icons.logout,
        color: Colors.white,
      ),
      textStyle: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
    );
  }
}
