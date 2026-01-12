# LingoFlow Structure

Cấu trúc mới theo mô tả LingoFlow với khả năng toggle.

## 📂 Cấu trúc

```
lib/src/
├── config/
│   └── app_config.dart          # Toggle configuration
├── theme/
│   ├── colors.dart              # Ocean Blue #2A67FF, Soft Coral
│   ├── typography.dart          # Lexend font setup
│   └── app_theme.dart           # Combined theme
├── components/
│   ├── flashcard.dart           # Flashcard với animation
│   ├── progress_bar.dart        # Reusable progress bar
│   ├── course_tile.dart         # Course card với icon + progress
│   └── achievement_badge.dart  # Badge/medal component
├── screens/
│   ├── home_screen.dart         # Homepage (Dashboard)
│   ├── library_screen.dart      # Library Page
│   ├── learning_module_screen.dart  # Vocabulary Flashcard
│   ├── ai_chat_screen.dart      # AI Chat Page
│   └── profile_screen.dart      # Profile Page
├── navigation/
│   └── app_navigator.dart       # BottomTab + Stack navigation
└── utils/
    └── helpers.dart             # Common functions
```

## 🎨 Theme

- **Primary Color**: Ocean Blue #2A67FF
- **Secondary Color**: Soft Coral #FF6B9D
- **Border Radius**: 24px
- **Font**: Lexend (via Google Fonts)

## 🔧 Toggle Configuration

Tất cả các tính năng có thể toggle trong `lib/src/config/app_config.dart`:

- `useLingoFlowTheme`: Bật/tắt theme mới
- `useLingoFlowNavigation`: Bật/tắt navigation mới
- `useLingoFlowComponents`: Bật/tắt components mới
- `useLingoFlowScreens`: Bật/tắt screens mới
- `enableAIChat`: Bật/tắt AI Chat
- `enableFlashcardAnimation`: Bật/tắt animation cho flashcard
- `enableProgressBarAnimation`: Bật/tắt animation cho progress bar

## 📱 Screens

### HomeScreen
- Greeting header với avatar + streak counter 🔥
- Current Lesson card với progress bar
- Recommended courses: horizontal scroll
- Bottom Navigation Bar

### LibraryScreen
- Search bar
- Tabs/filters: My Courses, New Arrivals, Difficulty Levels
- Course cards với progress
- Vocabulary Collections

### LearningModuleScreen
- Thin progress bar ở top
- Central flashcard: illustration + word + phonetic + speaker icon
- Glowing Ocean Blue microphone button với pulse animation

### AIChatScreen
- Messaging app style
- AI bubble (light blue, left)
- User bubble (white với Ocean Blue border, right)
- Smart Reply chips
- Grammar correction tooltip

### ProfileScreen
- Avatar + name + level
- Progress visualization
- Achievements grid
- Settings list

## 🧩 Components

### Flashcard
- Image placeholder hoặc actual image
- Word text
- Phonetic transcription
- Speaker icon
- Large circular Record button với animation

### ProgressBar
- Reusable progress bar
- Optional percentage display
- Optional label
- Animation support

### CourseTile
- Rounded course card
- Icon với gradient
- Progress bar
- Difficulty badge

### AchievementBadge
- Badge/medal component
- Unlocked/locked states
- Icon với gradient
- Description

## 🔄 Migration

Code cũ vẫn hoạt động bình thường. Để sử dụng cấu trúc mới:

1. Set `AppConfig.useLingoFlowTheme = true` trong `app_config.dart`
2. App sẽ tự động sử dụng theme, components, và screens mới
3. Tất cả logic cũ được giữ nguyên, chỉ wrap trong structure mới

## 📝 Notes

- Tất cả logic và code cũ được giữ nguyên
- Chỉ thêm structure mới và wrap existing code
- Có thể toggle bất kỳ feature nào
- Lexend font được load qua Google Fonts

