import 'package:flutter/material.dart';

import '../../../data/datasources/local/grammar_question_bank.dart';
import 'practice_quiz_page.dart';

class TensesPracticePage extends StatelessWidget {
  const TensesPracticePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bank = GrammarQuestionBank.buildTensesBank();
    return PracticeQuizPage(
      title: 'Tenses',
      subtitle: 'Random 5 questions • Present / Past / Future',
      icon: Icons.schedule_rounded,
      color: const Color(0xFFEC407A),
      questionBank: bank,
    );
  }
}


