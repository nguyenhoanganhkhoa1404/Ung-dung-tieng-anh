/// ============================================================================
/// Grammar Question Bank (Local, generated)
/// - Tenses bank: vài trăm câu (present/past/future/perfect/continuous...)
/// - Grammar bank: vài trăm câu (modals/conditionals/passive/articles/prepositions...)
/// Mỗi page sẽ random 5 câu từ bank này.
/// ============================================================================

class PracticeQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const PracticeQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });
}

class GrammarQuestionBank {
  // ===========================================================================
  // TENSES (12 groups) - each group provides its own bank
  // ===========================================================================
  static List<PracticeQuestion> presentSimple() =>
      _generatePresentSimple(count: 80);

  static List<PracticeQuestion> presentContinuous() =>
      _generatePresentContinuous(count: 70);

  static List<PracticeQuestion> presentPerfectSimple() =>
      _generatePresentPerfectSimple(count: 60);

  static List<PracticeQuestion> presentPerfectContinuous() =>
      _generatePresentPerfectContinuous(count: 50);

  static List<PracticeQuestion> pastSimple() => _generatePastSimple(count: 70);

  static List<PracticeQuestion> pastContinuous() =>
      _generatePastContinuous(count: 60);

  static List<PracticeQuestion> pastPerfectSimple() =>
      _generatePastPerfectSimple(count: 50);

  static List<PracticeQuestion> pastPerfectContinuous() =>
      _generatePastPerfectContinuous(count: 40);

  static List<PracticeQuestion> futureSimple() => _generateFutureSimple(count: 60);

  static List<PracticeQuestion> futureContinuous() =>
      _generateFutureContinuous(count: 50);

  static List<PracticeQuestion> futurePerfectSimple() =>
      _generateFuturePerfectSimple(count: 45);

  static List<PracticeQuestion> futurePerfectContinuous() =>
      _generateFuturePerfectContinuous(count: 40);

  // ===========================================================================
  // GRAMMAR (CEFR + topics)
  // Counts follow the ranges user requested.
  // ===========================================================================
  static List<PracticeQuestion> grammarA1A2Basic() =>
      _generateA1A2Basic(count: 25); // 20–30

  static List<PracticeQuestion> grammarB1() => _generateB1(count: 28); // 25–30

  static List<PracticeQuestion> grammarB2() => _generateB2(count: 22); // 20–25

  static List<PracticeQuestion> grammarC1C2() => _generateC1C2(count: 18); // 15–20

  static List<PracticeQuestion> conditionals() =>
      _generateConditionals(count: 5); // 4–5

  static List<PracticeQuestion> passiveVoice() =>
      _generatePassive(count: 6); // 4–6

  static List<PracticeQuestion> clauses() => _generateClauses(count: 12); // 10+

  static List<PracticeQuestion> modalVerbs() => _generateModalVerbs(count: 12);

  static List<PracticeQuestion> gerundInfinitive() =>
      _generateGerundInfinitive(count: 12);

  static List<PracticeQuestion> comparisons() => _generateComparisons(count: 10);

  static List<PracticeQuestion> reportedSpeech() =>
      _generateReportedSpeech(count: 10);

  static List<PracticeQuestion> inversionEmphasis() =>
      _generateInversionEmphasis(count: 10);

  static List<PracticeQuestion> buildTensesBank() {
    return [
      ...presentSimple(),
      ...presentContinuous(),
      ...presentPerfectSimple(),
      ...presentPerfectContinuous(),
      ...pastSimple(),
      ...pastContinuous(),
      ...pastPerfectSimple(),
      ...pastPerfectContinuous(),
      ...futureSimple(),
      ...futureContinuous(),
      ...futurePerfectSimple(),
      ...futurePerfectContinuous(),
    ];
  }

  static List<PracticeQuestion> buildGrammarBank() {
    return [
      ...grammarA1A2Basic(),
      ...grammarB1(),
      ...grammarB2(),
      ...grammarC1C2(),
      ...conditionals(),
      ...passiveVoice(),
      ...clauses(),
      ...modalVerbs(),
      ...gerundInfinitive(),
      ...comparisons(),
      ...reportedSpeech(),
      ...inversionEmphasis(),
    ];
  }
}

// ===========================================================================
// Generators
// ===========================================================================
List<PracticeQuestion> _generatePresentSimple({required int count}) {
  final verbs = _verbs;
  final subjectsS3 = ['He', 'She', 'It'];
  final subjectsOther = ['I', 'You', 'We', 'They'];
  final timeHabit = ['every day', 'on Mondays', 'usually', 'often', 'sometimes'];

  final out = <PracticeQuestion>[];

  for (final s in subjectsS3) {
    for (final v in verbs) {
      for (final t in timeHabit) {
        out.add(PracticeQuestion(
          question: '$s ____ $t.',
          options: [v.base, v.s3, v.past, v.ing],
          correctIndex: 1,
          explanation: 'Present simple: he/she/it + V-s. → ${v.s3}',
        ));
      }
    }
  }

  for (final s in subjectsOther) {
    for (final v in verbs) {
      for (final t in timeHabit) {
        out.add(PracticeQuestion(
          question: '$s ____ $t.',
          options: [v.base, v.s3, v.past, v.ing],
          correctIndex: 0,
          explanation: 'Present simple: I/you/we/they + base verb. → ${v.base}',
        ));
      }
    }
  }

  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePresentContinuous({required int count}) {
  final verbs = _verbs;
  final timeNow = ['right now', 'at the moment', 'currently', 'now'];
  final out = <PracticeQuestion>[];

  for (final v in verbs) {
    for (final t in timeNow) {
      out.add(PracticeQuestion(
        question: 'I ____ ____ $t.',
        options: ['am ${v.ing}', 'is ${v.ing}', 'am ${v.base}', 'was ${v.ing}'],
        correctIndex: 0,
        explanation: 'Present continuous: am + V-ing (I).',
      ));
      out.add(PracticeQuestion(
        question: 'She ____ ____ $t.',
        options: ['is ${v.ing}', 'are ${v.ing}', 'is ${v.base}', 'was ${v.ing}'],
        correctIndex: 0,
        explanation: 'Present continuous: is + V-ing (he/she/it).',
      ));
      out.add(PracticeQuestion(
        question: 'They ____ ____ $t.',
        options: ['are ${v.ing}', 'is ${v.ing}', 'were ${v.ing}', 'are ${v.base}'],
        correctIndex: 0,
        explanation: 'Present continuous: are + V-ing (we/they/you).',
      ));
    }
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePresentPerfectSimple({required int count}) {
  final verbs = _verbs;
  final out = <PracticeQuestion>[];
  for (final v in verbs) {
    out.add(PracticeQuestion(
      question: 'I ____ ____ this before.',
      options: ['have ${v.v3}', 'has ${v.v3}', 'had ${v.v3}', 'am ${v.ing}'],
      correctIndex: 0,
      explanation: 'Present perfect: have + V3 (I/you/we/they).',
    ));
    out.add(PracticeQuestion(
      question: 'He ____ ____ this before.',
      options: ['has ${v.v3}', 'have ${v.v3}', 'had ${v.v3}', 'is ${v.ing}'],
      correctIndex: 0,
      explanation: 'Present perfect: has + V3 (he/she/it).',
    ));
    out.add(PracticeQuestion(
      question: 'They ____ ____ already.',
      options: ['have ${v.v3}', 'had ${v.v3}', 'has ${v.v3}', 'are ${v.ing}'],
      correctIndex: 0,
      explanation: 'Present perfect: have + V3.',
    ));
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePresentPerfectContinuous({required int count}) {
  final verbs = _verbs.where((v) => v.base != 'go').toList();
  final out = <PracticeQuestion>[];
  final durations = ['for two hours', 'for a long time', 'since morning', 'since 2020'];
  for (final v in verbs) {
    for (final d in durations) {
      out.add(PracticeQuestion(
        question: 'I ____ ____ ____ $d.',
        options: ['have been ${v.ing}', 'has been ${v.ing}', 'have ${v.v3}', 'am ${v.ing}'],
        correctIndex: 0,
        explanation: 'Present perfect continuous: have/has been + V-ing.',
      ));
      out.add(PracticeQuestion(
        question: 'She ____ ____ ____ $d.',
        options: ['has been ${v.ing}', 'have been ${v.ing}', 'has ${v.v3}', 'is ${v.ing}'],
        correctIndex: 0,
        explanation: 'Present perfect continuous: has been + V-ing (he/she/it).',
      ));
    }
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePastSimple({required int count}) {
  final verbs = _verbs;
  final timePast = ['yesterday', 'last week', 'two days ago', 'in 2019', 'last night'];
  final subjects = ['I', 'You', 'He', 'She', 'We', 'They'];
  final out = <PracticeQuestion>[];
  for (final s in subjects) {
    for (final v in verbs) {
      for (final t in timePast) {
        out.add(PracticeQuestion(
          question: '$s ____ $t.',
          options: [v.past, v.base, v.v3, v.ing],
          correctIndex: 0,
          explanation: 'Past simple: V2 for finished past actions. → ${v.past}',
        ));
      }
    }
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePastContinuous({required int count}) {
  final verbs = _verbs;
  final out = <PracticeQuestion>[];
  for (final v in verbs) {
    out.add(PracticeQuestion(
      question: 'I ____ ____ when you called.',
      options: ['was ${v.ing}', 'were ${v.ing}', 'had ${v.v3}', 'am ${v.ing}'],
      correctIndex: 0,
      explanation: 'Past continuous: was/were + V-ing.',
    ));
    out.add(PracticeQuestion(
      question: 'They ____ ____ when you arrived.',
      options: ['were ${v.ing}', 'was ${v.ing}', 'had ${v.v3}', 'are ${v.ing}'],
      correctIndex: 0,
      explanation: 'Past continuous: were + V-ing (we/they/you).',
    ));
    out.add(PracticeQuestion(
      question: 'He ____ ____ at 7 PM.',
      options: ['was ${v.ing}', 'were ${v.ing}', 'is ${v.ing}', 'had ${v.v3}'],
      correctIndex: 0,
      explanation: 'Past continuous: was + V-ing (he/she/it).',
    ));
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePastPerfectSimple({required int count}) {
  final verbs = _verbs;
  final out = <PracticeQuestion>[];
  for (final v in verbs) {
    out.add(PracticeQuestion(
      question: 'They ____ ____ before we arrived.',
      options: ['had ${v.v3}', 'have ${v.v3}', 'had ${v.past}', 'were ${v.ing}'],
      correctIndex: 0,
      explanation: 'Past perfect: had + V3 (earlier past action).',
    ));
    out.add(PracticeQuestion(
      question: 'I ____ ____ him before, so I recognized him.',
      options: ['had ${v.v3}', 'have ${v.v3}', 'was ${v.ing}', 'did ${v.base}'],
      correctIndex: 0,
      explanation: 'Past perfect for experience before another past event.',
    ));
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generatePastPerfectContinuous({required int count}) {
  final verbs = _verbs.where((v) => v.base != 'go').toList();
  final out = <PracticeQuestion>[];
  final durations = ['for hours', 'for a long time', 'since morning', 'for two years'];
  for (final v in verbs) {
    for (final d in durations) {
      out.add(PracticeQuestion(
        question: 'They ____ ____ ____ $d before it stopped.',
        options: ['had been ${v.ing}', 'have been ${v.ing}', 'had ${v.v3}', 'were ${v.ing}'],
        correctIndex: 0,
        explanation: 'Past perfect continuous: had been + V-ing (duration before a past point).',
      ));
    }
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generateFutureSimple({required int count}) {
  final verbs = _verbs;
  final timeFuture = ['tomorrow', 'next week', 'soon', 'in two days'];
  final subjects = ['I', 'You', 'He', 'She', 'We', 'They'];
  final out = <PracticeQuestion>[];
  for (final s in subjects) {
    for (final v in verbs) {
      for (final t in timeFuture) {
        out.add(PracticeQuestion(
          question: '$s ____ ____ $t.',
          options: ['will ${v.base}', 'will ${v.s3}', 'would ${v.base}', 'will ${v.ing}'],
          correctIndex: 0,
          explanation: 'Future simple: will + base verb.',
        ));
      }
    }
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generateFutureContinuous({required int count}) {
  final verbs = _verbs;
  final out = <PracticeQuestion>[];
  for (final v in verbs) {
    out.add(PracticeQuestion(
      question: 'At 8 PM, I ____ ____ ____.',
      options: ['will be ${v.ing}', 'will ${v.base}', 'am ${v.ing}', 'will have ${v.v3}'],
      correctIndex: 0,
      explanation: 'Future continuous: will be + V-ing.',
    ));
    out.add(PracticeQuestion(
      question: 'This time tomorrow, she ____ ____ ____.',
      options: ['will be ${v.ing}', 'is ${v.ing}', 'will ${v.base}', 'would be ${v.ing}'],
      correctIndex: 0,
      explanation: 'Future continuous: will be + V-ing.',
    ));
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generateFuturePerfectSimple({required int count}) {
  final verbs = _verbs;
  final out = <PracticeQuestion>[];
  for (final v in verbs) {
    out.add(PracticeQuestion(
      question: 'By 8 PM, I ____ ____ ____.',
      options: ['will have ${v.v3}', 'will has ${v.v3}', 'have ${v.v3}', 'will be ${v.ing}'],
      correctIndex: 0,
      explanation: 'Future perfect: will have + V3.',
    ));
    out.add(PracticeQuestion(
      question: 'By next week, they ____ ____ ____.',
      options: ['will have ${v.v3}', 'will have ${v.past}', 'have ${v.v3}', 'had ${v.v3}'],
      correctIndex: 0,
      explanation: 'Future perfect: will have + V3.',
    ));
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generateFuturePerfectContinuous({required int count}) {
  final verbs = _verbs.where((v) => v.base != 'go').toList();
  final out = <PracticeQuestion>[];
  final durations = ['for 2 hours', 'for a long time', 'since 2020', 'for 5 years'];
  for (final v in verbs) {
    for (final d in durations) {
      out.add(PracticeQuestion(
        question: 'By 8 PM, I ____ ____ ____ ____ $d.',
        options: [
          'will have been ${v.ing}',
          'will have ${v.v3}',
          'will be ${v.ing}',
          'have been ${v.ing}',
        ],
        correctIndex: 0,
        explanation: 'Future perfect continuous: will have been + V-ing.',
      ));
    }
  }
  out.shuffle();
  return out.take(count).toList();
}

List<PracticeQuestion> _generateA1A2Basic({required int count}) {
  final templates = <PracticeQuestion>[
    const PracticeQuestion(
      question: 'I saw ____ elephant in the zoo.',
      options: ['a', 'an', 'the', '—'],
      correctIndex: 1,
      explanation: 'Use “an” before vowel sounds: an elephant.',
    ),
    const PracticeQuestion(
      question: 'She is ____ university student.',
      options: ['a', 'an', 'the', '—'],
      correctIndex: 0,
      explanation: '“University” starts with /juː/ → a university.',
    ),
    const PracticeQuestion(
      question: 'There ____ a book on the table.',
      options: ['is', 'are', 'am', 'be'],
      correctIndex: 0,
      explanation: 'There is + singular noun.',
    ),
    const PracticeQuestion(
      question: 'There ____ two chairs in the room.',
      options: ['is', 'are', 'was', 'be'],
      correctIndex: 1,
      explanation: 'There are + plural noun.',
    ),
    const PracticeQuestion(
      question: 'We meet ____ Monday.',
      options: ['on', 'in', 'at', 'to'],
      correctIndex: 0,
      explanation: 'On + days of the week.',
    ),
    const PracticeQuestion(
      question: 'She gets up ____ 6 o’clock.',
      options: ['at', 'in', 'on', 'to'],
      correctIndex: 0,
      explanation: 'At + clock times.',
    ),
    const PracticeQuestion(
      question: 'I have ____ apples.',
      options: ['some', 'any', 'much', 'little'],
      correctIndex: 0,
      explanation: 'Some is common in affirmative sentences.',
    ),
    const PracticeQuestion(
      question: 'Do you have ____ questions?',
      options: ['some', 'any', 'many', 'few'],
      correctIndex: 1,
      explanation: 'Any is common in questions/negatives.',
    ),
    const PracticeQuestion(
      question: 'How ____ water do you drink?',
      options: ['many', 'much', 'few', 'fewer'],
      correctIndex: 1,
      explanation: 'Much for uncountable nouns (water).',
    ),
    const PracticeQuestion(
      question: 'How ____ books are there?',
      options: ['many', 'much', 'little', 'less'],
      correctIndex: 0,
      explanation: 'Many for countable nouns (books).',
    ),
  ];

  final out = <PracticeQuestion>[];
  while (out.length < count) {
    out.add(templates[out.length % templates.length]);
  }
  return out;
}

List<PracticeQuestion> _generateB1({required int count}) {
  final templates = <PracticeQuestion>[
    const PracticeQuestion(
      question: 'I enjoy ____ (read) books.',
      options: ['read', 'to read', 'reading', 'reads'],
      correctIndex: 2,
      explanation: 'Enjoy + V-ing → enjoy reading.',
    ),
    const PracticeQuestion(
      question: 'I decided ____ (go) home early.',
      options: ['go', 'to go', 'going', 'goes'],
      correctIndex: 1,
      explanation: 'Decide + to V → decided to go.',
    ),
    const PracticeQuestion(
      question: 'This is the man ____ helped me.',
      options: ['who', 'which', 'where', 'when'],
      correctIndex: 0,
      explanation: 'Relative clause for people: who.',
    ),
    const PracticeQuestion(
      question: 'I have lived here ____ 2018.',
      options: ['for', 'since', 'ago', 'during'],
      correctIndex: 1,
      explanation: 'Since + point in time (2018).',
    ),
    const PracticeQuestion(
      question: 'I have lived here ____ five years.',
      options: ['for', 'since', 'ago', 'during'],
      correctIndex: 0,
      explanation: 'For + duration (five years).',
    ),
    const PracticeQuestion(
      question: 'If I have time, I ____ you.',
      options: ['will help', 'would help', 'helped', 'am helping'],
      correctIndex: 0,
      explanation: 'First conditional: If + present, will + V.',
    ),
  ];

  final out = <PracticeQuestion>[];
  while (out.length < count) {
    out.add(templates[out.length % templates.length]);
  }
  return out;
}

List<PracticeQuestion> _generateB2({required int count}) {
  final templates = <PracticeQuestion>[
    const PracticeQuestion(
      question: 'The report ____ yesterday. (finish)',
      options: ['was finished', 'is finished', 'finished', 'has finish'],
      correctIndex: 0,
      explanation: 'Past passive: was/were + V3 → was finished.',
    ),
    const PracticeQuestion(
      question: 'He said that he ____ busy. (be)',
      options: ['is', 'was', 'were', 'has been'],
      correctIndex: 1,
      explanation: 'Reported speech backshift: is → was.',
    ),
    const PracticeQuestion(
      question: 'You ____ have told me! (criticism)',
      options: ['must', 'should', 'might', 'can'],
      correctIndex: 1,
      explanation: 'Should have + V3 = criticism/regret.',
    ),
    const PracticeQuestion(
      question: 'I wish I ____ more time. (have)',
      options: ['have', 'had', 'will have', 'has'],
      correctIndex: 1,
      explanation: 'Wish (present) → past form: had.',
    ),
    const PracticeQuestion(
      question: 'If I ____ you, I would apologize. (be)',
      options: ['am', 'was', 'were', 'will be'],
      correctIndex: 2,
      explanation: 'Second conditional: If + past, would + V. Use “were”.',
    ),
  ];

  final out = <PracticeQuestion>[];
  while (out.length < count) {
    out.add(templates[out.length % templates.length]);
  }
  return out;
}

List<PracticeQuestion> _generateC1C2({required int count}) {
  final templates = <PracticeQuestion>[
    const PracticeQuestion(
      question: 'Hardly ____ I arrived when it started to rain.',
      options: ['had', 'have', 'did', 'was'],
      correctIndex: 0,
      explanation: 'Inversion: Hardly + had + subject + V3...',
    ),
    const PracticeQuestion(
      question: 'Not only ____ he apologize, but he also fixed the problem.',
      options: ['did', 'does', 'has', 'was'],
      correctIndex: 0,
      explanation: 'Inversion: Not only + did + subject + base verb...',
    ),
    const PracticeQuestion(
      question: 'It was John ____ broke the window. (cleft)',
      options: ['who', 'which', 'where', 'when'],
      correctIndex: 0,
      explanation: 'Cleft sentence: It was + person + who...',
    ),
    const PracticeQuestion(
      question: 'I would rather you ____ here. (not/be)',
      options: ['aren’t', 'weren’t', 'not be', 'don’t be'],
      correctIndex: 1,
      explanation: 'Would rather + past form: weren’t.',
    ),
    const PracticeQuestion(
      question: 'If I ____ known, I would have helped. (know)',
      options: ['have', 'had', 'would', 'was'],
      correctIndex: 1,
      explanation: 'Third conditional: If + had V3, would have + V3.',
    ),
  ];

  final out = <PracticeQuestion>[];
  while (out.length < count) {
    out.add(templates[out.length % templates.length]);
  }
  return out;
}

List<PracticeQuestion> _generateConditionals({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'If you heat ice, it ____.',
      options: ['melts', 'melt', 'will melt', 'would melt'],
      correctIndex: 0,
      explanation: 'Zero conditional: present simple in both clauses.',
    ),
    PracticeQuestion(
      question: 'If it rains, we ____ at home.',
      options: ['stay', 'stayed', 'will stay', 'would stay'],
      correctIndex: 2,
      explanation: 'First conditional: If + present, will + V.',
    ),
    PracticeQuestion(
      question: 'If I ____ rich, I would travel the world.',
      options: ['am', 'was', 'were', 'will be'],
      correctIndex: 2,
      explanation: 'Second conditional: If + past, would + V. Use “were”.',
    ),
    PracticeQuestion(
      question: 'If she had studied, she ____ the exam.',
      options: ['passes', 'passed', 'would pass', 'would have passed'],
      correctIndex: 3,
      explanation: 'Third conditional: If + had V3, would have + V3.',
    ),
    PracticeQuestion(
      question: 'If I had listened, I ____ in trouble now.',
      options: ['am not', 'wouldn’t be', 'won’t be', 'wasn’t'],
      correctIndex: 1,
      explanation: 'Mixed conditional: past condition → present result.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generatePassive({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'Houses ____ built every year. (build)',
      options: ['are', 'is', 'was', 'were'],
      correctIndex: 0,
      explanation: 'Present passive plural: are + V3.',
    ),
    PracticeQuestion(
      question: 'A letter ____ written yesterday. (write)',
      options: ['was', 'is', 'were', 'has'],
      correctIndex: 0,
      explanation: 'Past passive singular: was + V3.',
    ),
    PracticeQuestion(
      question: 'The work ____ finished tomorrow. (finish)',
      options: ['will be', 'is', 'was', 'has been'],
      correctIndex: 0,
      explanation: 'Future passive: will be + V3.',
    ),
    PracticeQuestion(
      question: 'English ____ worldwide. (speak)',
      options: ['is spoken', 'speaks', 'spoken', 'is speaking'],
      correctIndex: 0,
      explanation: 'Present passive: is/are + V3.',
    ),
    PracticeQuestion(
      question: 'The cake ____ by Tom. (make)',
      options: ['was made', 'made', 'is making', 'has make'],
      correctIndex: 0,
      explanation: 'Past passive: was/were + V3.',
    ),
    PracticeQuestion(
      question: 'My phone ____ right now. (repair)',
      options: ['is being repaired', 'is repaired', 'was repaired', 'repairs'],
      correctIndex: 0,
      explanation: 'Present continuous passive: am/is/are being + V3.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generateClauses({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'This is the book ____ I told you about.',
      options: ['that', 'who', 'where', 'when'],
      correctIndex: 0,
      explanation: 'Relative clause for things: that/which.',
    ),
    PracticeQuestion(
      question: 'The man ____ lives next door is a doctor.',
      options: ['who', 'which', 'what', 'whose'],
      correctIndex: 0,
      explanation: 'Relative clause for people: who.',
    ),
    PracticeQuestion(
      question: 'I don’t know ____ he is coming.',
      options: ['if', 'what', 'where', 'which'],
      correctIndex: 0,
      explanation: 'Noun clause: I don’t know if/whether...',
    ),
    PracticeQuestion(
      question: 'Call me ____ you arrive.',
      options: ['when', 'which', 'what', 'who'],
      correctIndex: 0,
      explanation: 'Adverb clause of time: when.',
    ),
    PracticeQuestion(
      question: 'She stayed home ____ she was sick.',
      options: ['because', 'so', 'although', 'unless'],
      correctIndex: 0,
      explanation: 'Adverb clause of reason: because.',
    ),
    PracticeQuestion(
      question: '____ I was tired, I kept working.',
      options: ['Although', 'Because', 'So', 'Unless'],
      correctIndex: 0,
      explanation: 'Although = contrast.',
    ),
    PracticeQuestion(
      question: 'That’s the place ____ we met.',
      options: ['where', 'who', 'which', 'when'],
      correctIndex: 0,
      explanation: 'Relative clause for place: where.',
    ),
    PracticeQuestion(
      question: 'Do you remember the day ____ we first met?',
      options: ['when', 'where', 'who', 'which'],
      correctIndex: 0,
      explanation: 'Relative clause for time: when.',
    ),
    PracticeQuestion(
      question: 'The woman ____ car was stolen called the police.',
      options: ['whose', 'who', 'that', 'where'],
      correctIndex: 0,
      explanation: 'Whose shows possession.',
    ),
    PracticeQuestion(
      question: 'I will go ____ you go.',
      options: ['wherever', 'whenever', 'whoever', 'whatever'],
      correctIndex: 0,
      explanation: 'Wherever = any place.',
    ),
    PracticeQuestion(
      question: 'He spoke quietly ____ nobody heard him.',
      options: ['so that', 'because', 'although', 'unless'],
      correctIndex: 0,
      explanation: 'So that = purpose.',
    ),
    PracticeQuestion(
      question: 'I don’t know ____ to do.',
      options: ['what', 'who', 'where', 'when'],
      correctIndex: 0,
      explanation: 'Noun clause with question word: what to do.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generateModalVerbs({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'You ____ wear a seatbelt. It’s the law.',
      options: ['can', 'must', 'might', 'could'],
      correctIndex: 1,
      explanation: 'Must = obligation.',
    ),
    PracticeQuestion(
      question: 'It ____ rain later, so take an umbrella.',
      options: ['must', 'might', 'should', 'can’t'],
      correctIndex: 1,
      explanation: 'Might = possibility.',
    ),
    PracticeQuestion(
      question: 'You ____ smoke here. It’s forbidden.',
      options: ['must', 'mustn’t', 'could', 'may'],
      correctIndex: 1,
      explanation: 'Mustn’t = prohibition.',
    ),
    PracticeQuestion(
      question: 'You ____ see a doctor if you feel worse.',
      options: ['should', 'can', 'may', 'mustn’t'],
      correctIndex: 0,
      explanation: 'Should = advice.',
    ),
    PracticeQuestion(
      question: '____ you help me, please?',
      options: ['Must', 'Could', 'Should', 'Would'],
      correctIndex: 1,
      explanation: 'Could = polite request.',
    ),
    PracticeQuestion(
      question: 'He ____ be at home. The lights are on.',
      options: ['must', 'might', 'could', 'can’t'],
      correctIndex: 0,
      explanation: 'Must = logical deduction.',
    ),
    PracticeQuestion(
      question: 'He ____ be at home. I saw him outside.',
      options: ['must', 'might', 'can’t', 'could'],
      correctIndex: 2,
      explanation: 'Can’t = strong impossibility.',
    ),
    PracticeQuestion(
      question: 'You ____ have called me. (past advice)',
      options: ['should', 'should have', 'must', 'can'],
      correctIndex: 1,
      explanation: 'Should have + V3 = past advice/criticism.',
    ),
    PracticeQuestion(
      question: 'I ____ swim when I was five. (ability)',
      options: ['can', 'could', 'must', 'may'],
      correctIndex: 1,
      explanation: 'Could = past ability.',
    ),
    PracticeQuestion(
      question: 'May I ____ the window? (permission)',
      options: ['open', 'opens', 'opening', 'opened'],
      correctIndex: 0,
      explanation: 'May + base verb.',
    ),
    PracticeQuestion(
      question: 'You ____ to be careful. (weak advice)',
      options: ['ought', 'ought to', 'might', 'could'],
      correctIndex: 1,
      explanation: 'Ought to + base verb.',
    ),
    PracticeQuestion(
      question: 'We ____ leave now or we’ll be late.',
      options: ['must', 'may', 'could', 'might'],
      correctIndex: 0,
      explanation: 'Must = necessity.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generateGerundInfinitive({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'I enjoy ____ (read) books.',
      options: ['read', 'to read', 'reading', 'reads'],
      correctIndex: 2,
      explanation: 'Enjoy + V-ing.',
    ),
    PracticeQuestion(
      question: 'I decided ____ (go) home early.',
      options: ['go', 'to go', 'going', 'goes'],
      correctIndex: 1,
      explanation: 'Decide + to V.',
    ),
    PracticeQuestion(
      question: 'She stopped ____ (smoke).',
      options: ['smoke', 'to smoke', 'smoking', 'smoked'],
      correctIndex: 2,
      explanation: 'Stop + V-ing = quit an activity.',
    ),
    PracticeQuestion(
      question: 'She stopped ____ (talk) to him. (purpose)',
      options: ['talk', 'to talk', 'talking', 'talked'],
      correctIndex: 1,
      explanation: 'Stop + to V = stop in order to do something.',
    ),
    PracticeQuestion(
      question: 'I want ____ (learn) English.',
      options: ['learn', 'to learn', 'learning', 'learned'],
      correctIndex: 1,
      explanation: 'Want + to V.',
    ),
    PracticeQuestion(
      question: 'He suggested ____ (go) out.',
      options: ['go', 'to go', 'going', 'goes'],
      correctIndex: 2,
      explanation: 'Suggest + V-ing.',
    ),
    PracticeQuestion(
      question: 'I can’t stand ____ (wait).',
      options: ['wait', 'to wait', 'waiting', 'waited'],
      correctIndex: 2,
      explanation: 'Can’t stand + V-ing.',
    ),
    PracticeQuestion(
      question: 'It is important ____ (be) on time.',
      options: ['be', 'to be', 'being', 'been'],
      correctIndex: 1,
      explanation: 'It is + adjective + to V.',
    ),
    PracticeQuestion(
      question: 'He avoided ____ (answer) the question.',
      options: ['answer', 'to answer', 'answering', 'answered'],
      correctIndex: 2,
      explanation: 'Avoid + V-ing.',
    ),
    PracticeQuestion(
      question: 'She promised ____ (help) me.',
      options: ['help', 'to help', 'helping', 'helped'],
      correctIndex: 1,
      explanation: 'Promise + to V.',
    ),
    PracticeQuestion(
      question: 'I look forward to ____ (see) you.',
      options: ['see', 'to see', 'seeing', 'seen'],
      correctIndex: 2,
      explanation: 'Look forward to + V-ing.',
    ),
    PracticeQuestion(
      question: 'He admitted ____ (break) the vase.',
      options: ['break', 'to break', 'breaking', 'broke'],
      correctIndex: 2,
      explanation: 'Admit + V-ing.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generateComparisons({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'This book is ____ than that one.',
      options: ['more interesting', 'interestinger', 'most interesting', 'the more interesting'],
      correctIndex: 0,
      explanation: 'Comparative with long adjectives: more + adj.',
    ),
    PracticeQuestion(
      question: 'She is the ____ student in the class.',
      options: ['better', 'best', 'more good', 'most better'],
      correctIndex: 1,
      explanation: 'Superlative: the best.',
    ),
    PracticeQuestion(
      question: 'My car is ____ as yours.',
      options: ['as fast', 'so fast', 'more fast', 'fastest'],
      correctIndex: 0,
      explanation: 'Equality: as + adj + as.',
    ),
    PracticeQuestion(
      question: 'This is ____ expensive than I expected.',
      options: ['more', 'most', 'much', 'many'],
      correctIndex: 0,
      explanation: 'Comparative: more expensive.',
    ),
    PracticeQuestion(
      question: 'He is ____ than his brother.',
      options: ['taller', 'more tall', 'tallest', 'most tall'],
      correctIndex: 0,
      explanation: 'Short adjective comparative: adj + -er.',
    ),
    PracticeQuestion(
      question: 'This test is the ____ of all.',
      options: ['harder', 'hardest', 'more hard', 'most hard'],
      correctIndex: 1,
      explanation: 'Superlative short adj: the + adj-est.',
    ),
    PracticeQuestion(
      question: 'The sooner, the ____.',
      options: ['better', 'best', 'good', 'more good'],
      correctIndex: 0,
      explanation: 'The + comparative, the + comparative: the better.',
    ),
    PracticeQuestion(
      question: 'He has ____ friends than before.',
      options: ['fewer', 'less', 'little', 'few'],
      correctIndex: 0,
      explanation: 'Fewer for countable nouns (friends).',
    ),
    PracticeQuestion(
      question: 'We have ____ time today.',
      options: ['less', 'fewer', 'few', 'many'],
      correctIndex: 0,
      explanation: 'Less for uncountable nouns (time).',
    ),
    PracticeQuestion(
      question: 'This route is ____ (short) than the other.',
      options: ['shorter', 'more short', 'shortest', 'most short'],
      correctIndex: 0,
      explanation: 'Short adjective: shorter.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generateReportedSpeech({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'Direct: “I am tired.” → He said he ____ tired.',
      options: ['was', 'is', 'were', 'has been'],
      correctIndex: 0,
      explanation: 'Backshift: am/is → was.',
    ),
    PracticeQuestion(
      question: 'Direct: “I will call you.” → She said she ____ call me.',
      options: ['would', 'will', 'was', 'had'],
      correctIndex: 0,
      explanation: 'Backshift: will → would.',
    ),
    PracticeQuestion(
      question: 'Direct: “I can swim.” → He said he ____ swim.',
      options: ['could', 'can', 'will', 'may'],
      correctIndex: 0,
      explanation: 'Backshift: can → could.',
    ),
    PracticeQuestion(
      question: 'Direct: “I went home.” → She said she ____ home.',
      options: ['had gone', 'went', 'has gone', 'goes'],
      correctIndex: 0,
      explanation: 'Backshift: past simple → past perfect.',
    ),
    PracticeQuestion(
      question: 'He asked me, “Where do you live?” → He asked me where I ____.',
      options: ['lived', 'live', 'am living', 'have lived'],
      correctIndex: 0,
      explanation: 'Backshift in questions: do/does → past form.',
    ),
    PracticeQuestion(
      question: 'She said, “Don’t be late.” → She told me ____ be late.',
      options: ['not to', 'to not', 'don’t', 'not'],
      correctIndex: 0,
      explanation: 'Reported commands: tell + object + (not) to V.',
    ),
    PracticeQuestion(
      question: 'He said, “I have finished.” → He said he ____ finished.',
      options: ['had', 'has', 'have', 'was'],
      correctIndex: 0,
      explanation: 'Backshift: have/has → had.',
    ),
    PracticeQuestion(
      question: 'She said, “I am going now.” → She said she ____ going then.',
      options: ['was', 'is', 'were', 'has been'],
      correctIndex: 0,
      explanation: 'Backshift: am/is → was.',
    ),
    PracticeQuestion(
      question: 'He said, “I must leave.” → He said he ____ leave.',
      options: ['had to', 'must', 'has to', 'would'],
      correctIndex: 0,
      explanation: 'Often: must → had to.',
    ),
    PracticeQuestion(
      question: 'They said, “We are happy.” → They said they ____ happy.',
      options: ['were', 'are', 'was', 'have been'],
      correctIndex: 0,
      explanation: 'Backshift: are → were.',
    ),
  ];
  return templates.take(count).toList();
}

List<PracticeQuestion> _generateInversionEmphasis({required int count}) {
  const templates = [
    PracticeQuestion(
      question: 'Never ____ I seen such a beautiful view.',
      options: ['have', 'has', 'did', 'was'],
      correctIndex: 0,
      explanation: 'Inversion: Never + have + subject + V3.',
    ),
    PracticeQuestion(
      question: 'Rarely ____ she complain about anything.',
      options: ['does', 'do', 'did', 'has'],
      correctIndex: 0,
      explanation: 'Inversion with present simple: Rarely + does + subject + base verb.',
    ),
    PracticeQuestion(
      question: 'Not until I arrived ____ I realize the truth.',
      options: ['did', 'do', 'have', 'was'],
      correctIndex: 0,
      explanation: 'Not until + did + subject + base verb.',
    ),
    PracticeQuestion(
      question: 'Only after the meeting ____ he understand.',
      options: ['did', 'does', 'has', 'was'],
      correctIndex: 0,
      explanation: 'Only after + did + subject + base verb.',
    ),
    PracticeQuestion(
      question: 'It was Tom ____ called me.',
      options: ['who', 'which', 'where', 'when'],
      correctIndex: 0,
      explanation: 'Cleft sentence: It was + person + who...',
    ),
    PracticeQuestion(
      question: 'What I need is ____.',
      options: ['a break', 'break', 'to breaking', 'broke'],
      correctIndex: 0,
      explanation: 'Emphasis: What-clause + be + focused information.',
    ),
    PracticeQuestion(
      question: 'So tired ____ I that I fell asleep.',
      options: ['was', 'were', 'am', 'is'],
      correctIndex: 0,
      explanation: 'So + adj + be + subject...',
    ),
    PracticeQuestion(
      question: 'Hardly ____ I arrived when it started to rain.',
      options: ['had', 'have', 'did', 'was'],
      correctIndex: 0,
      explanation: 'Hardly + had + subject + V3...',
    ),
    PracticeQuestion(
      question: 'Not only ____ he apologize, but he also fixed the problem.',
      options: ['did', 'does', 'has', 'was'],
      correctIndex: 0,
      explanation: 'Not only + did + subject + base verb...',
    ),
    PracticeQuestion(
      question: 'Were I you, I ____ apologize.',
      options: ['would', 'will', 'am', 'had'],
      correctIndex: 0,
      explanation: 'Inversion conditional: Were I you = If I were you.',
    ),
  ];
  return templates.take(count).toList();
}

class _VerbForms {
  final String base;
  final String past;
  final String v3;
  final String ing;
  final String s3;

  const _VerbForms({
    required this.base,
    required this.past,
    required this.v3,
    required this.ing,
    required this.s3,
  });
}

final List<_VerbForms> _verbs = [
  _v('play', past: 'played', v3: 'played', ing: 'playing', s3: 'plays'),
  _v('work', past: 'worked', v3: 'worked', ing: 'working', s3: 'works'),
  _v('study', past: 'studied', v3: 'studied', ing: 'studying', s3: 'studies'),
  _v('watch', past: 'watched', v3: 'watched', ing: 'watching', s3: 'watches'),
  _v('go', past: 'went', v3: 'gone', ing: 'going', s3: 'goes'),
  _v('do', past: 'did', v3: 'done', ing: 'doing', s3: 'does'),
  _v('have', past: 'had', v3: 'had', ing: 'having', s3: 'has'),
  _v('make', past: 'made', v3: 'made', ing: 'making', s3: 'makes'),
  _v('take', past: 'took', v3: 'taken', ing: 'taking', s3: 'takes'),
  _v('get', past: 'got', v3: 'gotten', ing: 'getting', s3: 'gets'),
  _v('see', past: 'saw', v3: 'seen', ing: 'seeing', s3: 'sees'),
  _v('eat', past: 'ate', v3: 'eaten', ing: 'eating', s3: 'eats'),
  _v('read', past: 'read', v3: 'read', ing: 'reading', s3: 'reads'),
  _v('write', past: 'wrote', v3: 'written', ing: 'writing', s3: 'writes'),
  _v('buy', past: 'bought', v3: 'bought', ing: 'buying', s3: 'buys'),
  _v('bring', past: 'brought', v3: 'brought', ing: 'bringing', s3: 'brings'),
  _v('learn', past: 'learned', v3: 'learned', ing: 'learning', s3: 'learns'),
  _v('teach', past: 'taught', v3: 'taught', ing: 'teaching', s3: 'teaches'),
  _v('run', past: 'ran', v3: 'run', ing: 'running', s3: 'runs'),
  _v('sleep', past: 'slept', v3: 'slept', ing: 'sleeping', s3: 'sleeps'),
  _v('open', past: 'opened', v3: 'opened', ing: 'opening', s3: 'opens'),
  _v('close', past: 'closed', v3: 'closed', ing: 'closing', s3: 'closes'),
  _v('start', past: 'started', v3: 'started', ing: 'starting', s3: 'starts'),
  _v('finish', past: 'finished', v3: 'finished', ing: 'finishing', s3: 'finishes'),
];

_VerbForms _v(
  String base, {
  required String past,
  required String v3,
  required String ing,
  required String s3,
}) =>
    _VerbForms(base: base, past: past, v3: v3, ing: ing, s3: s3);


