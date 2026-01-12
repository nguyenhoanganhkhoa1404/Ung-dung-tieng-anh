import 'package:flutter/material.dart';

import '../../../data/datasources/local/grammar_question_bank.dart';
import 'practice_quiz_page.dart';

class GrammarPracticePage extends StatelessWidget {
  const GrammarPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = GrammarQuestionBank.buildGrammarBank();
    return PracticeQuizPage(
      title: 'Grammar',
      subtitle: 'Random 5 questions • Modals / Conditionals / Passive...',
      icon: Icons.school_rounded,
      color: const Color(0xFFFF6584),
      questionBank: bank,
    );
  }
}


