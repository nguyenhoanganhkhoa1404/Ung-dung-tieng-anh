import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Lightweight in-app localization (VI/EN) driven by `settings_box['language']`.
///
/// This avoids ARB/codegen and is enough for a small set of strings.
class AppLocalizations {
  final Locale locale;

  const AppLocalizations(this.locale);

  static const supportedLocales = <Locale>[
    Locale('vi'),
    Locale('en'),
  ];

  static const _strings = <String, Map<String, String>>{
    'en': {
      // Common
      'app_title': 'English Learning',
      'settings': 'Settings',
      'settings_subtitle': 'Customize your experience',
      'language': 'Language',
      'dark_mode': 'Dark Mode',
      'notifications': 'Notifications',
      'sound': 'Sound',
      'help_support': 'Help & Support',
      'privacy_policy': 'Privacy Policy',
      'logout': 'Logout',

      // Settings subtitles
      'notifications_sub': 'Study reminders',
      'sound_sub': 'App sound effects',
      'dark_mode_sub': 'Use dark theme',
      'language_sub': 'Change app language',
      'help_support_sub': 'Contact support',
      'privacy_policy_sub': 'Read privacy policy',

      // Language names
      'lang_vi': 'Vietnamese',
      'lang_en': 'English',
      'choose_language': 'Choose language',
      'selected_prefix': 'Selected:',

      // Bottom nav
      'nav_home': 'Home',
      'nav_board': 'Board',
      'nav_learning': 'Learning',
      'nav_rank': 'Rank',
      'nav_profile': 'Profile',
    },
    'vi': {
      // Common
      'app_title': 'Ứng Dụng Học Tiếng Anh',
      'settings': 'Cài đặt',
      'settings_subtitle': 'Tùy chỉnh theo ý bạn',
      'language': 'Ngôn ngữ',
      'dark_mode': 'Chế độ tối',
      'notifications': 'Thông báo',
      'sound': 'Âm thanh',
      'help_support': 'Trợ giúp & Hỗ trợ',
      'privacy_policy': 'Chính sách bảo mật',
      'logout': 'Đăng xuất',

      // Settings subtitles
      'notifications_sub': 'Nhắc nhở học tập',
      'sound_sub': 'Âm thanh trong app',
      'dark_mode_sub': 'Giao diện tối',
      'language_sub': 'Đổi ngôn ngữ ứng dụng',
      'help_support_sub': 'Liên hệ hỗ trợ',
      'privacy_policy_sub': 'Xem chính sách bảo mật',

      // Language names
      'lang_vi': 'Tiếng Việt',
      'lang_en': 'English',
      'choose_language': 'Chọn ngôn ngữ',
      'selected_prefix': 'Đã chọn:',

      // Bottom nav
      'nav_home': 'Trang chủ',
      'nav_board': 'Bảng',
      'nav_learning': 'Học',
      'nav_rank': 'Xếp hạng',
      'nav_profile': 'Cá nhân',
    },
  };

  static AppLocalizations of(BuildContext context) {
    final result = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(result != null, 'No AppLocalizations found in context');
    return result!;
  }

  String t(String key) {
    final lang = locale.languageCode;
    return _strings[lang]?[key] ?? _strings['en']?[key] ?? key;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocalizations.supportedLocales.any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(AppLocalizations(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}


