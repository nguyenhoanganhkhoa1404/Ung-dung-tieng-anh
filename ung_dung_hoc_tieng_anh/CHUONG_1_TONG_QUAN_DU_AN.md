# CHƯƠNG 1: TỔNG QUAN DỰ ÁN

## 1. Lý do chọn đề tài

Dự án phát triển ứng dụng học tiếng Anh LingoFlow này nhằm giải quyết các nhu cầu và vấn đề cốt lõi sau:

● **Thiếu công cụ học tập tích hợp**: Người dùng thường phải sử dụng nhiều ứng dụng riêng biệt để học từ vựng, luyện ngữ pháp, thực hành giao tiếp và theo dõi tiến độ học tập. Ứng dụng này cung cấp một nền tảng học tập tổng hợp giúp quản lý việc học tiếng Anh toàn diện, tiết kiệm thời gian và tạo sự kết nối trong quá trình học tập.

● **Nhu cầu cá nhân hóa cao**: Mỗi người học có trình độ và mục tiêu học tập khác nhau (từ cơ bản A1 đến nâng cao C2, học để thi cử, giao tiếp hay công việc). Ứng dụng cung cấp khả năng học từ vựng theo từng cấp độ (A1, A2, B1, B2, C1, C2), flashcard với hình ảnh minh họa, và các bài tập luyện tập phân loại theo kỹ năng giúp người dùng dễ dàng tùy chỉnh lộ trình học tập phù hợp với bản thân.

● **Khoảng trống về phương pháp học tập hiệu quả**: Nhiều người học gặp khó khăn do thiếu phương pháp học tập khoa học, không biết cách ghi nhớ từ vựng lâu dài, phát âm đúng, và sử dụng từ trong ngữ cảnh phù hợp. Ứng dụng cung cấp tính năng học từ vựng thông qua flashcard, bài tập trắc nghiệm có giải thích chi tiết, và Text-to-Speech (TTS) để giúp người dùng luyện phát âm chuẩn, lấp đầy khoảng trống kiến thức này.

● **Thiếu động lực và theo dõi tiến độ**: Học tiếng Anh là quá trình dài hạn, người học thường mất động lực do không thấy được sự tiến bộ rõ ràng. Ứng dụng giúp theo dõi lịch sử học tập, hiển thị số lượng từ vựng đã học, số ngày học liên tiếp (streak), và thống kê tiến độ theo từng cấp độ, tạo động lực và giúp người dùng duy trì thói quen học tập đều đặn.

● **Nhu cầu thực hành giao tiếp**: Người học cần một môi trường để thực hành giao tiếp và nhận phản hồi về khả năng sử dụng tiếng Anh. Ứng dụng tích hợp tính năng AI Chat để người dùng có thể luyện tập giao tiếp với trợ lý AI, nhận gợi ý sửa lỗi ngữ pháp và cải thiện cách diễn đạt.

## 2. Mục tiêu của dự án

| Mục tiêu | Mô tả |
|----------|-------|
| **Giúp người dùng học tiếng Anh hiệu quả** | Ứng dụng hướng đến việc hỗ trợ người dùng học và cải thiện tiếng Anh hàng ngày thông qua các phương pháp học tập khoa học: học từ vựng theo cấp độ, luyện tập với flashcard, làm bài tập trắc nghiệm, và thực hành giao tiếp với AI. |
| **Cung cấp công cụ dễ sử dụng** | Phát triển giao diện thân thiện, trực quan, cho phép người dùng dễ dàng tìm kiếm từ vựng, học tập, theo dõi tiến độ và quản lý lộ trình học tập cá nhân. Giao diện được thiết kế theo phong cách "Friendly – Human – Imperfect but intuitive" để tạo cảm giác gần gũi, tự nhiên. |
| **Tích hợp dữ liệu thời gian thực** | Sử dụng Firebase (Firestore, Firebase Auth) để lưu trữ và đồng bộ dữ liệu (ví dụ: từ vựng, lịch sử học tập, tiến độ, thành tích) trên nhiều thiết bị, đảm bảo người dùng có thể tiếp tục học tập mọi lúc mọi nơi. |
| **Khuyến khích học tập đều đặn** | Thông qua tính năng theo dõi streak (chuỗi ngày học liên tiếp), hiển thị thống kê tiến độ, và hệ thống thành tích (achievements), ứng dụng khuyến khích người dùng duy trì thói quen học tập hàng ngày và đạt được mục tiêu học tập cá nhân. |
| **Hỗ trợ học tập đa cấp độ** | Ứng dụng cung cấp nội dung học tập từ trình độ cơ bản (A1) đến nâng cao (C2), phù hợp với nhiều đối tượng người học, từ người mới bắt đầu đến người muốn nâng cao trình độ. |

## 3. Đối tượng sử dụng

Ứng dụng hướng tới các nhóm người có nhu cầu học và cải thiện tiếng Anh, bao gồm:

● **Người mới bắt đầu học tiếng Anh**: Cần một công cụ để học từ vựng cơ bản, làm quen với ngữ pháp, luyện phát âm, và xây dựng nền tảng tiếng Anh vững chắc. Ứng dụng cung cấp nội dung từ cấp độ A1, A2 với giải thích chi tiết, ví dụ minh họa, và cách phát âm chuẩn.

● **Học sinh, sinh viên**: Cần một công cụ để ôn tập từ vựng, luyện tập các dạng bài tập trắc nghiệm, chuẩn bị cho các kỳ thi tiếng Anh. Ứng dụng cung cấp tính năng học từ vựng theo cấp độ, làm bài tập có đáp án và giải thích chi tiết, giúp người học hiểu rõ lỗi sai và cải thiện kỹ năng.

● **Người đi làm cần cải thiện tiếng Anh**: Cần học từ vựng chuyên ngành, luyện kỹ năng giao tiếp trong công việc, và sử dụng tiếng Anh trong môi trường làm việc quốc tế. Ứng dụng cung cấp tính năng AI Chat để thực hành giao tiếp, học từ vựng theo chủ đề, và luyện tập với các tình huống thực tế.

● **Người muốn nâng cao trình độ tiếng Anh (B1, B2, C1, C2)**: Đã có nền tảng tiếng Anh tốt, muốn mở rộng vốn từ vựng nâng cao, cải thiện khả năng sử dụng ngôn ngữ một cách linh hoạt và tự nhiên. Ứng dụng cung cấp nội dung học tập từ cấp độ trung cấp đến cao cấp, giúp người học nâng cao trình độ một cách có hệ thống.

● **Người học tự học tại nhà**: Cần một công cụ để tự học tiếng Anh một cách độc lập, không phụ thuộc vào giáo viên hay lớp học. Ứng dụng cung cấp đầy đủ các tính năng học tập, theo dõi tiến độ, và tạo động lực học tập, phù hợp cho việc tự học hiệu quả.

---

**Ghi chú**: Chương này trình bày tổng quan về lý do chọn đề tài, mục tiêu và đối tượng sử dụng của ứng dụng học tiếng Anh LingoFlow, làm cơ sở cho các chương tiếp theo về phân tích thiết kế và triển khai hệ thống.

