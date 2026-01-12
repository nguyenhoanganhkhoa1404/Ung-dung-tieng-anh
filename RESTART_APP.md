# 🔄 Hướng dẫn xem giao diện mới

## ⚠️ Quan trọng

Các thay đổi UI/UX đã được áp dụng trong code, nhưng bạn cần **HOT RESTART** (không phải hot reload) để thấy thay đổi.

## 🚀 Cách xem giao diện mới

### Option 1: Hot Restart trong IDE
1. Trong VS Code / Android Studio
2. Nhấn **Ctrl+Shift+F5** (hoặc **Cmd+Shift+F5** trên Mac)
3. Hoặc click vào nút **Restart** (🔄) trên debug toolbar

### Option 2: Restart từ Terminal
```powershell
# Dừng app hiện tại (Ctrl+C)
# Sau đó chạy lại:
flutter run
```

### Option 3: Full Restart
```powershell
# 1. Dừng app
# 2. Clean và chạy lại
flutter clean
flutter pub get
flutter run
```

## ✅ Các thay đổi đã được áp dụng

### 1. FlashcardScreen
- ✅ Title: "Flashcard" → "Học từ mới"
- ✅ Progress: "X / Y" → "Từ X / Y"
- ✅ Hint: "Chạm vào thẻ để xem nghĩa"
- ✅ Spacing và animation đã được điều chỉnh

### 2. HomePage
- ✅ Greeting: "Chào $name! 👋"
- ✅ Subtitle: "Hôm nay học gì nhỉ?"
- ✅ Title: "Chọn kỹ năng"
- ✅ Streak: "Chuỗi ngày học", "5 ngày liên tiếp! 🔥"
- ✅ Header: Bỏ gradient, dùng solid color

### 3. Vocabulary Learning
- ✅ Stats: "Đúng/Sai/Còn lại"
- ✅ Feedback: "Đúng rồi! 👍" / "Xem lại nhé"
- ✅ Buttons: "Câu tiếp theo", "Xem kết quả", "Làm lại"

### 4. Components
- ✅ Flashcard: Border radius 20px, spacing điều chỉnh
- ✅ Colors: Màu ấm hơn, không dùng gradient phức tạp
- ✅ Animation: Nhẹ hơn (200ms, scale 1.08)

## 🔍 Kiểm tra

Sau khi restart, bạn sẽ thấy:
- Text tiếng Việt tự nhiên hơn
- Spacing nhẹ nhàng hơn
- Màu sắc ấm và dịu hơn
- Font size vừa phải, không quá to
- Animation mượt mà, tự nhiên

## 💡 Lưu ý

- **Hot Reload (r)** không đủ - cần **Hot Restart (R)**
- Một số thay đổi theme cần full restart
- Nếu vẫn chưa thấy, thử `flutter clean` rồi chạy lại

