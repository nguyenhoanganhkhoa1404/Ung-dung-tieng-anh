import 'dart:math';

class WritingPrompt {
  final String id;
  final String category; // e.g. "Miêu tả"
  final String title;
  final String prompt;
  final List<String> requirements;

  const WritingPrompt({
    required this.id,
    required this.category,
    required this.title,
    required this.prompt,
    required this.requirements,
  });
}

class WritingPromptBank {
  static const categories = [
    'Miêu tả',
    'Kể chuyện',
    'Nghị luận – quan điểm',
    'So sánh',
    'Giải thích',
    'Thuyết phục',
    'Phản biện',
  ];

  static List<WritingPrompt> forCategory(String category) {
    switch (category) {
      case 'Miêu tả':
        return _description();
      case 'Kể chuyện':
        return _story();
      case 'Nghị luận – quan điểm':
        return _opinion();
      case 'So sánh':
        return _comparison();
      case 'Giải thích':
        return _explanation();
      case 'Thuyết phục':
        return _persuasion();
      case 'Phản biện':
        return _counterArgument();
      default:
        return _description();
    }
  }

  static WritingPrompt randomOne(String category) {
    final list = forCategory(category);
    list.shuffle(Random());
    return list.first;
  }

  static const _req = [
    'Độ dài: 120–250 từ',
    'Có mở bài – thân bài – kết bài',
    'Dùng từ nối + ví dụ/dẫn chứng',
  ];

  static List<WritingPrompt> _description() {
    return const [
      WritingPrompt(
        id: 'w_desc_place',
        category: 'Miêu tả',
        title: 'A place you love',
        prompt: 'Describe a place you love visiting. Explain what it looks like and why it is special to you.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_desc_person',
        category: 'Miêu tả',
        title: 'An important person',
        prompt: 'Describe an important person in your life. Explain how they influenced you.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_desc_day',
        category: 'Miêu tả',
        title: 'A special day',
        prompt: 'Describe a special day you will never forget. What happened and why was it meaningful?',
        requirements: _req,
      ),
    ];
  }

  static List<WritingPrompt> _story() {
    return const [
      WritingPrompt(
        id: 'w_story_school',
        category: 'Kể chuyện',
        title: 'A school memory',
        prompt: 'Write about a memorable moment from your school days. Describe the situation and what you learned.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_story_fail',
        category: 'Kể chuyện',
        title: 'A failure and a lesson',
        prompt: 'Describe a time you failed at something and what you learned from that experience.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_story_trip',
        category: 'Kể chuyện',
        title: 'A memorable trip',
        prompt: 'Write about a memorable trip you took. Include where you went, who you went with, and why it was special.',
        requirements: _req,
      ),
    ];
  }

  static List<WritingPrompt> _opinion() {
    return const [
      WritingPrompt(
        id: 'w_op_money',
        category: 'Nghị luận – quan điểm',
        title: 'Can money buy happiness?',
        prompt: 'Do you think money can buy happiness? Give reasons and examples to support your opinion.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_op_family',
        category: 'Nghị luận – quan điểm',
        title: 'The role of family',
        prompt: 'What role does family play in a person’s life? Discuss your opinion with examples.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_op_social',
        category: 'Nghị luận – quan điểm',
        title: 'Social media: good or bad?',
        prompt: 'Is social media more beneficial or harmful? Explain your view with examples.',
        requirements: _req,
      ),
    ];
  }

  static List<WritingPrompt> _comparison() {
    return const [
      WritingPrompt(
        id: 'w_cmp_city',
        category: 'So sánh',
        title: 'City vs countryside',
        prompt: 'Compare living in the city with living in the countryside. Which do you prefer and why?',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_cmp_learning',
        category: 'So sánh',
        title: 'Online vs offline learning',
        prompt: 'Compare online learning and offline learning. Discuss advantages and disadvantages of each.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_cmp_books',
        category: 'So sánh',
        title: 'Printed books vs e-books',
        prompt: 'Compare printed books and e-books. Which one is better for students? Explain your reasons.',
        requirements: _req,
      ),
    ];
  }

  static List<WritingPrompt> _explanation() {
    return const [
      WritingPrompt(
        id: 'w_exp_english',
        category: 'Giải thích',
        title: 'Why English is important',
        prompt: 'Explain why learning English is important today. Provide reasons and examples.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_exp_reading',
        category: 'Giải thích',
        title: 'Why people should read books',
        prompt: 'Explain why reading books is beneficial. Include examples from your experience.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_exp_sport',
        category: 'Giải thích',
        title: 'Benefits of exercise',
        prompt: 'Explain the benefits of doing regular exercise for students and adults.',
        requirements: _req,
      ),
    ];
  }

  static List<WritingPrompt> _persuasion() {
    return const [
      WritingPrompt(
        id: 'w_per_env',
        category: 'Thuyết phục',
        title: 'Protect the environment',
        prompt: 'Write a persuasive paragraph encouraging people to protect the environment. Use clear reasons and examples.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_per_lifelong',
        category: 'Thuyết phục',
        title: 'Lifelong learning',
        prompt: 'Convince students to keep learning throughout their lives. Give reasons and examples.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_per_social',
        category: 'Thuyết phục',
        title: 'Join social activities',
        prompt: 'Encourage your classmates to join social activities at school. Explain the benefits.',
        requirements: _req,
      ),
    ];
  }

  static List<WritingPrompt> _counterArgument() {
    return const [
      WritingPrompt(
        id: 'w_cnt_online',
        category: 'Phản biện',
        title: 'Against “online learning is better”',
        prompt: 'Some people say online learning is always better than offline learning. Write a rebuttal and support your ideas.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_cnt_money',
        category: 'Phản biện',
        title: 'Against “money measures success”',
        prompt: 'Some people believe money is the main measure of success. Write a rebuttal with reasons and examples.',
        requirements: _req,
      ),
      WritingPrompt(
        id: 'w_cnt_lonely',
        category: 'Phản biện',
        title: 'Against “technology makes people lonely”',
        prompt: 'Some people say technology makes people lonely. Write a rebuttal and explain your position.',
        requirements: _req,
      ),
    ];
  }
}


