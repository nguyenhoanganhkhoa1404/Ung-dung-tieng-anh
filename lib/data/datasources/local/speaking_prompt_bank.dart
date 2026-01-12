import 'dart:math';

class SpeakingPrompt {
  final String id;
  final int part; // 1, 2, 3
  final String title;
  final String prompt;
  final List<String> tips;

  const SpeakingPrompt({
    required this.id,
    required this.part,
    required this.title,
    required this.prompt,
    required this.tips,
  });
}

class SpeakingPromptBank {
  static List<SpeakingPrompt> forPart(int part) {
    switch (part) {
      case 1:
        return _part1();
      case 2:
        return _part2();
      case 3:
        return _part3();
      default:
        return _part1();
    }
  }

  static SpeakingPrompt randomForPart(int part) {
    final list = forPart(part);
    list.shuffle(Random());
    return list.first;
  }

  static List<SpeakingPrompt> _part1() {
    return const [
      SpeakingPrompt(
        id: 'sp1_self_1',
        part: 1,
        title: 'Introduce yourself',
        prompt: 'Please introduce yourself. What do you do/study, and what do you like doing in your free time?',
        tips: [
          'Name + background (student/worker)',
          'Daily routine (short)',
          'Hobby + reason',
        ],
      ),
      SpeakingPrompt(
        id: 'sp1_habit_1',
        part: 1,
        title: 'Daily habits',
        prompt: 'Describe your daily routine. What do you usually do in the morning and in the evening?',
        tips: [
          'Use present simple',
          'Mention 3–5 activities',
          'Add time expressions (usually, often)',
        ],
      ),
      SpeakingPrompt(
        id: 'sp1_hobby_1',
        part: 1,
        title: 'Hobbies',
        prompt: 'What hobbies do you have? Why do you enjoy them?',
        tips: [
          'Give 1–2 hobbies',
          'Explain reasons',
          'Give an example',
        ],
      ),
    ];
  }

  static List<SpeakingPrompt> _part2() {
    return const [
      SpeakingPrompt(
        id: 'sp2_friend_1',
        part: 2,
        title: 'A person you admire',
        prompt: 'Describe a person you admire (a friend, family member, or public figure). Explain why you admire them.',
        tips: [
          'Who they are + relationship',
          'What they are like (adjectives)',
          'A story/example that shows their qualities',
        ],
      ),
      SpeakingPrompt(
        id: 'sp2_trip_1',
        part: 2,
        title: 'A memorable trip',
        prompt: 'Talk about a memorable trip you took. Where did you go, who with, and what made it special?',
        tips: [
          'Place + time',
          'Activities',
          'Feelings + lesson',
        ],
      ),
      SpeakingPrompt(
        id: 'sp2_place_1',
        part: 2,
        title: 'A place you love',
        prompt: 'Describe a place you love visiting. What does it look like and why is it important to you?',
        tips: [
          'Location + description',
          'What you do there',
          'Why it matters',
        ],
      ),
      SpeakingPrompt(
        id: 'sp2_memory_1',
        part: 2,
        title: 'An unforgettable memory',
        prompt: 'Tell a story about an unforgettable memory from your life. What happened and how did you feel?',
        tips: [
          'Beginning → middle → ending',
          'Use past tenses',
          'Describe emotions',
        ],
      ),
    ];
  }

  static List<SpeakingPrompt> _part3() {
    return const [
      SpeakingPrompt(
        id: 'sp3_tech_1',
        part: 3,
        title: 'Technology & life',
        prompt: 'How does technology affect our daily lives? Discuss both advantages and disadvantages.',
        tips: [
          'Give 2 advantages + examples',
          'Give 2 disadvantages + examples',
          'Conclude with your opinion',
        ],
      ),
      SpeakingPrompt(
        id: 'sp3_online_1',
        part: 3,
        title: 'Online vs offline learning',
        prompt: 'Is online learning better than offline learning? Why or why not?',
        tips: [
          'Compare flexibility vs interaction',
          'Give personal experience',
          'Provide a balanced conclusion',
        ],
      ),
      SpeakingPrompt(
        id: 'sp3_youth_1',
        part: 3,
        title: 'Changes in young people',
        prompt: 'Do you think young people today are different from the past? In what ways?',
        tips: [
          'Mention lifestyle/values',
          'Role of technology',
          'Give examples',
        ],
      ),
    ];
  }
}


