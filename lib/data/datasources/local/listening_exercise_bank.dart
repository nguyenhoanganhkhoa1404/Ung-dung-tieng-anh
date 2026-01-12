import 'dart:math';

/// Listening question types supported by the practice UI.
enum ListeningQuestionType { multipleChoice, trueFalse, fillBlank, matching }

class ListeningQuestion {
  final ListeningQuestionType type;
  final String prompt;
  final List<String>? options; // for multipleChoice
  final int? correctIndex; // for multipleChoice
  final bool? correctBool; // for trueFalse
  final String? correctText; // for fillBlank (single blank)
  final String? explanation;

  /// Matching: left items and right items (shuffled in UI), with correct pairs by index.
  final List<String>? matchLeft;
  final List<String>? matchRight;
  final Map<int, int>? matchPairs; // leftIndex -> rightIndex

  const ListeningQuestion._({
    required this.type,
    required this.prompt,
    this.options,
    this.correctIndex,
    this.correctBool,
    this.correctText,
    this.explanation,
    this.matchLeft,
    this.matchRight,
    this.matchPairs,
  });

  factory ListeningQuestion.multipleChoice({
    required String prompt,
    required List<String> options,
    required int correctIndex,
    String? explanation,
  }) {
    return ListeningQuestion._(
      type: ListeningQuestionType.multipleChoice,
      prompt: prompt,
      options: options,
      correctIndex: correctIndex,
      explanation: explanation,
    );
  }

  factory ListeningQuestion.trueFalse({
    required String prompt,
    required bool correct,
    String? explanation,
  }) {
    return ListeningQuestion._(
      type: ListeningQuestionType.trueFalse,
      prompt: prompt,
      correctBool: correct,
      explanation: explanation,
    );
  }

  factory ListeningQuestion.fillBlank({
    required String prompt,
    required String correctText,
    String? explanation,
  }) {
    return ListeningQuestion._(
      type: ListeningQuestionType.fillBlank,
      prompt: prompt,
      correctText: correctText,
      explanation: explanation,
    );
  }

  factory ListeningQuestion.matching({
    required String prompt,
    required List<String> left,
    required List<String> right,
    required Map<int, int> pairs,
    String? explanation,
  }) {
    return ListeningQuestion._(
      type: ListeningQuestionType.matching,
      prompt: prompt,
      matchLeft: left,
      matchRight: right,
      matchPairs: pairs,
      explanation: explanation,
    );
  }
}

class ListeningExercise {
  final String id;
  final String type; // e.g. "Short Dialogue"
  final String title;
  final String level; // Basic / Intermediate / Advanced
  final int durationSeconds;
  final String audioUrl; // required by spec (can be replaced by your own assets/urls)
  final String transcript; // fallback for learning/support
  final List<ListeningQuestion> questions; // 5-8 questions

  const ListeningExercise({
    required this.id,
    required this.type,
    required this.title,
    required this.level,
    required this.durationSeconds,
    required this.audioUrl,
    required this.transcript,
    required this.questions,
  });
}

/// Local question bank for Listening.
/// Note: audio is required by your spec. These URLs are placeholders so the UI works.
/// You can replace them with your own uploaded audio (Firebase Storage) or assets.
class ListeningExerciseBank {
  static const _placeholderAudio =
      'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';

  static List<ListeningExercise> byType(String type) {
    switch (type) {
      case 'Hội thoại ngắn':
        return _shortDialogues();
      case 'Hội thoại dài':
        return _longDialogues();
      case 'Bản tin / thông báo':
        return _newsAnnouncements();
      case 'Câu chuyện kể':
        return _storytelling();
      case 'Bài giảng ngắn':
        return _miniLectures();
      case 'Thông báo (sân bay/trường/công ty)':
        return _publicAnnouncements();
      case 'Phỏng vấn':
        return _interviews();
      case 'Podcast ngắn':
        return _podcasts();
      // Level-based exercises
      case 'A1 - Beginner':
        return _levelA1();
      case 'A2 - Elementary':
        return _levelA2();
      case 'B1 - Intermediate':
        return _levelB1();
      case 'B2 - Upper Intermediate':
        return _levelB2();
      case 'C1 - Advanced':
        return _levelC1();
      case 'C2 - Proficiency':
        return _levelC2();
      default:
        return _shortDialogues();
    }
  }

  static List<ListeningExercise> _shortDialogues() {
    return [
      // 1. Ordering at a coffee shop
      ListeningExercise(
        id: 'short_1',
        type: 'Hội thoại ngắn',
        title: 'At the coffee shop',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 60,
        audioUrl: _placeholderAudio,
        transcript: '''
Barista: Good morning! Welcome to Daily Brew. What can I get for you today?
Customer: Hi! Can I have a medium caramel latte, please?
Barista: Of course. Would you like that hot or iced?
Customer: Iced, please. It's so hot outside today.
Barista: I know, right? Would you like any food with that? We have fresh croissants and muffins.
Customer: Hmm, the chocolate muffin looks good. I'll take one of those.
Barista: Great choice! That'll be eight dollars and fifty cents.
Customer: Here you go. Can I pay by card?
Barista: Absolutely. Just tap here. Your order will be ready in about three minutes.
Customer: Perfect, thank you!
Barista: You're welcome. Have a great day!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where does this conversation take place?',
            options: ['At a coffee shop', 'At a bank', 'At a hospital', 'At a bookstore'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What drink does the customer order?',
            options: ['Caramel latte', 'Black coffee', 'Green tea', 'Orange juice'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The customer orders a hot drink.',
            correct: false,
            explanation: 'The customer says "Iced, please."',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What food does the customer buy?',
            options: ['Chocolate muffin', 'Croissant', 'Sandwich', 'Nothing'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The total is eight dollars and ____ cents.',
            correctText: 'fifty',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How does the customer pay?',
            options: ['By card', 'With cash', 'Mobile payment', 'Gift card'],
            correctIndex: 0,
          ),
        ],
      ),

      // 2. Asking for directions
      ListeningExercise(
        id: 'short_2',
        type: 'Hội thoại ngắn',
        title: 'Asking for directions',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 55,
        audioUrl: _placeholderAudio,
        transcript: '''
Tourist: Excuse me, could you help me? I'm looking for the Central Museum.
Local: Sure! It's not far from here. Go straight down this street for about two blocks.
Tourist: Two blocks, okay.
Local: Then turn left at the traffic light. You'll see a big park on your right.
Tourist: Turn left at the traffic light, got it.
Local: The museum is right across from the park. It's a large white building with columns. You can't miss it.
Tourist: How long does it take to walk there?
Local: About ten minutes if you walk at a normal pace.
Tourist: That's great. Thank you so much for your help!
Local: No problem. Enjoy your visit!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the tourist looking for?',
            options: ['The Central Museum', 'A restaurant', 'A hotel', 'The train station'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many blocks should the tourist walk straight?',
            options: ['Two blocks', 'Three blocks', 'One block', 'Five blocks'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Turn left at the traffic ____.',
            correctText: 'light',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The park is on the left side of the street.',
            correct: false,
            explanation: 'The local says the park is on the right.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long does it take to walk there?',
            options: ['About ten minutes', 'About five minutes', 'About thirty minutes', 'One hour'],
            correctIndex: 0,
          ),
        ],
      ),

      // 3. Making a restaurant reservation
      ListeningExercise(
        id: 'short_3',
        type: 'Hội thoại ngắn',
        title: 'Restaurant reservation',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 65,
        audioUrl: _placeholderAudio,
        transcript: '''
Staff: Good evening, Riverside Restaurant. How may I help you?
Caller: Hi, I'd like to make a reservation for this Saturday, please.
Staff: Of course. How many people will be dining?
Caller: There will be four of us.
Staff: And what time would you prefer?
Caller: Around seven thirty, if possible.
Staff: Let me check... Yes, we have a table available at seven thirty. May I have your name?
Caller: It's Johnson. Sarah Johnson.
Staff: Thank you, Ms. Johnson. Would you like a table inside or on the terrace?
Caller: The terrace sounds nice if the weather is good.
Staff: Perfect. I've booked you a terrace table for four at seven thirty this Saturday. Is there anything else?
Caller: No, that's all. Thank you very much.
Staff: You're welcome. We look forward to seeing you!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What day is the reservation for?',
            options: ['Saturday', 'Sunday', 'Friday', 'Monday'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many people will be dining?',
            options: ['Four', 'Two', 'Six', 'Three'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The reservation time is seven ____.',
            correctText: 'thirty',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the caller\'s last name?',
            options: ['Johnson', 'Jackson', 'Thompson', 'Wilson'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The caller prefers a table inside the restaurant.',
            correct: false,
            explanation: 'The caller chooses the terrace.',
          ),
        ],
      ),

      // 4. Shopping for clothes
      ListeningExercise(
        id: 'short_4',
        type: 'Hội thoại ngắn',
        title: 'Shopping for clothes',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Sales: Hello! Can I help you find anything today?
Customer: Yes, I'm looking for a dress shirt for a job interview.
Sales: Great! What size do you usually wear?
Customer: I'm a medium, I think.
Sales: We have some nice options over here. Do you prefer a particular color?
Customer: I was thinking light blue or white. Something professional.
Sales: These two are very popular for interviews. The white one is thirty-five dollars, and the blue is forty.
Customer: Can I try the blue one?
Sales: Of course! The fitting rooms are in the back on your left.
Customer: Thank you. Oh, and do you have matching ties?
Sales: Yes, we have a selection right next to the shirts. I can help you choose one after you try the shirt.
Customer: Perfect, thanks!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Why does the customer need a shirt?',
            options: ['For a job interview', 'For a wedding', 'For a party', 'For casual wear'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What size does the customer wear?',
            options: ['Medium', 'Small', 'Large', 'Extra large'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The blue shirt costs ____ dollars.',
            correctText: 'forty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The customer decides to try the white shirt.',
            correct: false,
            explanation: 'The customer asks to try the blue one.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where are the fitting rooms?',
            options: ['In the back on the left', 'Near the entrance', 'Upstairs', 'On the right'],
            correctIndex: 0,
          ),
        ],
      ),

      // 5. At the doctor's office
      ListeningExercise(
        id: 'short_5',
        type: 'Hội thoại ngắn',
        title: 'At the doctor\'s office',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 65,
        audioUrl: _placeholderAudio,
        transcript: '''
Doctor: Good morning. What brings you in today?
Patient: I've had a terrible headache for the past three days, and it's not going away.
Doctor: I see. Are you experiencing any other symptoms? Fever, nausea, or dizziness?
Patient: A little dizziness, but no fever.
Doctor: Have you been sleeping well lately?
Patient: Not really. I've been working late and staring at my computer a lot.
Doctor: That could be contributing to your headaches. You might have tension headaches from eye strain and stress.
Patient: What should I do?
Doctor: I recommend taking breaks from the screen every hour, getting more sleep, and drinking plenty of water. I'll also prescribe some pain relievers. If it doesn't improve in a week, come back.
Patient: Okay, thank you, Doctor.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the patient\'s main complaint?',
            options: ['Headache', 'Stomach pain', 'Back pain', 'Sore throat'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long has the patient had this problem?',
            options: ['Three days', 'One week', 'Two weeks', 'One month'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The patient has a fever.',
            correct: false,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The patient has been staring at the ____ a lot.',
            correctText: 'computer',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the doctor recommend?',
            options: ['Taking breaks and getting more sleep', 'Surgery', 'Going to hospital immediately', 'Quitting the job'],
            correctIndex: 0,
          ),
        ],
      ),

      // 6. Checking into a hotel
      ListeningExercise(
        id: 'short_6',
        type: 'Hội thoại ngắn',
        title: 'Hotel check-in',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Receptionist: Welcome to Grand Hotel. How can I help you?
Guest: Hi, I have a reservation under the name Michael Brown.
Receptionist: Let me check... Yes, Mr. Brown. You've booked a double room for three nights, correct?
Guest: That's right.
Receptionist: May I see your ID or passport, please?
Guest: Sure, here you go.
Receptionist: Thank you. Your room is on the fifth floor, room five-oh-eight. Here's your key card.
Guest: Great. What time is breakfast?
Receptionist: Breakfast is served from seven to ten in the restaurant on the first floor.
Guest: And is there WiFi in the room?
Receptionist: Yes, it's free. The password is on the card in your room. The elevators are just around the corner. Enjoy your stay!
Guest: Thank you very much!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the guest\'s name?',
            options: ['Michael Brown', 'John Smith', 'David Wilson', 'Peter Johnson'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many nights will the guest stay?',
            options: ['Three nights', 'Two nights', 'One night', 'Five nights'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The room number is ____.',
            correctText: '508',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What time does breakfast end?',
            options: ['Ten o\'clock', 'Nine o\'clock', 'Eleven o\'clock', 'Eight o\'clock'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The guest needs to pay extra for WiFi.',
            correct: false,
            explanation: 'WiFi is free.',
          ),
        ],
      ),

      // 7. At the bank
      ListeningExercise(
        id: 'short_7',
        type: 'Hội thoại ngắn',
        title: 'Opening a bank account',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 75,
        audioUrl: _placeholderAudio,
        transcript: '''
Teller: Good morning! How can I help you today?
Customer: Hi, I'd like to open a new savings account.
Teller: Of course. Have you ever had an account with us before?
Customer: No, this is my first time.
Teller: Alright. I'll need to see two forms of ID. Do you have your passport and driver's license?
Customer: Yes, here they are.
Teller: Perfect. And what's your current address?
Customer: It's 456 Oak Street, Apartment 3B.
Teller: Great. Now, for a savings account, the minimum initial deposit is fifty dollars. How much would you like to deposit today?
Customer: I'll start with two hundred dollars.
Teller: Excellent. The interest rate for our basic savings account is one point five percent annually. Would you like a debit card with this account?
Customer: Yes, please.
Teller: It will take about five business days to arrive in the mail. In the meantime, here's your temporary account number. Would you like to set up online banking?
Customer: Yes, that would be convenient.
Teller: Perfect. I'll give you instructions to set that up at home. Is there anything else I can help you with?
Customer: No, that's everything. Thank you!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does the customer want to do?',
            options: ['Open a savings account', 'Close an account', 'Apply for a loan', 'Exchange currency'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the minimum initial deposit?',
            options: ['50 dollars', '100 dollars', '200 dollars', '500 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The interest rate is one point ____ percent annually.',
            correctText: 'five',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The debit card will arrive the same day.',
            correct: false,
            explanation: 'It takes about 5 business days.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much does the customer deposit?',
            options: ['200 dollars', '50 dollars', '500 dollars', '100 dollars'],
            correctIndex: 0,
          ),
        ],
      ),

      // 8. At the gym
      ListeningExercise(
        id: 'short_8',
        type: 'Hội thoại ngắn',
        title: 'Gym membership inquiry',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 65,
        audioUrl: _placeholderAudio,
        transcript: '''
Staff: Hi there! Welcome to FitLife Gym. Are you interested in becoming a member?
Customer: Yes, I am. Can you tell me about your membership options?
Staff: Sure! We have three plans. The basic plan is thirty dollars a month and includes access to all gym equipment.
Customer: What about group classes?
Staff: Group classes are included in our premium plan, which is fifty dollars a month. That includes yoga, spinning, and all aerobics classes.
Customer: And is there a more comprehensive option?
Staff: Yes, our ultimate plan is seventy dollars a month. It includes everything plus personal training sessions twice a month and access to the swimming pool and sauna.
Customer: That sounds good. Is there a contract?
Staff: For monthly plans, there's no contract. You can cancel anytime with thirty days' notice. However, if you sign up for a year, you get two months free.
Customer: Interesting. Can I try the gym first before deciding?
Staff: Absolutely! We offer a free one-day trial. Would you like to schedule that?
Customer: Yes, please. How about this Saturday?
Staff: Saturday works. I'll put you down for ten am. Just bring your ID.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How much is the basic plan?',
            options: ['30 dollars', '50 dollars', '70 dollars', '20 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which plan includes group classes?',
            options: ['Premium plan', 'Basic plan', 'Ultimate plan only', 'None of them'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The ultimate plan costs ____ dollars a month.',
            correctText: 'seventy',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'You must sign a one-year contract.',
            correct: false,
            explanation: 'Monthly plans have no contract.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do you get if you sign up for a year?',
            options: ['Two months free', 'A free t-shirt', 'Personal training', 'Nothing extra'],
            correctIndex: 0,
          ),
        ],
      ),

      // 9. Calling for tech support
      ListeningExercise(
        id: 'short_9',
        type: 'Hội thoại ngắn',
        title: 'Tech support call',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 80,
        audioUrl: _placeholderAudio,
        transcript: '''
Agent: Thank you for calling TechHelp Support. My name is Kevin. How can I help you today?
Customer: Hi Kevin. I'm having trouble with my internet connection. It keeps disconnecting every few minutes.
Agent: I'm sorry to hear that. Let me help you troubleshoot. First, can you tell me what kind of modem or router you're using?
Customer: It's the one your company provided. I think it's the X500 model.
Agent: Okay, great. Have you tried restarting the router?
Customer: Yes, I've done that several times. It works for about ten minutes, then disconnects again.
Agent: I see. Let me check the signal from our end... It looks like there might be an issue with the line to your house. Can you tell me if there's been any construction or digging near your home recently?
Customer: Actually, yes. They've been working on the road outside for the past week.
Agent: That might be the cause. I'll need to send a technician to check the external connection. The earliest available appointment is Thursday between two and four pm. Would that work for you?
Customer: Can you come earlier? I work from home and really need the internet.
Agent: Let me check... I can offer you tomorrow afternoon between three and five. Is that better?
Customer: Yes, that's much better. Thank you!
Agent: Great. I've scheduled that for you. You'll receive a confirmation text shortly. Is there anything else I can help with?
Customer: No, that's all. Thanks for your help, Kevin.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the customer\'s problem?',
            options: ['Internet keeps disconnecting', 'Computer won\'t start', 'Email isn\'t working', 'TV has no signal'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What router model does the customer have?',
            options: ['X500', 'X300', 'X700', 'X200'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The internet works for about ____ minutes before disconnecting.',
            correctText: 'ten',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The technician will visit on Thursday.',
            correct: false,
            explanation: 'The appointment was rescheduled to tomorrow afternoon.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What might be causing the problem?',
            options: ['Construction near the house', 'Old equipment', 'Weather', 'Computer virus'],
            correctIndex: 0,
          ),
        ],
      ),

      // 10. Making a complaint
      ListeningExercise(
        id: 'short_10',
        type: 'Hội thoại ngắn',
        title: 'Restaurant complaint',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Customer: Excuse me, could I speak to the manager, please?
Waiter: Of course. Is everything okay?
Customer: Not really. I've been waiting for my food for over forty-five minutes now.
Waiter: I'm very sorry about that. Let me get the manager for you right away.
Manager: Hello, I'm the restaurant manager. I understand there's been a problem with your order?
Customer: Yes, I ordered almost an hour ago and still haven't received my food. Other tables that came after me have already been served.
Manager: I sincerely apologize. Let me check on your order immediately. What did you order?
Customer: The grilled salmon with vegetables.
Manager: I'll go to the kitchen now and find out what happened... I'm back. I'm very sorry, but there was a mix-up in the kitchen. Your order was accidentally given to another table. I've asked them to prepare a fresh one right away, and it should be ready in five minutes.
Customer: Okay, thank you.
Manager: As an apology, your meal will be complimentary, and I'd like to offer you a free dessert as well.
Customer: That's very kind. I appreciate you handling this so quickly.
Manager: Again, I'm truly sorry for the inconvenience. We'll make sure this doesn't happen again.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Why is the customer upset?',
            options: ['Waited too long for food', 'Food was cold', 'Bill was wrong', 'Service was rude'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long had the customer been waiting?',
            options: ['About 45 minutes', 'About 15 minutes', 'About 2 hours', 'About 30 minutes'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The customer ordered grilled ____ with vegetables.',
            correctText: 'salmon',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The customer\'s order was forgotten.',
            correct: false,
            explanation: 'The order was given to another table by mistake.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How does the manager compensate the customer?',
            options: ['Free meal and dessert', 'Discount only', '50% off', 'A gift card'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _longDialogues() {
    return [
      // 1. Booking a flight
      ListeningExercise(
        id: 'long_1',
        type: 'Hội thoại dài',
        title: 'Booking a flight',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 120,
        audioUrl: _placeholderAudio,
        transcript: '''
Agent: Good morning, Skyway Airlines. This is Jennifer speaking. How may I assist you today?
Customer: Hi Jennifer, I'd like to book a round-trip flight from New York to Los Angeles.
Agent: Certainly. When would you like to depart?
Customer: I'm thinking about next Friday, December fifteenth.
Agent: Let me check our availability... We have several options. There's an early morning flight at six thirty, one at noon, and an evening flight at seven fifteen.
Customer: The noon flight sounds perfect. What about the return?
Agent: When would you like to come back?
Customer: The following Tuesday, December nineteenth.
Agent: We have flights at nine in the morning and four in the afternoon on that day.
Customer: I'll take the four pm flight. How much will it cost?
Agent: For economy class, the round trip is three hundred and forty-five dollars including taxes. Business class is seven hundred and twenty dollars.
Customer: I'll go with economy. Can I choose my seat?
Agent: Absolutely. Would you prefer a window or aisle seat?
Customer: Window seat, please. Near the front if possible.
Agent: I can get you row twelve, seat A. That's a window seat about halfway up the plane. Is that okay?
Customer: That's fine. What about baggage?
Agent: Economy includes one carry-on bag and one personal item. Checked baggage is thirty-five dollars per bag.
Customer: I'll probably need to check one bag. Can I add that later?
Agent: Yes, you can add it online up to twenty-four hours before departure, or at the airport. May I have your full name and email address for the booking?
Customer: Sure, it's David Mitchell, and my email is david dot mitchell at email dot com.
Agent: Perfect. I'll send the confirmation to your email within the hour. Is there anything else I can help you with?
Customer: No, that's everything. Thank you so much for your help!
Agent: You're welcome, Mr. Mitchell. Have a great trip!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where does the customer want to fly to?',
            options: ['Los Angeles', 'Chicago', 'Miami', 'Boston'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What time is the departure flight the customer chooses?',
            options: ['Noon', 'Six thirty am', 'Seven fifteen pm', 'Nine am'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The return flight is on December ____.',
            correctText: 'nineteenth',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much does the economy round trip cost?',
            options: ['345 dollars', '720 dollars', '300 dollars', '400 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The customer chooses an aisle seat.',
            correct: false,
            explanation: 'The customer asks for a window seat.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much does checked baggage cost?',
            options: ['35 dollars per bag', '25 dollars per bag', '50 dollars per bag', 'Free'],
            correctIndex: 0,
          ),
        ],
      ),

      // 2. Job interview
      ListeningExercise(
        id: 'long_2',
        type: 'Hội thoại dài',
        title: 'Job interview',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 150,
        audioUrl: _placeholderAudio,
        transcript: '''
Interviewer: Good afternoon. Please have a seat, Ms. Chen.
Candidate: Thank you. I'm excited to be here.
Interviewer: So, tell me a little about yourself and why you're interested in this marketing position.
Candidate: Well, I graduated from State University three years ago with a degree in Business Administration. Since then, I've been working at a small advertising agency where I manage social media campaigns and create content for various clients.
Interviewer: That sounds relevant. What attracted you to our company specifically?
Candidate: I've been following your brand for years and I really admire your creative approach to digital marketing. Your recent campaign for the environmental initiative was particularly impressive. I'd love to be part of a team that creates such meaningful work.
Interviewer: Thank you, that campaign was a team effort. Can you tell me about a challenging project you've worked on?
Candidate: Certainly. Last year, we had a client who needed to completely rebrand their image within a very tight deadline of just two weeks. I coordinated with designers, copywriters, and the client to deliver a comprehensive social media strategy. We worked overtime, but the client was thrilled with the results and saw a forty percent increase in engagement.
Interviewer: Impressive. How do you handle working under pressure?
Candidate: I actually thrive under pressure. I make detailed to-do lists, prioritize tasks, and communicate clearly with my team. I find that staying organized helps me stay calm and focused even when deadlines are tight.
Interviewer: That's good to hear. Do you have any questions for me?
Candidate: Yes, I'd like to know more about the team I'd be working with and what a typical day in this role looks like.
Interviewer: Great questions. Let me tell you about our marketing department...
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What position is Ms. Chen interviewing for?',
            options: ['Marketing position', 'Accounting position', 'HR manager', 'Software developer'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long ago did she graduate?',
            options: ['Three years ago', 'Five years ago', 'Last year', 'Two years ago'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The challenging project had a deadline of just two ____.',
            correctText: 'weeks',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What was the result of the rebranding project?',
            options: ['40% increase in engagement', '20% increase in sales', '50% reduction in costs', 'No change'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Ms. Chen says she doesn\'t work well under pressure.',
            correct: false,
            explanation: 'She says she thrives under pressure.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What question does the candidate ask the interviewer?',
            options: ['About the team and typical day', 'About the salary', 'About vacation days', 'About parking'],
            correctIndex: 0,
          ),
        ],
      ),

      // 3. Apartment hunting
      ListeningExercise(
        id: 'long_3',
        type: 'Hội thoại dài',
        title: 'Apartment hunting',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 130,
        audioUrl: _placeholderAudio,
        transcript: '''
Agent: Welcome! So this is the two-bedroom apartment I mentioned. As you can see, it's quite spacious.
Tenant: Wow, it's bigger than I expected. How many square feet is it?
Agent: It's about nine hundred square feet. The living room gets great natural light from these large windows facing south.
Tenant: I can see that. What about the kitchen?
Agent: Right this way. The kitchen was renovated last year. It has new appliances including a dishwasher, and there's plenty of cabinet space.
Tenant: That's nice. Is there laundry in the building?
Agent: Actually, this unit has its own washer and dryer in this closet here. That's pretty rare for this price range.
Tenant: Oh, that's convenient! What floor are we on?
Agent: We're on the third floor, and there's an elevator. Let me show you the bedrooms.
Tenant: Sure.
Agent: Here's the master bedroom. It has a walk-in closet. And through here is the bathroom with a bathtub and shower.
Tenant: What about utilities? Are they included?
Agent: Water and trash are included in the rent. You'd pay for electricity, gas, and internet separately. The previous tenant said utilities averaged about a hundred dollars a month.
Tenant: And the rent is fifteen hundred, you said?
Agent: That's right, fifteen hundred per month. First and last month's rent plus a security deposit equal to one month's rent.
Tenant: When would it be available?
Agent: The current tenant moves out on the thirtieth, so it would be available from the first of next month.
Tenant: I'm very interested. Can I have some time to think about it?
Agent: Of course. But I should mention we've had a lot of interest, so I'd recommend deciding within the next few days.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many bedrooms does the apartment have?',
            options: ['Two', 'One', 'Three', 'Four'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many square feet is the apartment?',
            options: ['About 900 square feet', 'About 700 square feet', 'About 1200 square feet', 'About 500 square feet'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The kitchen was renovated last ____.',
            correctText: 'year',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The tenant would need to use a shared laundry room.',
            correct: false,
            explanation: 'The unit has its own washer and dryer.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which utilities are included in the rent?',
            options: ['Water and trash', 'Electricity and gas', 'Internet and cable', 'All utilities'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much is the monthly rent?',
            options: ['1500 dollars', '1200 dollars', '1800 dollars', '2000 dollars'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _newsAnnouncements() {
    return [
      ListeningExercise(
        id: 'news_1',
        type: 'Bản tin / thông báo',
        title: 'Local weather update',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 90,
        audioUrl: _placeholderAudio,
        transcript: '''
Good evening and welcome to your local weather forecast.

Tonight, we're expecting partly cloudy skies with temperatures dropping to around fifteen degrees Celsius. There's a forty percent chance of light showers after midnight, so you might want to bring an umbrella if you're heading out late.

Tomorrow looks much better. We're expecting sunny skies in the morning with temperatures climbing to a comfortable twenty-five degrees by the afternoon. Perfect weather for outdoor activities.

However, a cold front is expected to move in by Thursday, bringing cooler temperatures and possible thunderstorms. Make sure to check back for updates as we get closer to the weekend.

For coastal areas, expect moderate winds of fifteen to twenty kilometers per hour. Beach conditions should be good tomorrow but may become dangerous by Thursday due to stronger winds and higher waves.

That's your weather update. Stay safe and have a great evening!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the chance of rain tonight?',
            options: ['40 percent', '60 percent', '20 percent', '80 percent'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What temperature is expected tomorrow afternoon?',
            options: ['25 degrees', '15 degrees', '30 degrees', '20 degrees'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'A cold front is expected on Wednesday.',
            correct: false,
            explanation: 'The cold front is expected on Thursday.',
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Expected wind speed is fifteen to ____ kilometers per hour.',
            correctText: 'twenty',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What will weather be like on Thursday?',
            options: ['Cooler with possible thunderstorms', 'Sunny and warm', 'Clear skies', 'Very hot'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'news_2',
        type: 'Bản tin / thông báo',
        title: 'Traffic report',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
This is your morning traffic update for the greater metropolitan area.

Starting with Highway 101 northbound, there's heavy congestion between exits fifteen and twenty-two due to an earlier accident. Two lanes are currently blocked, and traffic is backed up for approximately five miles. Delays of thirty to forty minutes are expected. If possible, consider taking Highway 280 as an alternate route.

The downtown area is experiencing normal rush hour traffic. However, there's road construction on Main Street between Third and Fifth Avenue. Expect single lane traffic and additional delays of about ten minutes in that area.

For those heading to the airport, the airport express road is currently flowing smoothly. However, parking lot B is full. Please use parking lots C or D, which have plenty of available spaces.

Public transportation is running on schedule. The Blue Line metro had a minor delay earlier this morning, but services have now returned to normal.

We'll have another update in thirty minutes. Drive safely and allow extra time for your commute today.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What caused congestion on Highway 101?',
            options: ['An accident', 'Construction', 'Weather', 'A parade'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long are the expected delays on Highway 101?',
            options: ['30-40 minutes', '10-20 minutes', '1 hour', '5 minutes'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Road construction is on Main Street between Third and ____ Avenue.',
            correctText: 'Fifth',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Parking lot B has plenty of spaces.',
            correct: false,
            explanation: 'Parking lot B is full.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the recommended alternate route for Highway 101?',
            options: ['Highway 280', 'Main Street', 'Airport express', 'Blue Line metro'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'news_3',
        type: 'Bản tin / thông báo',
        title: 'Breaking news: New tech discovery',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
Good evening. I'm Rebecca Chen with tonight's top story.

Scientists at Stanford University have announced a major breakthrough in battery technology that could revolutionize the electric vehicle industry. The new battery design, which uses a combination of silicon and graphene, can store three times more energy than current lithium-ion batteries while charging in just fifteen minutes.

Dr. Michael Park, the lead researcher, says the technology could be ready for commercial production within the next two to three years. Quote, "This is the advancement we've been waiting for. It solves the two biggest problems with electric vehicles: range anxiety and charging time." End quote.

The announcement has already had a significant impact on stock markets, with shares of major electric vehicle companies jumping by an average of eight percent today.

However, some experts urge caution. Professor Linda Williams from MIT notes that previous battery breakthroughs have faced challenges when scaling up for mass production. She suggests waiting for independent verification of the results before getting too excited.

The research was published today in the journal Nature Energy. We'll continue to follow this story and bring you updates as they develop.

In other news tonight...
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where was the battery breakthrough discovered?',
            options: ['Stanford University', 'MIT', 'Harvard', 'Princeton'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much more energy can the new battery store?',
            options: ['Three times more', 'Two times more', 'Five times more', 'Ten times more'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The new battery can charge in just ____ minutes.',
            correctText: 'fifteen',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The technology is already available for commercial use.',
            correct: false,
            explanation: 'It could be ready in 2-3 years.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did Professor Williams suggest?',
            options: ['Waiting for independent verification', 'Investing in electric vehicles', 'Ignoring the discovery', 'Buying new batteries now'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _storytelling() {
    return [
      ListeningExercise(
        id: 'story_1',
        type: 'Câu chuyện kể',
        title: 'A surprising day',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript:
            'Last Saturday, I planned to stay home and relax. But my friend called and invited me to a small art festival. I almost said no, but I decided to go. I met new people, tried local food, and even joined a short painting class. It turned out to be one of the best weekends this year.',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did the speaker plan originally?',
            options: ['Stay home', 'Travel abroad', 'Go shopping', 'Study all day'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where did the speaker go?',
            options: ['An art festival', 'A sports match', 'A cinema', 'A museum tour'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker immediately refused the invitation.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What activity did the speaker join?',
            options: ['Painting class', 'Cooking contest', 'Dance show', 'Marathon'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How does the speaker feel about the day?',
            options: ['Positive', 'Angry', 'Bored', 'Confused'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'It turned out to be one of the best ____ this year.',
            correctText: 'weekends',
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _miniLectures() {
    return [
      ListeningExercise(
        id: 'lecture_1',
        type: 'Bài giảng ngắn',
        title: 'Why sleep matters',
        level: 'Nâng cao (2–3 phút)',
        durationSeconds: 140,
        audioUrl: _placeholderAudio,
        transcript:
            'Sleep plays a crucial role in memory, mood, and overall health. During deep sleep, the brain processes information and strengthens learning. Lack of sleep can reduce concentration and increase stress. To improve sleep, keep a regular schedule, limit caffeine late in the day, and avoid screens before bedtime.',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the main topic?',
            options: ['Sleep and health', 'Cooking', 'Sports', 'Travel'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What happens during deep sleep?',
            options: [
              'The brain strengthens learning',
              'People eat more',
              'Phones charge faster',
              'Muscles stop working'
            ],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Lack of sleep can increase stress.',
            correct: true,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which tip is mentioned?',
            options: ['Limit caffeine late in the day', 'Run at night', 'Eat sugar before bed', 'Work overtime'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Avoid ____ before bedtime.',
            correctText: 'screens',
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _publicAnnouncements() {
    return [
      ListeningExercise(
        id: 'announce_1',
        type: 'Thông báo (sân bay/trường/công ty)',
        title: 'Airport gate change',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 75,
        audioUrl: _placeholderAudio,
        transcript:
            'Attention passengers on Flight 203 to Singapore. The departure gate has changed from Gate 12 to Gate 18. Boarding will begin in 20 minutes. Please proceed to Gate 18 as soon as possible.',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where does this announcement happen?',
            options: ['Airport', 'Restaurant', 'Library', 'Hospital'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What changed?',
            options: ['Departure gate', 'Flight number', 'Destination', 'Ticket price'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Gate changed to Gate ____.',
            correctText: '18',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Boarding begins in 20 minutes.',
            correct: true,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What should passengers do next?',
            options: ['Go to Gate 18', 'Leave the airport', 'Call a taxi', 'Buy luggage'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _interviews() {
    return [
      // 1. Career advice interview
      ListeningExercise(
        id: 'interview_1',
        type: 'Phỏng vấn',
        title: 'Career advice from a CEO',
        level: 'Nâng cao (2–3 phút)',
        durationSeconds: 180,
        audioUrl: _placeholderAudio,
        transcript: '''
Host: Welcome back to Career Talks. Today we have the pleasure of speaking with Maria Santos, CEO of TechForward. Maria, thank you for joining us.
Maria: Thank you for having me. I'm happy to be here.
Host: You started your career as an intern and now you run a company with over five hundred employees. What advice would you give to young professionals starting out?
Maria: I think the most important thing is to never stop learning. When I started, I didn't know everything, and honestly, I still don't. But I made it a habit to learn something new every single day, whether it was a new skill, a new perspective, or even learning from my mistakes.
Host: That's great advice. What was the biggest challenge you faced on your way to becoming CEO?
Maria: Honestly, it was learning to trust other people and delegate. As a young professional, I wanted to do everything myself because I thought that was the way to prove myself. But as I moved into leadership roles, I realized that great leaders build great teams. You can't do everything alone.
Host: And what about work-life balance? Running a company must be demanding.
Maria: It is, but I've learned to set boundaries. I don't check emails after eight pm, and I always try to spend weekends with my family. Of course, there are exceptions during busy periods, but generally, I protect my personal time. I've found that when I'm rested and happy, I'm a much better leader.
Host: Finally, what quality do you think is most important for success?
Maria: Resilience. Everyone faces setbacks and failures. What matters is how you respond to them. I've failed many times in my career, but each failure taught me something valuable. The key is to get back up, learn from it, and keep moving forward.
Host: Wonderful insights, Maria. Thank you so much for sharing your experience with us today.
Maria: My pleasure. Thank you for having me.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is Maria Santos\'s position?',
            options: ['CEO', 'Manager', 'Intern', 'Consultant'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many employees does her company have?',
            options: ['Over 500', 'Over 100', 'Over 1000', 'About 50'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Maria says the most important thing is to never stop ____.',
            correctText: 'learning',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What was her biggest challenge?',
            options: ['Learning to delegate', 'Finding a job', 'Learning English', 'Making money'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Maria checks emails after 8 pm regularly.',
            correct: false,
            explanation: 'She says she doesn\'t check emails after 8 pm.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What quality does Maria think is most important for success?',
            options: ['Resilience', 'Intelligence', 'Money', 'Luck'],
            correctIndex: 0,
          ),
        ],
      ),

      // 2. Travel blogger interview
      ListeningExercise(
        id: 'interview_2',
        type: 'Phỏng vấn',
        title: 'Interview with a travel blogger',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 140,
        audioUrl: _placeholderAudio,
        transcript: '''
Host: Today on the show, we have Jake Rodriguez, a full-time travel blogger who has visited over fifty countries in the past three years. Jake, welcome!
Jake: Thanks for having me! Excited to be here.
Host: Fifty countries in three years is incredible. How did you get started?
Jake: Well, it actually started by accident. I was working a regular office job and felt burned out. I took a two-week vacation to Thailand, started posting photos on social media, and people loved it. By the time I came back, I had gained ten thousand followers. That's when I thought, maybe I could turn this into something more.
Host: And how do you make money as a travel blogger?
Jake: There are several ways. The main ones are sponsored posts from hotels and tourism boards, affiliate marketing, and selling my own photography presets and travel guides. It took about a year before I was making enough to do this full-time.
Host: What's been your favorite destination so far?
Jake: That's a tough question! But if I had to choose, I'd say Japan. The mix of ancient traditions and modern technology is fascinating. The food is amazing, people are incredibly kind, and there's always something new to discover.
Host: Any tips for people who want to travel more but are on a budget?
Jake: Definitely! First, be flexible with your dates. Flying on a Tuesday or Wednesday is usually much cheaper than weekends. Second, consider staying in hostels or using home-sharing apps. And third, eat where the locals eat instead of tourist restaurants. You'll save money and have better food!
Host: Great tips! Thanks so much, Jake.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many countries has Jake visited?',
            options: ['Over 50', 'Over 100', 'About 30', 'About 20'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What job did Jake have before becoming a travel blogger?',
            options: ['Office job', 'Teacher', 'Doctor', 'Chef'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Jake gained ten thousand ____ during his first trip.',
            correctText: 'followers',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is Jake\'s favorite destination?',
            options: ['Japan', 'Thailand', 'France', 'Australia'],
            correctIndex: 0,
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Jake says flying on weekends is cheapest.',
            correct: false,
            explanation: 'He says flying on Tuesday or Wednesday is usually cheaper.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Jake recommend for budget travelers?',
            options: ['Eat where locals eat', 'Always fly first class', 'Stay at luxury hotels', 'Travel only on weekends'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _podcasts() {
    return [
      // 1. Productivity tips podcast
      ListeningExercise(
        id: 'pod_1',
        type: 'Podcast ngắn',
        title: 'Morning routines of successful people',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 120,
        audioUrl: _placeholderAudio,
        transcript: '''
Welcome to Daily Growth, the podcast that helps you become a better version of yourself. I'm your host, Alex, and today we're talking about morning routines.

Have you ever wondered what successful people do in the morning? Research shows that how you start your day has a huge impact on your productivity and mood.

Here are three common habits of successful people:

First, they wake up early. Most CEOs and entrepreneurs wake up before six am. This gives them quiet time before the busy day begins.

Second, they exercise. Whether it's a quick jog, yoga, or even a fifteen-minute walk, moving your body in the morning boosts energy and mental clarity.

Third, they plan their day. Before checking emails or social media, successful people take a few minutes to review their goals and prioritize their tasks.

Now, here's a challenge for you: This week, try waking up just thirty minutes earlier than usual. Use that time for yourself, whether it's exercising, reading, or simply enjoying a quiet cup of coffee.

Remember, small changes can lead to big results. That's all for today's episode. Thanks for listening, and I'll see you next time!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the main topic of this podcast?',
            options: ['Morning routines', 'Cooking recipes', 'Travel tips', 'Technology'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What time do most successful CEOs wake up?',
            options: ['Before 6 am', 'After 9 am', 'At noon', 'At midnight'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Moving your body in the morning boosts energy and mental ____.',
            correctText: 'clarity',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The host recommends checking social media first thing in the morning.',
            correct: false,
            explanation: 'He says to plan the day before checking emails or social media.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What challenge does the host give listeners?',
            options: ['Wake up 30 minutes earlier', 'Sleep less', 'Skip breakfast', 'Work overtime'],
            correctIndex: 0,
          ),
        ],
      ),

      // 2. Learning English podcast
      ListeningExercise(
        id: 'pod_2',
        type: 'Podcast ngắn',
        title: 'How to improve your English speaking',
        level: 'Cơ bản (30–60s)',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
Hello and welcome to English Every Day! Today I want to share some simple tips to help you improve your English speaking skills.

Tip number one: Practice every day. Even if it's just five minutes, speaking English regularly helps build your confidence. You can talk to yourself in the mirror, describe what you're doing, or practice with a language partner.

Tip number two: Don't be afraid of making mistakes. Mistakes are how we learn! Every time you make an error and correct it, your brain remembers the right way.

Tip number three: Listen more. Watching English movies, listening to podcasts like this one, or listening to English music exposes you to natural pronunciation and common expressions.

And finally, tip number four: Record yourself speaking. Then listen back and compare it to native speakers. This helps you notice areas you can improve.

Remember, becoming fluent takes time and patience. Don't give up! Practice a little bit every day, and you will see progress.

That's it for today. Keep practicing, and see you next time!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the podcast about?',
            options: ['Improving English speaking', 'Cooking tips', 'Travel advice', 'Business news'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the speaker say about mistakes?',
            options: ['They help us learn', 'They are bad', 'We should avoid them', 'They are embarrassing'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The speaker recommends recording yourself and comparing to ____ speakers.',
            correctText: 'native',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker says you need to practice for hours every day.',
            correct: false,
            explanation: 'He says even five minutes of practice helps.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many tips does the speaker give?',
            options: ['Four', 'Three', 'Five', 'Two'],
            correctIndex: 0,
          ),
        ],
      ),

      // 3. Health and wellness podcast
      ListeningExercise(
        id: 'pod_3',
        type: 'Podcast ngắn',
        title: 'Simple ways to reduce stress',
        level: 'Trung cấp (1–2 phút)',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
Welcome to Mindful Living! Today we're discussing something that affects almost everyone: stress.

In our busy modern lives, stress has become a common problem. But the good news is, there are simple things you can do to feel calmer and more relaxed.

First, practice deep breathing. When you feel stressed, take a moment to breathe deeply. Breathe in for four seconds, hold for four seconds, and breathe out for four seconds. This activates your body's relaxation response.

Second, take regular breaks. Working for long hours without breaks actually decreases productivity. Every ninety minutes, step away from your desk, stretch, or take a short walk.

Third, limit screen time before bed. The blue light from phones and computers can disrupt your sleep. Try to put away your devices at least one hour before bedtime.

Fourth, connect with others. Talking to friends and family, even just for a few minutes, can reduce stress hormones and improve your mood.

And finally, remember that it's okay to say no sometimes. You don't have to do everything. Prioritize what's important and let go of the rest.

Take care of yourself! That's all for today's episode.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the main topic?',
            options: ['Reducing stress', 'Making money', 'Learning languages', 'Cooking healthy food'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many seconds should you breathe in during deep breathing?',
            options: ['Four seconds', 'Ten seconds', 'One second', 'Thirty seconds'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The speaker recommends taking breaks every ____ minutes.',
            correctText: 'ninety',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Using your phone right before bed helps you sleep better.',
            correct: false,
            explanation: 'Blue light from phones can disrupt sleep.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What can reduce stress hormones according to the podcast?',
            options: ['Connecting with others', 'Working overtime', 'Eating junk food', 'Watching TV all day'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  // ==================== LEVEL-BASED EXERCISES ====================

  static List<ListeningExercise> _levelA1() {
    return [
      // A1-1: Simple greetings
      ListeningExercise(
        id: 'a1_1',
        type: 'A1 - Beginner',
        title: 'Meeting someone new',
        level: 'A1 - Beginner',
        durationSeconds: 40,
        audioUrl: _placeholderAudio,
        transcript: '''
Anna: Hello! My name is Anna. What is your name?
Tom: Hi Anna. I am Tom. Nice to meet you.
Anna: Nice to meet you too, Tom. Where are you from?
Tom: I am from England. I live in London. And you?
Anna: I am from Vietnam. I live in Ho Chi Minh City.
Tom: That's nice. How old are you?
Anna: I am twenty-five years old. And you?
Tom: I am twenty-eight. Do you like music?
Anna: Yes, I love music. I like pop music.
Tom: Me too! That's great.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the woman\'s name?',
            options: ['Anna', 'Mary', 'Lisa', 'Sarah'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where is Tom from?',
            options: ['England', 'America', 'Vietnam', 'France'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Anna lives in Ho Chi Minh ____.',
            correctText: 'City',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Anna is thirty years old.',
            correct: false,
            explanation: 'Anna is twenty-five years old.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What kind of music does Anna like?',
            options: ['Pop music', 'Rock music', 'Jazz', 'Classical'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-2: At the supermarket
      ListeningExercise(
        id: 'a1_2',
        type: 'A1 - Beginner',
        title: 'Shopping for food',
        level: 'A1 - Beginner',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Mom: Okay, we need some food. Do we have milk?
Dad: No, we don't. We need milk.
Mom: How many bottles?
Dad: Two bottles, please. And we need bread.
Mom: One loaf of bread?
Dad: Yes, and some eggs. How many eggs do we have?
Mom: We have three eggs. We need more.
Dad: Let's buy twelve eggs. Do we need fruit?
Mom: Yes! I want apples and bananas.
Dad: How many apples?
Mom: Five apples and six bananas.
Dad: Okay. Is that all?
Mom: Yes, I think so. Let's go pay.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many bottles of milk do they need?',
            options: ['Two', 'One', 'Three', 'Four'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many eggs do they have at home?',
            options: ['Three', 'Twelve', 'Six', 'Zero'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'They want to buy five apples and six ____.',
            correctText: 'bananas',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'They need two loaves of bread.',
            correct: false,
            explanation: 'They need one loaf of bread.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many eggs will they buy?',
            options: ['Twelve', 'Six', 'Three', 'Ten'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-3: Daily routine
      ListeningExercise(
        id: 'a1_3',
        type: 'A1 - Beginner',
        title: 'My daily routine',
        level: 'A1 - Beginner',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Hello! My name is Peter. I want to tell you about my day.

I wake up at seven o'clock every morning. First, I brush my teeth and wash my face. Then I eat breakfast. I usually have toast and orange juice.

I go to school at eight o'clock. I walk to school. It takes fifteen minutes. At school, I study English, math, and science.

I have lunch at twelve o'clock. I eat lunch at school with my friends.

After school, I go home at four o'clock. I do my homework. Then I watch TV or play games.

I have dinner at seven o'clock. I eat with my family. After dinner, I read a book.

I go to bed at ten o'clock. That is my day!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What time does Peter wake up?',
            options: ['Seven o\'clock', 'Six o\'clock', 'Eight o\'clock', 'Nine o\'clock'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How does Peter go to school?',
            options: ['He walks', 'By bus', 'By car', 'By bicycle'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Peter has lunch at ____ o\'clock.',
            correctText: 'twelve',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Peter goes to bed at nine o\'clock.',
            correct: false,
            explanation: 'Peter goes to bed at ten o\'clock.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Peter do after dinner?',
            options: ['Reads a book', 'Watches TV', 'Does homework', 'Goes to school'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-4: Family members
      ListeningExercise(
        id: 'a1_4',
        type: 'A1 - Beginner',
        title: 'My family',
        level: 'A1 - Beginner',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Hi! My name is Emma. I have a big family.

My father's name is John. He is forty-five years old. He is a teacher. He teaches math at a high school.

My mother's name is Mary. She is forty-two years old. She is a nurse. She works at the hospital.

I have one brother and one sister. My brother's name is Tom. He is sixteen years old. He likes soccer. My sister's name is Lucy. She is eight years old. She likes drawing.

We also have a dog. His name is Max. He is brown and white. He is very friendly.

I love my family very much!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is Emma\'s father\'s job?',
            options: ['Teacher', 'Doctor', 'Nurse', 'Engineer'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How old is Emma\'s mother?',
            options: ['42 years old', '45 years old', '40 years old', '38 years old'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Tom likes ____.',
            correctText: 'soccer',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Lucy is ten years old.',
            correct: false,
            explanation: 'Lucy is eight years old.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the dog\'s name?',
            options: ['Max', 'Tom', 'John', 'Lucy'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-5: Numbers and time
      ListeningExercise(
        id: 'a1_5',
        type: 'A1 - Beginner',
        title: 'What time is it?',
        level: 'A1 - Beginner',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Teacher: Good morning class! Today we will practice telling time.
Student: Good morning, Teacher!
Teacher: Look at the clock. What time is it now?
Student: It is nine o'clock.
Teacher: Very good! And what time does school finish?
Student: School finishes at three o'clock.
Teacher: Correct! Now, what time do you usually eat dinner?
Student: I usually eat dinner at six thirty.
Teacher: And what time do you go to bed?
Student: I go to bed at nine o'clock.
Teacher: Excellent! You know time very well. Now let's practice more.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What time is it in the class?',
            options: ['Nine o\'clock', 'Ten o\'clock', 'Eight o\'clock', 'Three o\'clock'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What time does school finish?',
            options: ['Three o\'clock', 'Four o\'clock', 'Two o\'clock', 'Five o\'clock'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The student eats dinner at six ____.',
            correctText: 'thirty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The student goes to bed at ten o\'clock.',
            correct: false,
            explanation: 'The student goes to bed at nine o\'clock.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the lesson about?',
            options: ['Telling time', 'Counting numbers', 'Colors', 'Animals'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-6: Colors and clothes
      ListeningExercise(
        id: 'a1_6',
        type: 'A1 - Beginner',
        title: 'My favorite clothes',
        level: 'A1 - Beginner',
        durationSeconds: 40,
        audioUrl: _placeholderAudio,
        transcript: '''
Today I want to tell you about my clothes.

I have a blue shirt. It is my favorite shirt. I wear it every Monday.

I also have black pants. They are very comfortable. I wear them to school.

My shoes are white. They are new. My mother bought them for me last week.

I have a red jacket. I wear it when it is cold outside.

What color are your clothes today?
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What color is the speaker\'s favorite shirt?',
            options: ['Blue', 'Red', 'White', 'Black'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What color are the pants?',
            options: ['Black', 'Blue', 'White', 'Brown'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The shoes are ____.',
            correctText: 'white',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The red jacket is worn when it is hot.',
            correct: false,
            explanation: 'It is worn when it is cold.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Who bought the shoes?',
            options: ['Mother', 'Father', 'Friend', 'Teacher'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-7: Weather
      ListeningExercise(
        id: 'a1_7',
        type: 'A1 - Beginner',
        title: 'What\'s the weather like?',
        level: 'A1 - Beginner',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Mom: Good morning! What's the weather like today?
Son: It's sunny, Mom!
Mom: That's nice. Is it hot or cold?
Son: It's a little hot. Can I wear shorts?
Mom: Yes, you can. But take a hat too.
Son: Okay! Is it going to rain later?
Mom: I don't think so. The sky is very blue.
Son: Good! I want to play outside with my friends.
Mom: That sounds fun. Don't forget your water bottle!
Son: I won't. Thank you, Mom!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the weather like?',
            options: ['Sunny', 'Rainy', 'Cloudy', 'Snowy'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the son want to wear?',
            options: ['Shorts', 'Pants', 'Jacket', 'Sweater'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Mom says to take a ____.',
            correctText: 'hat',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'It is going to rain later.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the son want to do?',
            options: ['Play outside', 'Watch TV', 'Read a book', 'Sleep'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-8: Food and drinks
      ListeningExercise(
        id: 'a1_8',
        type: 'A1 - Beginner',
        title: 'At the restaurant',
        level: 'A1 - Beginner',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Waiter: Hello! What would you like to eat?
Customer: I would like a hamburger, please.
Waiter: Would you like fries with that?
Customer: Yes, please.
Waiter: And what would you like to drink?
Customer: I would like orange juice.
Waiter: Large or small?
Customer: Large, please.
Waiter: Anything else?
Customer: No, thank you. That's all.
Waiter: Your total is twelve dollars.
Customer: Here you are. Thank you!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does the customer order to eat?',
            options: ['Hamburger', 'Pizza', 'Salad', 'Sandwich'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the customer drink?',
            options: ['Orange juice', 'Water', 'Coffee', 'Tea'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The customer wants a ____ drink.',
            correctText: 'large',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The total is ten dollars.',
            correct: false,
            explanation: 'The total is twelve dollars.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Does the customer want fries?',
            options: ['Yes', 'No', 'Maybe', 'Not mentioned'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-9: Animals
      ListeningExercise(
        id: 'a1_9',
        type: 'A1 - Beginner',
        title: 'My pets',
        level: 'A1 - Beginner',
        durationSeconds: 40,
        audioUrl: _placeholderAudio,
        transcript: '''
I have two pets. I have a cat and a fish.

My cat's name is Whiskers. She is three years old. She is gray and white. She likes to sleep on my bed. She eats cat food twice a day.

My fish's name is Goldie. He is orange. He lives in a small tank in my room. I feed him every morning.

I love my pets very much. They are my best friends.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many pets does the speaker have?',
            options: ['Two', 'One', 'Three', 'Four'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What color is Whiskers?',
            options: ['Gray and white', 'Black', 'Orange', 'Brown'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The fish\'s name is ____.',
            correctText: 'Goldie',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The cat is five years old.',
            correct: false,
            explanation: 'The cat is three years old.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where does the cat like to sleep?',
            options: ['On the bed', 'On the floor', 'In a tank', 'Outside'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-10: Numbers
      ListeningExercise(
        id: 'a1_10',
        type: 'A1 - Beginner',
        title: 'Counting things',
        level: 'A1 - Beginner',
        durationSeconds: 35,
        audioUrl: _placeholderAudio,
        transcript: '''
Teacher: Let's count! How many books are on the table?
Student: One, two, three, four, five. Five books!
Teacher: Very good! How many pencils are in the box?
Student: One, two, three... ten pencils!
Teacher: Excellent! And how many students are in our class?
Student: Let me count... twenty students!
Teacher: Perfect! You are very good at counting!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many books are on the table?',
            options: ['Five', 'Ten', 'Three', 'Twenty'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many pencils are in the box?',
            options: ['Ten', 'Five', 'Twenty', 'Three'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'There are ____ students in the class.',
            correctText: 'twenty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'There are fifteen students in the class.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What are they doing?',
            options: ['Counting', 'Reading', 'Writing', 'Drawing'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-11: Days of the week
      ListeningExercise(
        id: 'a1_11',
        type: 'A1 - Beginner',
        title: 'My week',
        level: 'A1 - Beginner',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Let me tell you about my week.

On Monday, I have English class. On Tuesday, I play soccer with my friends.

On Wednesday, I go to the library. On Thursday, I have music class. I play the piano.

On Friday, I visit my grandmother. On Saturday, I go shopping with my mom.

On Sunday, I rest at home. I watch TV and play video games.

I like Saturday the best because I love shopping!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'When does the speaker have English class?',
            options: ['Monday', 'Tuesday', 'Wednesday', 'Friday'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the speaker do on Wednesday?',
            options: ['Go to the library', 'Play soccer', 'Play piano', 'Go shopping'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'On Thursday, the speaker plays the ____.',
            correctText: 'piano',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker\'s favorite day is Sunday.',
            correct: false,
            explanation: 'The speaker likes Saturday the best.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Who does the speaker visit on Friday?',
            options: ['Grandmother', 'Friend', 'Teacher', 'Doctor'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-12: Body parts
      ListeningExercise(
        id: 'a1_12',
        type: 'A1 - Beginner',
        title: 'Head, shoulders, knees and toes',
        level: 'A1 - Beginner',
        durationSeconds: 40,
        audioUrl: _placeholderAudio,
        transcript: '''
Teacher: Touch your head!
Students: Head!
Teacher: Touch your shoulders!
Students: Shoulders!
Teacher: Touch your knees!
Students: Knees!
Teacher: Touch your toes!
Students: Toes!
Teacher: Great job! Now faster! Head, shoulders, knees, toes!
Students: Head, shoulders, knees, toes!
Teacher: And eyes, ears, mouth, and nose!
Students: Eyes, ears, mouth, and nose!
Teacher: Wonderful! You all did very well!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What do the students touch first?',
            options: ['Head', 'Shoulders', 'Knees', 'Toes'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do they touch after shoulders?',
            options: ['Knees', 'Head', 'Toes', 'Eyes'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Eyes, ears, mouth, and ____.',
            correctText: 'nose',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The students touch their hands.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What activity are they doing?',
            options: ['Learning body parts', 'Reading a book', 'Eating lunch', 'Watching TV'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-13: Classroom
      ListeningExercise(
        id: 'a1_13',
        type: 'A1 - Beginner',
        title: 'In the classroom',
        level: 'A1 - Beginner',
        durationSeconds: 40,
        audioUrl: _placeholderAudio,
        transcript: '''
Teacher: Please open your books to page ten.
Student 1: Teacher, I don't have my book.
Teacher: That's okay. Share with your friend.
Student 1: Thank you.
Teacher: Now, read the first sentence.
Student 2: "The cat is on the table."
Teacher: Very good! Now, write the sentence in your notebook.
Student 2: Can I use a pencil?
Teacher: Yes, you can use a pencil or a pen.
Student 1: Teacher, can I go to the bathroom?
Teacher: Yes, but come back quickly.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What page should they open to?',
            options: ['Page ten', 'Page five', 'Page twenty', 'Page one'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the problem of Student 1?',
            options: ['No book', 'No pencil', 'No notebook', 'No pen'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '"The cat is on the ____."',
            correctText: 'table',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Students can only use a pen.',
            correct: false,
            explanation: 'They can use a pencil or a pen.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where does Student 1 want to go?',
            options: ['Bathroom', 'Library', 'Home', 'Playground'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-14: Birthday party
      ListeningExercise(
        id: 'a1_14',
        type: 'A1 - Beginner',
        title: 'Happy birthday!',
        level: 'A1 - Beginner',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Today is my birthday! I am seven years old.

My friends come to my house. There are ten children at my party.

We have a big cake. The cake is chocolate. It has seven candles.

We play games. We play musical chairs. It is very fun.

I get many presents. I get a toy car, a book, and a ball.

I am very happy! This is the best birthday!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How old is the speaker today?',
            options: ['Seven', 'Ten', 'Eight', 'Six'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many children are at the party?',
            options: ['Ten', 'Seven', 'Five', 'Twelve'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The cake is ____.',
            correctText: 'chocolate',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'They play soccer at the party.',
            correct: false,
            explanation: 'They play musical chairs.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which is NOT a present mentioned?',
            options: ['A bicycle', 'A toy car', 'A book', 'A ball'],
            correctIndex: 0,
          ),
        ],
      ),

      // A1-15: Hobbies
      ListeningExercise(
        id: 'a1_15',
        type: 'A1 - Beginner',
        title: 'What do you like to do?',
        level: 'A1 - Beginner',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Teacher: What do you like to do in your free time?
Amy: I like to read books. I read every night before bed.
Teacher: That's wonderful! What about you, Tom?
Tom: I like to play video games. My favorite game is about cars.
Teacher: Interesting! And you, Lisa?
Lisa: I like to draw. I draw pictures of flowers and animals.
Teacher: Beautiful! What about you, Ben?
Ben: I like to ride my bicycle. I ride in the park on weekends.
Teacher: These are all great hobbies!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does Amy like to do?',
            options: ['Read books', 'Play games', 'Draw', 'Ride bicycle'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is Tom\'s favorite game about?',
            options: ['Cars', 'Animals', 'Sports', 'Space'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Lisa likes to ____ pictures.',
            correctText: 'draw',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Ben rides his bicycle every day.',
            correct: false,
            explanation: 'Ben rides on weekends.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Lisa draw?',
            options: ['Flowers and animals', 'Cars', 'People', 'Houses'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _levelA2() {
    return [
      // A2-1: Making plans
      ListeningExercise(
        id: 'a2_1',
        type: 'A2 - Elementary',
        title: 'Weekend plans',
        level: 'A2 - Elementary',
        durationSeconds: 60,
        audioUrl: _placeholderAudio,
        transcript: '''
Sarah: Hi Mike! Do you have any plans for the weekend?
Mike: Not really. I was thinking of staying home and watching movies. What about you?
Sarah: Actually, I'm going to visit the new art museum on Saturday. Do you want to come with me?
Mike: That sounds interesting! What time are you going?
Sarah: I'm planning to go around two in the afternoon. The museum closes at six, so we'll have plenty of time.
Mike: Great! How much is the entrance fee?
Sarah: It's ten dollars for adults. But I heard there's a student discount, so it might be cheaper for us.
Mike: Perfect. Should we have lunch together before we go?
Sarah: That's a good idea. There's a nice Italian restaurant near the museum. We could eat there at noon.
Mike: Sounds like a plan! I'll meet you at the restaurant at twelve.
Sarah: Wonderful! See you on Saturday then!
Mike: See you! I'm really looking forward to it.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where does Sarah want to go on Saturday?',
            options: ['Art museum', 'Shopping mall', 'Beach', 'Cinema'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What time will they visit the museum?',
            options: ['Two in the afternoon', 'Ten in the morning', 'Six in the evening', 'Noon'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The entrance fee is ____ dollars for adults.',
            correctText: 'ten',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'They will have lunch after visiting the museum.',
            correct: false,
            explanation: 'They will have lunch before going to the museum.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What kind of restaurant will they go to?',
            options: ['Italian', 'Chinese', 'Japanese', 'Mexican'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-2: Describing people
      ListeningExercise(
        id: 'a2_2',
        type: 'A2 - Elementary',
        title: 'My best friend',
        level: 'A2 - Elementary',
        durationSeconds: 65,
        audioUrl: _placeholderAudio,
        transcript: '''
Today I want to tell you about my best friend, Lisa.

Lisa and I have been friends since elementary school. We met when we were seven years old, and we've been close ever since.

Lisa is a really friendly person. She's also very funny and always makes me laugh. She has long brown hair and green eyes. She's quite tall, taller than me actually.

Lisa loves sports, especially swimming and tennis. She practices swimming three times a week at the local pool. She's really good at it and has won several competitions.

Besides sports, Lisa enjoys reading books. Her favorite genre is mystery novels. She always recommends good books to me.

Lisa is studying to become a doctor. She's very smart and works really hard. I'm sure she will be a great doctor one day.

I feel lucky to have Lisa as my friend. She's always there when I need help, and she's a great listener. That's why she's my best friend.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'When did they become friends?',
            options: ['When they were seven', 'In high school', 'Last year', 'When they were teenagers'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What color are Lisa\'s eyes?',
            options: ['Green', 'Blue', 'Brown', 'Black'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Lisa practices swimming ____ times a week.',
            correctText: 'three',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Lisa wants to become a teacher.',
            correct: false,
            explanation: 'Lisa is studying to become a doctor.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What kind of books does Lisa like?',
            options: ['Mystery novels', 'Romance', 'Science fiction', 'Comics'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-3: Giving directions
      ListeningExercise(
        id: 'a2_3',
        type: 'A2 - Elementary',
        title: 'Finding the library',
        level: 'A2 - Elementary',
        durationSeconds: 55,
        audioUrl: _placeholderAudio,
        transcript: '''
Tourist: Excuse me, could you tell me how to get to the public library?
Local: Of course! It's not far from here. Let me explain.
Tourist: Thank you so much.
Local: First, go straight down this road for about two hundred meters. You'll pass a supermarket on your left.
Tourist: Okay, two hundred meters, supermarket on the left.
Local: Then, at the traffic lights, turn right onto Oak Street.
Tourist: Turn right at the traffic lights.
Local: Yes. Walk along Oak Street for about one hundred meters. You'll see a big park on your right side.
Tourist: A park on the right, got it.
Local: The library is right next to the park. It's a large gray building with big glass doors. You can't miss it.
Tourist: Great! So about how long will it take to walk there?
Local: About ten to fifteen minutes, depending on how fast you walk.
Tourist: Perfect. Thank you for your help!
Local: You're welcome. Have a nice day!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the tourist looking for?',
            options: ['The library', 'The supermarket', 'The park', 'The hospital'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What will the tourist pass first?',
            options: ['A supermarket', 'A park', 'A hospital', 'A school'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'At the traffic lights, turn ____ onto Oak Street.',
            correctText: 'right',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The library is across from the park.',
            correct: false,
            explanation: 'The library is next to the park.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long will it take to walk to the library?',
            options: ['10-15 minutes', '5 minutes', '30 minutes', '1 hour'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-4: At the pharmacy
      ListeningExercise(
        id: 'a2_4',
        type: 'A2 - Elementary',
        title: 'Buying medicine',
        level: 'A2 - Elementary',
        durationSeconds: 55,
        audioUrl: _placeholderAudio,
        transcript: '''
Pharmacist: Good afternoon! How can I help you?
Customer: Hi, I have a bad cold. I need something for my sore throat and runny nose.
Pharmacist: I'm sorry to hear that. How long have you been sick?
Customer: About three days now.
Pharmacist: I see. Do you have a fever?
Customer: No, just the sore throat and runny nose. I also have a headache.
Pharmacist: Okay. I recommend this cold medicine. It will help with all your symptoms. Take one tablet every six hours.
Customer: How many days should I take it?
Pharmacist: Take it for five days. If you don't feel better, see a doctor.
Customer: Alright. How much does it cost?
Pharmacist: It's eight dollars and fifty cents for a box of twenty tablets.
Customer: I'll take it. Can I pay by card?
Pharmacist: Of course. Also, remember to drink lots of water and get plenty of rest.
Customer: Thank you for your advice!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is wrong with the customer?',
            options: ['Has a cold', 'Broke a leg', 'Has an allergy', 'Needs vitamins'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How often should the customer take the medicine?',
            options: ['Every six hours', 'Every four hours', 'Twice a day', 'Once a day'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The customer has been sick for about ____ days.',
            correctText: 'three',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The customer has a fever.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much does the medicine cost?',
            options: ['8 dollars 50 cents', '10 dollars', '5 dollars', '15 dollars'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-5: Booking a taxi
      ListeningExercise(
        id: 'a2_5',
        type: 'A2 - Elementary',
        title: 'Calling a taxi',
        level: 'A2 - Elementary',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Operator: City Taxi Service. How can I help you?
Customer: Hi, I'd like to book a taxi, please.
Operator: Sure. Where would you like to be picked up?
Customer: From 25 Park Avenue, please.
Operator: And where are you going?
Customer: To the central train station.
Operator: When do you need the taxi?
Customer: As soon as possible. My train leaves in forty-five minutes.
Operator: Okay, a taxi will be there in about ten minutes. The fare to the train station is approximately fifteen dollars.
Customer: That's fine. Do I pay the driver directly?
Operator: Yes, you can pay in cash or by card. Can I have your name and phone number?
Customer: It's Sarah Johnson, and my number is 555-0123.
Operator: Thank you, Ms. Johnson. Your taxi will arrive shortly. Look for a blue car.
Customer: Great, thank you!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where does the customer want to go?',
            options: ['Train station', 'Airport', 'Bus station', 'Hotel'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long until the taxi arrives?',
            options: ['About 10 minutes', 'About 45 minutes', 'About 5 minutes', 'About 30 minutes'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The fare is approximately ____ dollars.',
            correctText: 'fifteen',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The customer can only pay in cash.',
            correct: false,
            explanation: 'The customer can pay in cash or by card.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What color is the taxi?',
            options: ['Blue', 'Yellow', 'White', 'Black'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-6: At the post office
      ListeningExercise(
        id: 'a2_6',
        type: 'A2 - Elementary',
        title: 'Sending a package',
        level: 'A2 - Elementary',
        durationSeconds: 55,
        audioUrl: _placeholderAudio,
        transcript: '''
Customer: Hi, I'd like to send this package to London, please.
Clerk: Sure. Let me weigh it first... It's two kilograms. Would you like standard or express delivery?
Customer: What's the difference?
Clerk: Standard takes about seven to ten days and costs twelve dollars. Express takes three to five days and costs twenty-five dollars.
Customer: I'll go with standard. It's not urgent.
Clerk: Okay. Do you need any insurance for the package?
Customer: What's inside matters a lot to me. How much is insurance?
Clerk: Insurance up to one hundred dollars costs three dollars extra.
Customer: Yes, please add that.
Clerk: Your total is fifteen dollars. Would you like a receipt?
Customer: Yes, please.
Clerk: Here you go. Your tracking number is on the receipt.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where is the package going?',
            options: ['London', 'Paris', 'New York', 'Tokyo'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How heavy is the package?',
            options: ['2 kilograms', '5 kilograms', '1 kilogram', '10 kilograms'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Standard delivery costs ____ dollars.',
            correctText: 'twelve',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Express delivery takes 7-10 days.',
            correct: false,
            explanation: 'Express takes 3-5 days.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the total cost?',
            options: ['15 dollars', '12 dollars', '25 dollars', '3 dollars'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-7: Movie theater
      ListeningExercise(
        id: 'a2_7',
        type: 'A2 - Elementary',
        title: 'Buying movie tickets',
        level: 'A2 - Elementary',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Staff: Welcome to Cinema World. What movie would you like to see?
Customer: Two tickets for "Space Adventure," please.
Staff: Great choice! We have showings at five fifteen, seven thirty, and nine forty-five tonight.
Customer: The seven thirty show, please.
Staff: Would you like regular seats or premium seats?
Customer: What's the difference?
Staff: Premium seats are in the center with more legroom. They're three dollars extra per ticket.
Customer: Regular seats are fine.
Staff: Okay, that's twenty-four dollars for two tickets. Cash or card?
Customer: Card, please.
Staff: Here are your tickets. Theater four, on your right. The movie starts in twenty minutes.
Customer: Do we have time to buy popcorn?
Staff: Yes, the snack bar is right over there. Enjoy the movie!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Which movie do they want to see?',
            options: ['Space Adventure', 'Love Story', 'Action Hero', 'Comedy Night'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What time is their showing?',
            options: ['7:30', '5:15', '9:45', '8:00'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Two regular tickets cost ____ dollars.',
            correctText: 'twenty-four',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'They choose premium seats.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which theater is the movie in?',
            options: ['Theater 4', 'Theater 2', 'Theater 7', 'Theater 1'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-8: Hair salon
      ListeningExercise(
        id: 'a2_8',
        type: 'A2 - Elementary',
        title: 'Getting a haircut',
        level: 'A2 - Elementary',
        durationSeconds: 55,
        audioUrl: _placeholderAudio,
        transcript: '''
Stylist: Hello! Do you have an appointment?
Customer: Yes, at three o'clock. The name is James.
Stylist: Welcome, James. Please have a seat. What would you like today?
Customer: I'd like a haircut, please. Not too short.
Stylist: How about this length? About two centimeters off?
Customer: Yes, that sounds good.
Stylist: Would you like me to wash your hair first?
Customer: Yes, please.
Stylist: Okay, let's start with the wash. The water temperature is okay?
Customer: It's perfect.
Stylist: Great. After the cut, would you like some hair gel or wax?
Customer: No, thank you. Just natural is fine.
Stylist: Alright. That will be eighteen dollars total.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What time is James\'s appointment?',
            options: ['3 o\'clock', '2 o\'clock', '4 o\'clock', '1 o\'clock'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much hair will be cut off?',
            options: ['About 2 centimeters', 'About 5 centimeters', 'Very short', 'Half'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The haircut costs ____ dollars.',
            correctText: 'eighteen',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'James wants hair gel after the cut.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Does James get his hair washed?',
            options: ['Yes', 'No', 'Maybe later', 'Not mentioned'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-9: Library
      ListeningExercise(
        id: 'a2_9',
        type: 'A2 - Elementary',
        title: 'Borrowing books',
        level: 'A2 - Elementary',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Librarian: Good afternoon. How can I help you?
Student: Hi, I'd like to borrow these three books.
Librarian: Do you have your library card?
Student: Yes, here it is.
Librarian: Let me scan it... Okay, you can borrow books for two weeks.
Student: Can I renew them if I need more time?
Librarian: Yes, you can renew online or come back here. You can renew twice.
Student: What happens if I return them late?
Librarian: There's a fine of twenty cents per day per book.
Student: I see. Thank you.
Librarian: You're welcome. The return date is January fifteenth. Have a nice day!
Student: Thanks! You too!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many books does the student borrow?',
            options: ['Three', 'Two', 'Five', 'One'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long can books be borrowed?',
            options: ['Two weeks', 'One week', 'One month', 'Three days'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The late fee is ____ cents per day.',
            correctText: 'twenty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Books can only be renewed at the library.',
            correct: false,
            explanation: 'You can renew online or at the library.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many times can you renew?',
            options: ['Twice', 'Once', 'Three times', 'Unlimited'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-10: Mobile phone store
      ListeningExercise(
        id: 'a2_10',
        type: 'A2 - Elementary',
        title: 'Buying a phone',
        level: 'A2 - Elementary',
        durationSeconds: 60,
        audioUrl: _placeholderAudio,
        transcript: '''
Staff: Hi! Are you looking for a new phone?
Customer: Yes, my old phone broke last week.
Staff: I'm sorry to hear that. What features are important to you?
Customer: I mainly use it for photos and social media. Battery life is also important.
Staff: I recommend this model. It has an excellent camera with three lenses and the battery lasts two days.
Customer: That sounds good. How much is it?
Staff: It's four hundred and ninety-nine dollars. We also have a payment plan if you prefer.
Customer: What's the payment plan?
Staff: You pay fifty dollars per month for twelve months, with no interest.
Customer: That works better for me. Do you have it in blue?
Staff: Let me check... Yes, we have blue and black. Would you like a screen protector too?
Customer: Yes, please. How much extra is that?
Staff: It's twenty dollars, and we'll put it on for free.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Why does the customer need a new phone?',
            options: ['Old phone broke', 'Wants an upgrade', 'Lost the old one', 'Gift for someone'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long does the battery last?',
            options: ['Two days', 'One day', 'Three days', 'One week'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The monthly payment is ____ dollars.',
            correctText: 'fifty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The payment plan has interest.',
            correct: false,
            explanation: 'There is no interest.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much is the screen protector?',
            options: ['20 dollars', '10 dollars', '30 dollars', 'Free'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-11: Job interview basic
      ListeningExercise(
        id: 'a2_11',
        type: 'A2 - Elementary',
        title: 'Simple job interview',
        level: 'A2 - Elementary',
        durationSeconds: 55,
        audioUrl: _placeholderAudio,
        transcript: '''
Manager: Hello, please sit down. So you want to work at our cafe?
Applicant: Yes, I'm very interested in this job.
Manager: Do you have any experience?
Applicant: Yes, I worked at a restaurant for six months last year.
Manager: Good. Can you work weekends?
Applicant: Yes, I'm available every day except Monday.
Manager: Why not Monday?
Applicant: I have English class on Monday evenings.
Manager: That's fine. The job pays ten dollars per hour. You'd work from nine to five.
Applicant: That sounds perfect.
Manager: When can you start?
Applicant: I can start next week.
Manager: Great! Can you come for training on Thursday at nine am?
Applicant: Yes, I'll be there. Thank you so much!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What job is the person applying for?',
            options: ['Cafe worker', 'Teacher', 'Office worker', 'Driver'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much work experience does the applicant have?',
            options: ['Six months', 'One year', 'Two years', 'None'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The job pays ____ dollars per hour.',
            correctText: 'ten',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The applicant can work on Mondays.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'When is the training?',
            options: ['Thursday at 9 am', 'Monday at 9 am', 'Next week', 'Friday afternoon'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-12: Renting a bicycle
      ListeningExercise(
        id: 'a2_12',
        type: 'A2 - Elementary',
        title: 'Bicycle rental',
        level: 'A2 - Elementary',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Staff: Hello! Would you like to rent a bicycle?
Tourist: Yes, please. How much is it?
Staff: It's eight dollars per hour or thirty dollars for the whole day.
Tourist: I think I'll need it for about three hours.
Staff: In that case, the whole day rate is better value.
Tourist: You're right. I'll take the day rate.
Staff: Great choice. I'll need your ID and a fifty dollar deposit.
Tourist: Here's my passport. Do I get the deposit back?
Staff: Yes, when you return the bicycle undamaged.
Tourist: What time do I need to return it?
Staff: We close at six pm, so please return it before then.
Tourist: Perfect. Do you have a map of good cycling routes?
Staff: Yes, here's a map. The riverside path is beautiful.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How much is the whole day rental?',
            options: ['30 dollars', '8 dollars', '50 dollars', '24 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much is the deposit?',
            options: ['50 dollars', '30 dollars', '8 dollars', '100 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The shop closes at ____ pm.',
            correctText: 'six',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The tourist uses a driver\'s license as ID.',
            correct: false,
            explanation: 'The tourist uses a passport.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which route does the staff recommend?',
            options: ['Riverside path', 'Mountain trail', 'City center', 'Park route'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-13: Making an appointment
      ListeningExercise(
        id: 'a2_13',
        type: 'A2 - Elementary',
        title: 'Dentist appointment',
        level: 'A2 - Elementary',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Receptionist: Good morning, Smile Dental Clinic.
Patient: Hi, I'd like to make an appointment for a check-up.
Receptionist: Sure. Have you been to our clinic before?
Patient: No, this is my first time.
Receptionist: Okay, I'll need to create a new file. What's your name?
Patient: It's Maria Garcia.
Receptionist: Thank you. When would you like to come in?
Patient: Is there anything available this week?
Receptionist: Let me see... We have Thursday at two pm or Friday at ten am.
Patient: Friday morning works better for me.
Receptionist: Great. Please arrive ten minutes early to fill out some forms.
Patient: Okay. Should I bring anything?
Receptionist: Just your ID and insurance card if you have one.
Patient: Perfect. See you Friday!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What kind of appointment is it?',
            options: ['Dental check-up', 'Eye exam', 'Physical', 'Blood test'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'When is the appointment?',
            options: ['Friday at 10 am', 'Thursday at 2 pm', 'Monday morning', 'Wednesday afternoon'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The patient\'s name is Maria ____.',
            correctText: 'Garcia',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Maria has been to this clinic before.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How early should she arrive?',
            options: ['10 minutes', '30 minutes', '5 minutes', '1 hour'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-14: Weather conversation
      ListeningExercise(
        id: 'a2_14',
        type: 'A2 - Elementary',
        title: 'Weather discussion',
        level: 'A2 - Elementary',
        durationSeconds: 45,
        audioUrl: _placeholderAudio,
        transcript: '''
Amy: What's the weather like today?
Ben: It's quite nice. Sunny but a bit windy.
Amy: Really? I heard it might rain this afternoon.
Ben: Yes, the forecast says rain after three o'clock.
Amy: Should I bring an umbrella?
Ben: Definitely. And maybe a light jacket. It's getting cooler in the evening.
Amy: What about tomorrow?
Ben: Tomorrow looks better. Sunny all day with temperatures around twenty-five degrees.
Amy: Perfect! I'm planning a picnic.
Ben: That sounds nice. Where are you going?
Amy: To Central Park. Want to join us?
Ben: Sure, I'd love to!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the weather like now?',
            options: ['Sunny but windy', 'Rainy', 'Cloudy', 'Snowy'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'When might it rain?',
            options: ['After 3 pm', 'In the morning', 'All day', 'At midnight'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Tomorrow\'s temperature will be around ____ degrees.',
            correctText: 'twenty-five',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Ben doesn\'t want to join the picnic.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where is the picnic?',
            options: ['Central Park', 'Beach', 'Mountain', 'Lake'],
            correctIndex: 0,
          ),
        ],
      ),

      // A2-15: Lost and found
      ListeningExercise(
        id: 'a2_15',
        type: 'A2 - Elementary',
        title: 'Lost item',
        level: 'A2 - Elementary',
        durationSeconds: 50,
        audioUrl: _placeholderAudio,
        transcript: '''
Passenger: Excuse me, I think I left my bag on the train.
Staff: Oh dear. What does your bag look like?
Passenger: It's a small black backpack with a red zipper.
Staff: Do you remember which train you were on?
Passenger: Yes, the ten fifteen train from Central Station.
Staff: And which car were you in?
Passenger: Car number three, near the door.
Staff: What was inside the bag?
Passenger: My wallet, phone, and some books.
Staff: Let me check with lost and found... Good news! Someone turned in a black backpack. Can you describe anything else to confirm it's yours?
Passenger: There should be a keychain with a little teddy bear on it.
Staff: Yes, that matches! Here's your bag.
Passenger: Oh, thank you so much! I was so worried!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did the passenger lose?',
            options: ['A backpack', 'A suitcase', 'An umbrella', 'A phone'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What color is the zipper?',
            options: ['Red', 'Black', 'Blue', 'White'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The passenger was in car number ____.',
            correctText: 'three',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The bag was not found.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What keychain is on the bag?',
            options: ['Teddy bear', 'Heart', 'Star', 'Cat'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _levelB1() {
    return [
      // B1-1: Travel experience
      ListeningExercise(
        id: 'b1_1',
        type: 'B1 - Intermediate',
        title: 'My trip to Japan',
        level: 'B1 - Intermediate',
        durationSeconds: 90,
        audioUrl: _placeholderAudio,
        transcript: '''
Last spring, I had the opportunity to visit Japan for two weeks, and it was absolutely incredible.

I started my trip in Tokyo, which is a fascinating mix of traditional culture and modern technology. One moment you're walking through ancient temples, and the next you're surrounded by futuristic skyscrapers and neon lights. I spent about five days exploring the city, visiting famous places like the Shibuya crossing, the Meiji Shrine, and the Tokyo Skytree.

From Tokyo, I took the bullet train to Kyoto. The Shinkansen, as they call it, was amazingly fast and comfortable. The journey only took about two hours, even though the cities are quite far apart. In Kyoto, I visited beautiful traditional gardens, ancient temples, and even attended a traditional tea ceremony. It was a very peaceful and cultural experience.

The food was another highlight of my trip. Japanese cuisine is so diverse and delicious. I tried everything from sushi and ramen to tempura and okonomiyaki. My favorite was probably the fresh sushi at Tsukiji market in Tokyo.

One thing that really impressed me was how clean and organized everything was. The trains were always on time, people were incredibly polite, and even the busy streets were spotless.

I definitely want to go back someday and explore more of the country, especially the northern region of Hokkaido.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How long was the speaker\'s trip to Japan?',
            options: ['Two weeks', 'One week', 'One month', 'Five days'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How did the speaker travel from Tokyo to Kyoto?',
            options: ['By bullet train', 'By plane', 'By bus', 'By car'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The journey from Tokyo to Kyoto took about ____ hours.',
            correctText: 'two',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker\'s favorite food was ramen.',
            correct: false,
            explanation: 'The speaker\'s favorite was fresh sushi.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What impressed the speaker most about Japan?',
            options: ['How clean and organized it was', 'The low prices', 'The weather', 'The nightlife'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where does the speaker want to visit next time?',
            options: ['Hokkaido', 'Osaka', 'Okinawa', 'Nagoya'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-2: Job discussion
      ListeningExercise(
        id: 'b1_2',
        type: 'B1 - Intermediate',
        title: 'Discussing work problems',
        level: 'B1 - Intermediate',
        durationSeconds: 85,
        audioUrl: _placeholderAudio,
        transcript: '''
Emma: Hey David, do you have a minute? I need some advice about something at work.
David: Sure, what's going on?
Emma: Well, I've been having some issues with my workload lately. My manager keeps giving me more projects, and I'm struggling to keep up with everything.
David: That sounds stressful. Have you talked to your manager about it?
Emma: Not yet. I'm worried they'll think I can't handle the job.
David: I understand, but it's important to communicate. Maybe they don't realize how much work you already have.
Emma: You might be right. How should I approach the conversation?
David: I'd suggest making a list of all your current projects and deadlines. Then ask for a meeting to discuss priorities. Show them you're being proactive, not complaining.
Emma: That's good advice. I should probably also ask about getting some help from the team.
David: Exactly. Sometimes managers assign work without checking if there's capacity. If they see the full picture, they might redistribute some tasks.
Emma: I think I also need to learn to say no sometimes. I always volunteer for extra work because I want to make a good impression.
David: That's admirable, but you can't pour from an empty cup. Taking care of yourself is important for doing your best work.
Emma: You're right. Thanks for listening, David. I feel better about handling this now.
David: Anytime! Good luck with the conversation.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is Emma\'s main problem?',
            options: ['Too much workload', 'Low salary', 'Bad colleagues', 'Long commute'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Why hasn\'t Emma talked to her manager yet?',
            options: ['She worries they\'ll think she can\'t handle the job', 'Her manager is on vacation', 'She doesn\'t like her manager', 'She\'s too busy'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'David suggests making a list of all current projects and ____.',
            correctText: 'deadlines',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Emma says she often refuses extra work.',
            correct: false,
            explanation: 'Emma says she always volunteers for extra work.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does David mean by "you can\'t pour from an empty cup"?',
            options: ['You need to take care of yourself first', 'You need more money', 'You should drink more water', 'You need a new job'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-3: University life
      ListeningExercise(
        id: 'b1_3',
        type: 'B1 - Intermediate',
        title: 'Choosing a major',
        level: 'B1 - Intermediate',
        durationSeconds: 80,
        audioUrl: _placeholderAudio,
        transcript: '''
Kate: I'm having trouble deciding what to major in at university. My parents want me to study medicine, but I'm more interested in art.
Mark: That's a tough situation. Have you talked to them about how you feel?
Kate: I tried, but they think art isn't practical. They're worried I won't be able to find a good job.
Mark: I understand their concern, but following your passion is important too. What kind of art are you interested in?
Kate: Graphic design, mainly. I love creating digital artwork and designing logos.
Mark: That's actually a growing field! Companies always need designers for marketing, websites, and branding.
Kate: That's what I've been trying to tell them. Plus, I could even work freelance and be my own boss someday.
Mark: Maybe you could show them some research about career opportunities in graphic design. Statistics and salary information might help convince them.
Kate: Good idea. I should also mention that some top designers earn more than doctors!
Mark: Exactly. At the end of the day, you'll spend most of your life working. It's important to choose something you enjoy.
Kate: You're right. I'll prepare some information and have another conversation with them.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What do Kate\'s parents want her to study?',
            options: ['Medicine', 'Art', 'Business', 'Engineering'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What kind of art is Kate interested in?',
            options: ['Graphic design', 'Painting', 'Sculpture', 'Photography'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Kate could work ____ and be her own boss.',
            correctText: 'freelance',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Mark thinks Kate should follow her parents\' wishes.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Mark suggest Kate do?',
            options: ['Show research about career opportunities', 'Give up on art', 'Study medicine first', 'Move away from home'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-4: Healthy lifestyle
      ListeningExercise(
        id: 'b1_4',
        type: 'B1 - Intermediate',
        title: 'Getting fit',
        level: 'B1 - Intermediate',
        durationSeconds: 75,
        audioUrl: _placeholderAudio,
        transcript: '''
Lisa: I've decided to start exercising more. I've been feeling so tired lately.
Tom: That's great! What kind of exercise are you thinking about?
Lisa: I'm not sure yet. I tried going to the gym last year, but I got bored after a month.
Tom: Maybe you need something more social. Have you considered joining a sports club?
Lisa: Like what?
Tom: There's a badminton club near my place. They meet twice a week and it's really fun. You don't even realize you're exercising because you're focused on the game.
Lisa: That sounds more interesting than running on a treadmill. Is it expensive?
Tom: It's thirty dollars a month, which includes equipment rental. And the first session is free, so you can try it out.
Lisa: What about my diet? I know I should eat better too.
Tom: Start with small changes. Maybe replace one unhealthy snack with fruit, or cook at home more often instead of ordering takeout.
Lisa: I do order a lot of takeout. It's just so convenient after a long day at work.
Tom: I know what you mean. Maybe try meal prepping on Sundays? Cook a big batch of healthy food and divide it into portions for the week.
Lisa: That's actually a brilliant idea. I'll give it a try!
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Why does Lisa want to start exercising?',
            options: ['She feels tired lately', 'She wants to lose weight', 'Her doctor recommended it', 'She wants to compete'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What sport does Tom recommend?',
            options: ['Badminton', 'Tennis', 'Swimming', 'Running'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The sports club costs ____ dollars a month.',
            correctText: 'thirty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Lisa enjoyed going to the gym last year.',
            correct: false,
            explanation: 'She got bored after a month.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Tom suggest for eating healthier?',
            options: ['Meal prepping on Sundays', 'Skipping meals', 'Only eating salads', 'Going on a strict diet'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-5: Technology problems
      ListeningExercise(
        id: 'b1_5',
        type: 'B1 - Intermediate',
        title: 'Computer issues',
        level: 'B1 - Intermediate',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Client: Hi, I'm having problems with my laptop. It's running really slowly.
Tech: How long has this been happening?
Client: It started about two weeks ago. Now it takes forever to open programs.
Tech: Have you installed any new software recently?
Client: Yes, I downloaded a free video editing program.
Tech: That might be the issue. Free software sometimes comes with hidden programs that slow down your computer. Let me check... Yes, I can see several unnecessary programs running in the background.
Client: Oh no. Can you remove them?
Tech: Yes, I can clean everything up. I'd also recommend running an antivirus scan and updating your operating system.
Client: How long will that take?
Tech: About an hour for everything. While I'm at it, I noticed your hard drive is almost full. That also affects performance.
Client: Really? I don't have that many files.
Tech: You'd be surprised how much space photos and videos take up. Consider moving old files to cloud storage or an external drive.
Client: That makes sense. How much will this all cost?
Tech: The cleanup and scan will be forty dollars. If you want me to help transfer files to the cloud, that's an extra twenty.
Client: Let's do the cleanup first and see how it goes.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the client\'s main problem?',
            options: ['Laptop running slowly', 'No internet connection', 'Broken screen', 'Lost files'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What likely caused the problem?',
            options: ['Free video editing software', 'Old hardware', 'Virus email', 'Water damage'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The cleanup will take about ____ hour(s).',
            correctText: 'an',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The hard drive has plenty of space.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much is the basic cleanup service?',
            options: ['40 dollars', '20 dollars', '60 dollars', '100 dollars'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-6: House hunting
      ListeningExercise(
        id: 'b1_6',
        type: 'B1 - Intermediate',
        title: 'Looking for an apartment',
        level: 'B1 - Intermediate',
        durationSeconds: 85,
        audioUrl: _placeholderAudio,
        transcript: '''
Agent: So you're looking for a two-bedroom apartment in the city center?
Client: Yes, preferably close to public transportation. I don't have a car.
Agent: I have three options that might work for you. The first one is on Oak Street, just a five-minute walk from the metro station.
Client: That sounds convenient. What's the rent?
Agent: It's sixteen hundred dollars per month, utilities not included. It has a small balcony and a modern kitchen.
Client: A bit above my budget. What about the second option?
Agent: The second one is slightly further from the metro, about a twelve-minute walk, but it's only twelve hundred dollars. It's in an older building but well-maintained.
Client: That's more affordable. What about parking for guests?
Agent: Street parking is available but can be difficult to find on weekends.
Client: And the third option?
Agent: The third is actually a newer building with a gym and rooftop terrace. It's fourteen hundred with water included. The metro is an eight-minute walk.
Client: That sounds like a good balance. Can I see all three?
Agent: Of course. How about Saturday morning?
Client: Perfect. What time?
Agent: Let's say ten am. I'll send you the addresses.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How many bedrooms does the client want?',
            options: ['Two', 'One', 'Three', 'Four'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Why is public transportation important to the client?',
            options: ['They don\'t have a car', 'It\'s cheaper', 'They like trains', 'For exercise'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The second apartment costs ____ dollars per month.',
            correctText: 'twelve hundred',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The first apartment is the cheapest.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What amenities does the third building have?',
            options: ['Gym and rooftop terrace', 'Pool and parking', 'Garden and playground', 'Spa and restaurant'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-7: Shopping experience
      ListeningExercise(
        id: 'b1_7',
        type: 'B1 - Intermediate',
        title: 'Returning a product',
        level: 'B1 - Intermediate',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Customer: Hi, I'd like to return this jacket, please.
Staff: Of course. Do you have the receipt?
Customer: Yes, here it is. I bought it last week.
Staff: May I ask what's wrong with it?
Customer: It's not the size I ordered. I ordered a medium online, but they sent a large.
Staff: I'm sorry about that. Would you like to exchange it for the correct size?
Customer: I would, but can you check if you have medium in stock?
Staff: Let me look... Unfortunately, we don't have medium in blue. We have it in black or gray.
Customer: I really wanted blue. Can you order it for me?
Staff: Yes, but it would take about five to seven business days to arrive.
Customer: That's too long. I have an event this weekend.
Staff: I understand. In that case, would you prefer a refund?
Customer: Yes, I think that's best. I'll try another store.
Staff: No problem. The refund will go back to your credit card within three to five days.
Customer: Thank you for your help.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Why is the customer returning the jacket?',
            options: ['Wrong size was sent', 'It\'s damaged', 'Changed their mind', 'Wrong color'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What size did the customer order?',
            options: ['Medium', 'Large', 'Small', 'Extra large'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Ordering the correct size would take five to ____ days.',
            correctText: 'seven',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The store has medium in blue.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the customer decide to do?',
            options: ['Get a refund', 'Exchange for black', 'Wait for the order', 'Keep the large'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-8: Weekend activities
      ListeningExercise(
        id: 'b1_8',
        type: 'B1 - Intermediate',
        title: 'Planning a trip',
        level: 'B1 - Intermediate',
        durationSeconds: 80,
        audioUrl: _placeholderAudio,
        transcript: '''
Anna: I'm thinking of going camping next weekend. Want to join?
Chris: Camping sounds fun! Where are you thinking of going?
Anna: There's a nice campsite about two hours from the city, near a lake. I went there last summer and really enjoyed it.
Chris: Do we need to bring our own tent?
Anna: Yes, unless you want to rent one there. Rentals are about twenty-five dollars per night.
Chris: I might rent since I don't have one. What else should I bring?
Anna: A sleeping bag, warm clothes for the evening, flashlight, and insect repellent. The mosquitoes can be terrible near the lake.
Chris: Good to know. What about food?
Anna: We can either bring our own food and cook on the campfire, or there's a small store at the campsite that sells basic supplies.
Chris: Let's cook on the campfire! That's half the fun of camping.
Anna: Agreed! I'll bring the cooking equipment if you bring the food.
Chris: Deal. How much is the campsite fee?
Anna: It's fifteen dollars per person per night. I was thinking we could stay two nights, Friday and Saturday.
Chris: Perfect. I'll take Friday off so we can leave early and avoid traffic.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where is the campsite located?',
            options: ['Near a lake', 'In the mountains', 'By the beach', 'In a forest'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much is tent rental?',
            options: ['25 dollars per night', '15 dollars per night', '20 dollars per night', 'Free'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The campsite is about ____ hours from the city.',
            correctText: 'two',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'They plan to buy food from the campsite store.',
            correct: false,
            explanation: 'They plan to cook on the campfire.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How many nights will they stay?',
            options: ['Two nights', 'One night', 'Three nights', 'Four nights'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-9: Movie discussion
      ListeningExercise(
        id: 'b1_9',
        type: 'B1 - Intermediate',
        title: 'Talking about films',
        level: 'B1 - Intermediate',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Sophie: Have you seen the new science fiction movie everyone's talking about?
Ryan: You mean "Galaxy Quest"? Yes, I watched it last weekend. It was amazing!
Sophie: Really? What did you like about it?
Ryan: The special effects were incredible, and the storyline kept me guessing until the end. There were so many unexpected twists.
Sophie: I heard it's almost three hours long. Wasn't that too long?
Ryan: Honestly, I didn't notice the time at all. The pacing was perfect. Every scene felt necessary.
Sophie: What about the acting?
Ryan: The lead actress was brilliant. She really made you believe in her character. I wouldn't be surprised if she gets nominated for an award.
Sophie: Now I really want to see it. Should I watch it in the cinema or wait for streaming?
Ryan: Definitely see it in the cinema if you can. The visuals and sound are meant for the big screen. I actually want to watch it again in IMAX.
Sophie: Good advice. Want to go together sometime this week?
Ryan: Sure! How about Wednesday evening?
Sophie: Perfect. I'll book the tickets.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What genre is the movie?',
            options: ['Science fiction', 'Comedy', 'Horror', 'Romance'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How long is the movie?',
            options: ['Almost three hours', 'Two hours', 'One and a half hours', 'Four hours'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Ryan wants to watch it again in ____.',
            correctText: 'IMAX',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Ryan thought the movie was too long.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'When will they watch the movie together?',
            options: ['Wednesday evening', 'This weekend', 'Friday night', 'Next week'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-10: Learning a new skill
      ListeningExercise(
        id: 'b1_10',
        type: 'B1 - Intermediate',
        title: 'Learning to cook',
        level: 'B1 - Intermediate',
        durationSeconds: 75,
        audioUrl: _placeholderAudio,
        transcript: '''
Jenny: I've decided to learn how to cook properly. I'm tired of eating the same boring meals every day.
Mike: That's great! Are you taking a cooking class?
Jenny: I'm doing an online course. It's more flexible since I can watch the videos whenever I have time.
Mike: How's it going so far?
Jenny: Better than I expected! I've already learned to make several dishes I never thought I could. Last week I made pasta from scratch.
Mike: Wow, that sounds impressive. Making fresh pasta is not easy.
Jenny: It took a few tries to get it right. The first batch was too thick and chewy. But the third time was perfect.
Mike: That's the thing about cooking. Practice really does make perfect.
Jenny: Exactly. The instructor always says that mistakes are how you learn. Now I understand what she means.
Mike: What are you planning to learn next?
Jenny: I want to master Asian cuisine. Especially Thai food. I love how the flavors balance sweet, sour, salty, and spicy.
Mike: When you're ready, you should invite me over for dinner!
Jenny: Deal! But give me a few more weeks of practice first.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How is Jenny learning to cook?',
            options: ['Online course', 'Cooking school', 'From her mother', 'YouTube videos'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did Jenny make last week?',
            options: ['Pasta from scratch', 'Pizza', 'Salad', 'Soup'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The first batch of pasta was too thick and ____.',
            correctText: 'chewy',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Jenny got the pasta right on the first try.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What cuisine does Jenny want to learn next?',
            options: ['Thai', 'Italian', 'Mexican', 'French'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-11: Environmental awareness
      ListeningExercise(
        id: 'b1_11',
        type: 'B1 - Intermediate',
        title: 'Reducing plastic use',
        level: 'B1 - Intermediate',
        durationSeconds: 80,
        audioUrl: _placeholderAudio,
        transcript: '''
Host: Today we're talking about simple ways to reduce plastic use in daily life. Our guest is environmental activist Maria Green.
Maria: Thank you for having me. This is such an important topic.
Host: Let's start with the basics. What are the easiest changes people can make?
Maria: The simplest is to carry a reusable water bottle and shopping bags. These two changes alone can eliminate hundreds of single-use plastics per year.
Host: What about other common plastic items?
Maria: Coffee cups are a big one. Most disposable cups are lined with plastic. Bringing your own cup to coffee shops makes a big difference. Many shops even offer discounts for this.
Host: That's a good incentive. What else?
Maria: Pay attention to food packaging. Buy fresh produce instead of pre-packaged items when possible. Choose products in glass or paper over plastic.
Host: Some people say individual actions don't matter because big companies are the main polluters.
Maria: While corporations do need to change, consumer choices influence business decisions. When enough people demand sustainable products, companies listen. It's a gradual process, but every action counts.
Host: Any final advice?
Maria: Don't try to change everything at once. Start with one or two habits, and add more over time. Sustainable living should feel achievable, not overwhelming.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Who is the guest on the show?',
            options: ['An environmental activist', 'A business owner', 'A politician', 'A scientist'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Maria say about reusable bags and bottles?',
            options: ['They can eliminate hundreds of plastics per year', 'They are expensive', 'They are hard to use', 'They don\'t make a difference'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Most disposable coffee cups are lined with ____.',
            correctText: 'plastic',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Maria says individual actions don\'t matter.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is Maria\'s final advice?',
            options: ['Start with one or two habits', 'Change everything at once', 'Don\'t worry about it', 'Only focus on corporations'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-12: Online shopping
      ListeningExercise(
        id: 'b1_12',
        type: 'B1 - Intermediate',
        title: 'E-commerce experience',
        level: 'B1 - Intermediate',
        durationSeconds: 70,
        audioUrl: _placeholderAudio,
        transcript: '''
Sara: I can't believe how much I've been shopping online lately. I used to go to stores for everything.
Dan: Same here. It's so convenient, especially for busy people.
Sara: But sometimes I worry about the quality. You can't touch or try things before buying.
Dan: That's true. I always read reviews carefully before purchasing anything. And I check the return policy.
Sara: Good point. I had a bad experience last month. I ordered shoes that looked great in the pictures but didn't fit at all.
Dan: Did you return them?
Sara: I tried, but the shipping cost was so high it wasn't worth it. I ended up giving them away.
Dan: That's frustrating. I usually only buy from sites that offer free returns.
Sara: I should do that. What's your strategy for clothes shopping online?
Dan: I always check the size chart carefully and read comments about fit. Some brands run small or large.
Sara: True. I've also started saving items to a wishlist and waiting a few days before buying. That way I avoid impulse purchases.
Dan: Smart! How much money has that saved you?
Sara: A lot, actually. Half the time I realize I don't really need it.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What worry does Sara have about online shopping?',
            options: ['Quality of products', 'Delivery speed', 'Website security', 'Payment options'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What happened with Sara\'s shoe order?',
            options: ['They didn\'t fit', 'Wrong color', 'Never arrived', 'Damaged'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Dan only buys from sites with free ____.',
            correctText: 'returns',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Sara returned the shoes successfully.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Sara do to avoid impulse purchases?',
            options: ['Saves items to a wishlist and waits', 'Deletes the app', 'Only shops on weekends', 'Asks friends first'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-13: Cultural differences
      ListeningExercise(
        id: 'b1_13',
        type: 'B1 - Intermediate',
        title: 'Working abroad',
        level: 'B1 - Intermediate',
        durationSeconds: 85,
        audioUrl: _placeholderAudio,
        transcript: '''
Kevin: How's your new job in Germany going?
Linda: It's great, but there have been some cultural adjustments.
Kevin: Like what?
Linda: Well, meetings start exactly on time. If the meeting is at nine, everyone is there at eight fifty-five. Being even two minutes late is considered rude.
Kevin: That's different from here where meetings often start late.
Linda: Exactly! Also, work-life balance is taken very seriously. People rarely check emails after work hours, and taking vacation is expected, not just allowed.
Kevin: That sounds healthy. What about the actual work environment?
Linda: People are very direct. At first, I thought my colleagues were being harsh, but I've learned it's just their communication style. They say exactly what they mean without sugarcoating.
Kevin: Did that take getting used to?
Linda: Definitely. But now I appreciate it. There's no guessing what people really think. And they're equally direct with praise when you do good work.
Kevin: Any other surprises?
Linda: Lunch breaks are sacred. People actually leave their desks and take a proper break. And many offices have a special Friday tradition where everyone gathers for coffee and cake.
Kevin: That sounds nice! Maybe I should look for a job there too.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where is Linda working?',
            options: ['Germany', 'France', 'Japan', 'Australia'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Linda say about meetings?',
            options: ['They start exactly on time', 'They often run late', 'They are very long', 'They are informal'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'German communication style is very ____.',
            correctText: 'direct',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'People in Germany often check emails after work.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the Friday tradition?',
            options: ['Coffee and cake', 'Team sports', 'Movie night', 'Late start'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-14: Public transportation
      ListeningExercise(
        id: 'b1_14',
        type: 'B1 - Intermediate',
        title: 'Commuting options',
        level: 'B1 - Intermediate',
        durationSeconds: 75,
        audioUrl: _placeholderAudio,
        transcript: '''
Nina: I've been thinking about selling my car and using public transportation instead.
Paul: Really? What's making you consider that?
Nina: Mainly the cost. Between car payments, insurance, gas, and parking, I'm spending almost six hundred dollars a month.
Paul: That is a lot. How much would public transport cost?
Nina: A monthly pass is only eighty dollars. Even if I take occasional taxis, I'd still save hundreds.
Paul: What about convenience? Don't you need your car for grocery shopping?
Nina: I thought about that. There's a supermarket within walking distance, and for bigger trips, I could use a grocery delivery service.
Paul: True. What about visiting your parents outside the city?
Nina: They have a car, so they could pick me up. Or I could rent a car for special occasions. It would still be cheaper overall.
Paul: The only downside I see is commute time. Driving to work probably takes less time than the bus.
Nina: Actually, I checked. By car with traffic, it's about forty minutes. By subway, it's thirty-five. Plus, on the subway I can read or answer emails instead of focusing on driving.
Paul: Good point. It sounds like you've really thought this through.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How much does Nina spend on her car monthly?',
            options: ['About 600 dollars', 'About 300 dollars', 'About 80 dollars', 'About 1000 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much is a monthly transit pass?',
            options: ['80 dollars', '100 dollars', '150 dollars', '50 dollars'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'By subway, the commute is ____ minutes.',
            correctText: 'thirty-five',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Driving to work is faster than the subway.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What can Nina do on the subway?',
            options: ['Read or answer emails', 'Sleep', 'Exercise', 'Nothing'],
            correctIndex: 0,
          ),
        ],
      ),

      // B1-15: Social media
      ListeningExercise(
        id: 'b1_15',
        type: 'B1 - Intermediate',
        title: 'Digital detox',
        level: 'B1 - Intermediate',
        durationSeconds: 80,
        audioUrl: _placeholderAudio,
        transcript: '''
Alice: I did something crazy last weekend. I went completely offline for two days.
Ben: No phone at all? How was that?
Alice: Honestly? It was amazing and terrifying at the same time.
Ben: What was the scary part?
Alice: The first few hours were hard. I kept reaching for my phone automatically, even though I'd locked it away. I realized how addicted I was.
Ben: I can relate. I check my phone first thing in the morning without even thinking.
Alice: Exactly. But after the initial discomfort, I felt so much calmer. I read a whole book, had long conversations with my family, and actually slept better.
Ben: Did you miss anything important?
Alice: That was my biggest fear. But when I turned my phone back on Sunday night, there were only a few messages that needed attention. Most things could wait.
Ben: That's interesting. We think we're missing out, but maybe we're not.
Alice: Right. I'm now trying to do a "mini detox" every evening. No screens after eight pm.
Ben: That sounds challenging but worth trying. Does it affect your sleep?
Alice: Definitely. I fall asleep faster and feel more rested in the morning.
Ben: Maybe I should try it too.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How long did Alice go offline?',
            options: ['Two days', 'One week', 'One day', 'One month'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What was the scary part for Alice?',
            options: ['The automatic phone-checking habit', 'Missing important calls', 'Being bored', 'Her phone breaking'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Alice now has no screens after ____ pm.',
            correctText: 'eight',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Alice missed many important messages.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What benefit did Alice notice?',
            options: ['Better sleep', 'More followers', 'More messages', 'More work done'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _levelB2() {
    return [
      // B2-1: Environmental issues
      ListeningExercise(
        id: 'b2_1',
        type: 'B2 - Upper Intermediate',
        title: 'Climate change discussion',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 120,
        audioUrl: _placeholderAudio,
        transcript: '''
Moderator: Welcome to today's discussion on climate change and what individuals can do to help. We have Dr. Sarah Mitchell here, an environmental scientist. Dr. Mitchell, what do you think is the biggest misconception about climate change?

Dr. Mitchell: I think the biggest misconception is that individual actions don't matter because the problem is so large. While it's true that systemic change from governments and corporations is essential, individual choices collectively make a significant impact.

Moderator: Can you give us some examples of impactful individual actions?

Dr. Mitchell: Certainly. Transportation is a major contributor to carbon emissions. If you can, using public transportation, cycling, or even carpooling can reduce your carbon footprint significantly. Another major area is diet. The meat industry, particularly beef production, generates enormous amounts of greenhouse gases. Reducing meat consumption, even by one or two days a week, can make a real difference.

Moderator: What about at home?

Dr. Mitchell: Energy consumption is crucial. Simple things like switching to LED bulbs, properly insulating your home, and being mindful of heating and cooling can reduce energy use by twenty to thirty percent. Also, consider where your energy comes from. If you have the option to choose renewable energy providers, that's a powerful choice.

Moderator: Some people argue that these individual changes are just a distraction from the real solutions.

Dr. Mitchell: I understand that criticism, but I see it differently. When individuals make changes, it influences their communities and creates demand for sustainable products. It also puts pressure on businesses and politicians. Social change often starts from the ground up. Of course, we should also advocate for policy changes, but the two approaches complement each other rather than compete.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'According to Dr. Mitchell, what is the biggest misconception about climate change?',
            options: ['That individual actions don\'t matter', 'That climate change isn\'t real', 'That it\'s only a recent problem', 'That only governments can help'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Which industry does Dr. Mitchell say generates large greenhouse gases?',
            options: ['Meat industry, especially beef', 'Car manufacturing', 'Fashion industry', 'Plastic production'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Simple home changes can reduce energy use by twenty to ____ percent.',
            correctText: 'thirty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Dr. Mitchell believes individual changes distract from real solutions.',
            correct: false,
            explanation: 'She believes individual changes and policy changes complement each other.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Dr. Mitchell say about individual changes and social change?',
            options: ['Social change often starts from the ground up', 'Individuals can\'t influence society', 'Only governments can create change', 'Business changes come first'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-2: Technology and society
      ListeningExercise(
        id: 'b2_2',
        type: 'B2 - Upper Intermediate',
        title: 'The impact of social media',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
Professor: Today we're going to discuss the psychological impact of social media on society, particularly among young people.

Research over the past decade has shown increasingly concerning trends. Studies indicate that heavy social media use is correlated with higher rates of anxiety, depression, and feelings of loneliness, especially among teenagers.

One key factor is social comparison. On social media, people typically share only their best moments, creating an unrealistic representation of life. When users constantly compare themselves to these curated highlights, they often feel inadequate or unsatisfied with their own lives.

Another issue is the design of these platforms. They're engineered to be addictive. Features like infinite scrolling, push notifications, and variable rewards through likes and comments trigger dopamine responses in the brain, similar to slot machines.

However, it would be oversimplistic to say social media is entirely negative. It has genuinely connected people across distances, given marginalized communities a voice, and enabled important social movements. Many people have found support groups and communities online that they couldn't access in their physical environment.

The key seems to be intentional use. Research suggests that passive consumption, simply scrolling and watching, tends to negatively affect well-being, while active engagement, like meaningful conversations and creating content, can be positive.

So what's the takeaway? Rather than advocating for complete abandonment of social media, perhaps we should focus on digital literacy, teaching people, especially young people, to use these tools mindfully and critically.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does heavy social media use correlate with according to studies?',
            options: ['Anxiety, depression, and loneliness', 'Better grades', 'Improved social skills', 'Physical fitness'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is one reason social media causes negative feelings?',
            options: ['Social comparison to curated highlights', 'Too many friends', 'Expensive devices', 'Slow internet connection'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Social media platforms trigger ____ responses in the brain.',
            correctText: 'dopamine',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The professor says passive scrolling is better for well-being than active engagement.',
            correct: false,
            explanation: 'Passive consumption negatively affects well-being, while active engagement can be positive.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What solution does the professor suggest?',
            options: ['Teaching digital literacy for mindful use', 'Banning all social media', 'Using social media more', 'Ignoring the problem'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-3: Economic discussion
      ListeningExercise(
        id: 'b2_3',
        type: 'B2 - Upper Intermediate',
        title: 'The gig economy',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
The rise of the gig economy has fundamentally changed how many people work. Instead of traditional employment with fixed hours and benefits, millions now work as independent contractors, taking on short-term jobs through platforms like Uber, Deliveroo, or Fiverr.

Proponents argue this model offers unprecedented flexibility. Workers can choose when, where, and how much they work. For parents, students, or those with other commitments, this autonomy can be invaluable. It also lowers barriers to entry, allowing people to earn money without formal qualifications.

However, critics point to significant drawbacks. Gig workers typically lack employment protections such as minimum wage guarantees, paid leave, health insurance, and retirement benefits. The unpredictability of income can make financial planning extremely difficult.

There's also the question of who benefits most from this arrangement. While companies save substantially on labor costs, many workers find themselves in a precarious position, bearing all the risks of business fluctuations without the security of traditional employment.

Some countries are beginning to address these concerns through legislation. In some regions, gig workers are now entitled to minimum wage and holiday pay. The challenge lies in balancing flexibility with adequate protection, without undermining the viability of the platforms themselves.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What do proponents say is the main benefit of gig work?',
            options: ['Flexibility', 'High income', 'Job security', 'Health benefits'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do gig workers typically lack?',
            options: ['Employment protections', 'Work opportunities', 'Internet access', 'Freedom'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Companies save substantially on labor ____ through gig work.',
            correctText: 'costs',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'All countries have addressed gig worker protections.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the challenge for legislators?',
            options: ['Balancing flexibility with protection', 'Banning gig work', 'Increasing company profits', 'Reducing worker numbers'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-4: Education trends
      ListeningExercise(
        id: 'b2_4',
        type: 'B2 - Upper Intermediate',
        title: 'The future of education',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
The pandemic accelerated a transformation in education that had been slowly developing for years. Remote learning, once a niche option, became mainstream almost overnight. Now, as we look toward the future, the question isn't whether technology will play a role in education, but how significant that role will be.

Many experts predict a hybrid model will become standard. Students might attend campus for practical work, discussions, and social activities while completing lectures and individual study online at their own pace. This could potentially make education more accessible to those who work or have family responsibilities.

Artificial intelligence is already beginning to personalize learning. Adaptive learning platforms can identify where students struggle and provide targeted practice. Some predict AI tutors could eventually supplement or even replace some traditional teaching roles.

However, concerns remain about the digital divide. Students without reliable internet access or suitable devices are at a significant disadvantage. There are also questions about the social aspects of education. Schools and universities don't just transmit knowledge; they help develop interpersonal skills, build networks, and foster a sense of community.

The most likely scenario is that technology will enhance rather than replace traditional education. The challenge for educators is to harness these tools effectively while preserving the irreplaceable human elements of teaching and learning.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What accelerated the transformation in education?',
            options: ['The pandemic', 'New technology', 'Government policies', 'Economic growth'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What model do experts predict will become standard?',
            options: ['Hybrid model', 'Fully online', 'Traditional only', 'AI-only'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'AI can provide ____ learning by identifying where students struggle.',
            correctText: 'personalized',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker thinks technology will completely replace traditional education.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the "digital divide" concern about?',
            options: ['Students without internet access', 'Too much technology', 'Expensive teachers', 'Old buildings'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-5: Health and science
      ListeningExercise(
        id: 'b2_5',
        type: 'B2 - Upper Intermediate',
        title: 'Sleep science',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
Sleep research has revealed that getting adequate rest is far more important than previously understood. While we've long known sleep deprivation affects mood and concentration, recent studies show it impacts nearly every system in the body.

During sleep, the brain undergoes a crucial cleansing process. The glymphatic system removes toxic waste products that accumulate during waking hours, including proteins associated with Alzheimer's disease. This process is most active during deep sleep, which is why sleep quality matters as much as quantity.

Sleep also plays a vital role in memory consolidation. Information learned during the day is processed and stored during specific sleep stages. This explains why pulling an all-nighter before an exam is counterproductive; you may study more, but you'll retain less.

The recommended amount of sleep for adults is seven to nine hours per night. However, surveys suggest most people consistently get less than this. Modern factors like artificial light, screen use, and irregular schedules have disrupted our natural sleep patterns.

Improving sleep doesn't require dramatic lifestyle changes. Maintaining a consistent sleep schedule, limiting caffeine after noon, and creating a dark, cool sleeping environment can significantly improve sleep quality. Regular physical activity helps, though it's best avoided close to bedtime.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does the glymphatic system do during sleep?',
            options: ['Removes toxic waste from the brain', 'Digests food', 'Builds muscles', 'Repairs skin'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'When is the brain cleansing process most active?',
            options: ['During deep sleep', 'When falling asleep', 'When waking up', 'During dreams'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Adults should get seven to ____ hours of sleep.',
            correctText: 'nine',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Studying all night before an exam helps you remember more.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is NOT recommended for better sleep?',
            options: ['Exercising close to bedtime', 'Consistent sleep schedule', 'Dark sleeping environment', 'Limiting caffeine'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-6: Urban development
      ListeningExercise(
        id: 'b2_6',
        type: 'B2 - Upper Intermediate',
        title: 'Smart cities',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 95,
        audioUrl: _placeholderAudio,
        transcript: '''
Cities around the world are racing to become "smart," using technology to improve urban life. Smart city initiatives range from simple traffic management systems to comprehensive networks of sensors monitoring everything from air quality to parking availability.

In Singapore, one of the world's leading smart cities, an extensive sensor network manages traffic flow in real time, reducing congestion by up to twenty percent. Street lighting adjusts automatically based on pedestrian presence, saving energy while maintaining safety.

Barcelona has implemented smart water management, using sensors to detect leaks and optimize irrigation in parks. The city claims to have saved millions of euros in water costs. Smart waste bins signal when they need emptying, making garbage collection more efficient.

However, smart cities raise significant privacy concerns. The same sensors that improve services also collect vast amounts of data about citizens' movements and behaviors. Without proper safeguards, this information could be misused.

There's also the risk of creating a two-tier city where smart services benefit those with smartphones and digital literacy while leaving others behind. Successful smart city implementation requires not just technology but also inclusive policies that ensure benefits are shared equitably.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How much has Singapore reduced congestion?',
            options: ['Up to 20 percent', 'Up to 50 percent', 'Up to 10 percent', 'Up to 5 percent'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Barcelona use smart sensors for?',
            options: ['Water management', 'Crime prevention', 'Weather forecasting', 'Education'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Smart waste bins signal when they need ____.',
            correctText: 'emptying',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Smart cities have no privacy concerns.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What risk is mentioned about smart cities?',
            options: ['Creating a two-tier city', 'Too expensive', 'Too complicated', 'Causing unemployment'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-7: Globalization
      ListeningExercise(
        id: 'b2_7',
        type: 'B2 - Upper Intermediate',
        title: 'Global supply chains',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 105,
        audioUrl: _placeholderAudio,
        transcript: '''
The interconnectedness of global supply chains became starkly apparent during recent disruptions. A semiconductor shortage affected everything from car production to gaming consoles. A single cargo ship blocking a canal created delays felt around the world.

Modern manufacturing relies on components from numerous countries. A typical smartphone might include chips from Taiwan, screens from South Korea, rare earth minerals from China, and final assembly in Vietnam. This specialization has driven down costs and increased efficiency.

However, the pandemic and geopolitical tensions have exposed the vulnerabilities of this model. Many companies are now reconsidering their supply chain strategies. Some are pursuing "near-shoring," moving production closer to their main markets. Others are diversifying suppliers to reduce dependence on any single country.

There's growing interest in "friend-shoring," concentrating supply chains among allied nations considered politically reliable. This represents a shift from pure economic efficiency toward a balance of efficiency and security.

The consequences for consumers are mixed. More resilient supply chains may mean fewer shortages, but they could also lead to higher prices as companies sacrifice some efficiencies. The era of ever-cheaper goods may be coming to an end.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What recent event showed supply chain vulnerabilities?',
            options: ['Semiconductor shortage', 'Oil price drop', 'Currency crisis', 'Trade agreement'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is "near-shoring"?',
            options: ['Moving production closer to main markets', 'Building more ships', 'Hiring local workers', 'Buying local materials only'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'A typical smartphone includes chips from ____.',
            correctText: 'Taiwan',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Companies are not changing their supply chain strategies.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What might be the consequence for consumers?',
            options: ['Higher prices', 'More shortages', 'Better quality', 'Faster delivery'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-8: Media and journalism
      ListeningExercise(
        id: 'b2_8',
        type: 'B2 - Upper Intermediate',
        title: 'The future of news',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
Traditional journalism faces an existential crisis. Advertising revenue has migrated to digital platforms, particularly Google and Facebook, leaving news organizations struggling to fund quality journalism.

Some publications have turned to subscription models with mixed results. Successful outlets like The New York Times have built substantial digital subscriber bases. However, critics worry this creates an information divide where quality journalism becomes a privilege for those who can afford to pay.

Meanwhile, misinformation spreads freely on social media, where sensational falsehoods often outperform carefully researched facts in terms of engagement. Algorithms designed to maximize user attention inadvertently promote divisive and misleading content.

Various solutions are being explored. Some advocate for tech giants to pay publishers for content that appears on their platforms, as has been mandated in Australia. Others suggest public funding for journalism, similar to how public broadcasting is supported.

Non-profit journalism is another emerging model. Organizations funded by foundations or donations can pursue public interest stories without commercial pressure. However, this model has limited scalability.

Whatever the solution, the health of democracy depends on a well-informed citizenry. Finding sustainable ways to support quality journalism remains one of the crucial challenges of our digital age.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where has advertising revenue migrated to?',
            options: ['Digital platforms like Google and Facebook', 'Television', 'Print magazines', 'Radio'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What concern exists about subscription models?',
            options: ['Creating an information divide', 'Too much news', 'Poor quality content', 'Too many ads'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ mandated tech giants to pay publishers.',
            correctText: 'Australia',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Algorithms always promote accurate information.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does democracy depend on?',
            options: ['A well-informed citizenry', 'More technology', 'More advertising', 'Faster news'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-9: Psychology
      ListeningExercise(
        id: 'b2_9',
        type: 'B2 - Upper Intermediate',
        title: 'Decision making',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 95,
        audioUrl: _placeholderAudio,
        transcript: '''
Decades of research in behavioral economics have revealed that humans are far from rational decision-makers. Our choices are influenced by numerous cognitive biases that operate largely below conscious awareness.

One common bias is anchoring. When making decisions, we tend to rely heavily on the first piece of information we receive. Real estate agents know this well; showing an overpriced house first makes subsequent properties seem more reasonable.

Loss aversion is another powerful bias. People feel the pain of losing something about twice as strongly as the pleasure of gaining something equivalent. This explains why we often hold onto losing investments too long, hoping to avoid the pain of realizing a loss.

The availability heuristic leads us to overestimate the probability of events we can easily recall. After seeing news about plane crashes, people often overestimate the danger of flying, even though statistically it's far safer than driving.

Confirmation bias makes us seek out information that confirms our existing beliefs while discounting contradictory evidence. In the age of personalized news feeds, this tendency has become particularly problematic.

Awareness of these biases doesn't eliminate them, but it can help. Techniques like considering the opposite viewpoint, using checklists, and taking time before important decisions can partially counteract our natural tendencies toward irrational choices.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is anchoring bias?',
            options: ['Relying heavily on the first information received', 'Fear of water', 'Preferring old things', 'Following the crowd'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much stronger is the pain of loss compared to gain?',
            options: ['About twice as strong', 'About equal', 'About five times stronger', 'Slightly stronger'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Confirmation bias makes us seek information that ____ our beliefs.',
            correctText: 'confirms',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Statistically, flying is more dangerous than driving.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What can help counteract biases?',
            options: ['Considering the opposite viewpoint', 'Making quick decisions', 'Following instincts', 'Ignoring evidence'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-10: Sustainability
      ListeningExercise(
        id: 'b2_10',
        type: 'B2 - Upper Intermediate',
        title: 'Circular economy',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
The concept of a circular economy challenges the traditional "take, make, dispose" model of production. Instead of extracting resources, manufacturing products, and eventually throwing them away, a circular economy aims to keep materials in use for as long as possible.

Design plays a crucial role in this model. Products are created with their entire lifecycle in mind, using materials that can be easily recycled or composted. Modular designs allow individual components to be repaired or replaced rather than discarding the entire product.

Some companies are experimenting with product-as-a-service models. Instead of selling you a washing machine, a company might lease it to you and remain responsible for maintenance, repairs, and eventual recycling. This aligns the manufacturer's incentives with durability and recyclability.

Extended producer responsibility is another approach, where manufacturers are legally required to take back and recycle their products. This has been successfully applied to electronics in the European Union.

Critics argue that circular economy concepts, while appealing, face significant practical challenges. Recycling processes often degrade material quality, and consumer behavior changes slowly. However, with resource scarcity and waste management becoming critical global issues, finding ways to close the material loop is increasingly urgent.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does a circular economy challenge?',
            options: ['Take, make, dispose model', 'International trade', 'Government spending', 'Education system'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What design approach is important in circular economy?',
            options: ['Modular designs that can be repaired', 'Making products cheaper', 'Using more materials', 'Faster production'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'In product-as-a-service, companies ____ products instead of selling them.',
            correctText: 'lease',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Recycling always maintains material quality.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What has the EU applied extended producer responsibility to?',
            options: ['Electronics', 'Food', 'Clothing', 'Furniture'],
            correctIndex: 0,
          ),
        ],
      ),

      // B2-11 to B2-15 (shorter versions to save space)
      ListeningExercise(
        id: 'b2_11',
        type: 'B2 - Upper Intermediate',
        title: 'Remote work revolution',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 90,
        audioUrl: _placeholderAudio,
        transcript: '''
The shift to remote work during the pandemic transformed workplace expectations permanently. Many employees discovered they could be equally or more productive working from home, without the time and stress of commuting.

Companies have responded differently. Some have embraced fully remote operations, even closing physical offices. Others have implemented hybrid models where employees come in a few days per week. A minority insist on returning to full-time office presence.

Studies show mixed results on productivity. Creative collaboration often benefits from in-person interaction, while focused individual work may be more efficient at home. The challenge for managers is designing work arrangements that optimize for different types of tasks.

Remote work has also geographical implications. Workers can now live in lower-cost areas while earning salaries competitive with major cities. This has led to price increases in previously affordable regions as remote workers relocate.

Mental health considerations are significant. Some employees thrive with the autonomy and flexibility, while others struggle with isolation and boundary setting between work and personal life. Successful remote work requires both individual skills and organizational support structures.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What discovery did many employees make?',
            options: ['They could be equally productive at home', 'Offices are essential', 'Commuting is healthy', 'Meetings are unnecessary'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Remote workers can live in lower-____ areas.',
            correctText: 'cost',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'All studies show remote work increases productivity.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do some employees struggle with in remote work?',
            options: ['Isolation and boundary setting', 'Too much collaboration', 'Commuting', 'Office politics'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What type of work benefits from in-person interaction?',
            options: ['Creative collaboration', 'Focused individual work', 'Data entry', 'Reading reports'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'b2_12',
        type: 'B2 - Upper Intermediate',
        title: 'Food sustainability',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 85,
        audioUrl: _placeholderAudio,
        transcript: '''
Our food system is responsible for roughly one-quarter of global greenhouse gas emissions. From deforestation for farming to methane from livestock to the energy used in processing and transportation, the environmental impact is substantial.

Plant-based alternatives are gaining mainstream acceptance. Beyond Meat and Impossible Foods have created products that closely mimic traditional meat in taste and texture. Sales have grown rapidly, though they still represent a small fraction of the meat market.

Lab-grown meat, also called cultured meat, takes a different approach. Real animal cells are grown in bioreactors, producing meat without raising and slaughtering animals. While still expensive, costs are dropping rapidly. Singapore became the first country to approve lab-grown meat for sale.

Reducing food waste is equally important. Approximately one-third of food produced globally is wasted. Simple measures like better inventory management, accepting imperfect produce, and composting can make significant differences.

Individual choices matter but systemic change is essential. Government policies on farming subsidies, food labeling, and carbon pricing could accelerate the transition to more sustainable food systems.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How much of greenhouse gases come from food systems?',
            options: ['About one-quarter', 'About half', 'About ten percent', 'Almost all'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ was the first country to approve lab-grown meat.',
            correctText: 'Singapore',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Lab-grown meat uses animal cells.',
            correct: true,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How much food is wasted globally?',
            options: ['About one-third', 'About half', 'About ten percent', 'Very little'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What can help reduce food waste?',
            options: ['Better inventory management', 'Producing more food', 'Using more packaging', 'Importing more'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'b2_13',
        type: 'B2 - Upper Intermediate',
        title: 'Mental health awareness',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 90,
        audioUrl: _placeholderAudio,
        transcript: '''
Attitudes toward mental health have shifted dramatically in recent years. What was once stigmatized and hidden is now openly discussed by celebrities, athletes, and everyday people. This increased awareness has encouraged more people to seek help.

However, mental health services in many countries struggle to meet demand. Wait times for therapy can stretch to months. The shortage of trained professionals means many people, particularly in rural areas, have limited access to care.

Digital mental health solutions are emerging to fill some gaps. Therapy apps offer cognitive behavioral techniques that users can practice independently. Online therapy platforms connect people with counselors via video chat, increasing accessibility. AI chatbots provide basic support and can escalate serious cases to human professionals.

Workplace mental health has gained attention. Companies are recognizing that employee wellbeing affects productivity and retention. Some now offer mental health days, counseling services, and training for managers to recognize warning signs.

Despite progress, challenges remain. Mental health funding lags behind physical health. Cultural barriers persist in some communities. And there's ongoing debate about the medicalization of normal human emotions and the overuse of psychiatric diagnoses.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'How have attitudes toward mental health changed?',
            options: ['More openly discussed', 'More hidden', 'Less important', 'No change'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Wait times for therapy can stretch to ____.',
            correctText: 'months',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Mental health services easily meet demand.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do some companies now offer?',
            options: ['Mental health days and counseling', 'Longer hours', 'More work', 'Pay cuts'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is one ongoing challenge?',
            options: ['Mental health funding lags behind physical health', 'Too much funding', 'Too many professionals', 'No demand'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'b2_14',
        type: 'B2 - Upper Intermediate',
        title: 'Space exploration',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 95,
        audioUrl: _placeholderAudio,
        transcript: '''
A new era of space exploration is underway, driven not just by government agencies but by private companies. SpaceX has dramatically reduced launch costs through reusable rockets, making space more accessible. Blue Origin and other companies are developing space tourism.

The Moon is once again a focus of attention. NASA's Artemis program aims to return humans to the lunar surface and eventually establish a permanent presence. China has ambitious lunar plans as well, including potential resource extraction.

Mars remains the ultimate goal for many space advocates. SpaceX's Starship is designed with Mars colonization in mind. However, the challenges are immense: radiation exposure, psychological effects of isolation, and the sheer distance make any Mars mission extremely complex.

Beyond exploration, space technology has practical applications. Satellite networks provide global communications and precise positioning. Earth observation satellites monitor climate change, track deforestation, and aid disaster response.

Space debris is a growing concern. Thousands of defunct satellites and fragments orbit Earth, threatening active spacecraft. Without intervention, some orbital regions could become unusable. International cooperation on debris mitigation is increasingly urgent.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What has SpaceX reduced through reusable rockets?',
            options: ['Launch costs', 'Satellite size', 'Travel time', 'Fuel consumption'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'NASA\'s ____ program aims to return humans to the Moon.',
            correctText: 'Artemis',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Mars missions face no significant challenges.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do Earth observation satellites help monitor?',
            options: ['Climate change', 'Television signals', 'Phone calls', 'Radio stations'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is space debris threatening?',
            options: ['Active spacecraft', 'Earth\'s atmosphere', 'The Moon', 'Mars'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'b2_15',
        type: 'B2 - Upper Intermediate',
        title: 'Digital privacy',
        level: 'B2 - Upper Intermediate',
        durationSeconds: 90,
        audioUrl: _placeholderAudio,
        transcript: '''
In the digital age, personal data has become incredibly valuable. Tech companies build detailed profiles of users based on their online behavior, using this information for targeted advertising and service personalization.

The European Union's General Data Protection Regulation, known as GDPR, established strong privacy protections. It gives individuals rights over their data, including the right to know what's collected, to request deletion, and to data portability. Companies face significant fines for violations.

Other regions have followed with their own regulations, though approaches vary. California's privacy law gives consumers similar rights. China has implemented strict data localization requirements. This patchwork creates challenges for global companies operating across jurisdictions.

Consumers express concern about privacy but often trade it for convenience. Few people read terms of service. Many accept cookies without consideration. And the benefits of personalization can be genuinely useful.

Emerging technologies raise new questions. Facial recognition enables surveillance at unprecedented scale. Voice assistants create recordings of home conversations. The Internet of Things means even refrigerators and lightbulbs collect data. Balancing innovation with privacy protection remains an evolving challenge.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What do tech companies use personal data for?',
            options: ['Targeted advertising', 'Security only', 'Research only', 'Nothing'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'GDPR stands for General Data Protection ____.',
            correctText: 'Regulation',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Most people carefully read terms of service.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What emerging technology enables surveillance at scale?',
            options: ['Facial recognition', 'Email', 'Telephones', 'Television'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What right does GDPR give individuals?',
            options: ['Right to request data deletion', 'Right to free products', 'Right to unlimited data', 'Right to hack companies'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _levelC1() {
    return [
      // C1-1: Business lecture
      ListeningExercise(
        id: 'c1_1',
        type: 'C1 - Advanced',
        title: 'Innovation in business',
        level: 'C1 - Advanced',
        durationSeconds: 150,
        audioUrl: _placeholderAudio,
        transcript: '''
Today I want to discuss why some companies consistently innovate while others stagnate, even in competitive markets.

The traditional view held that innovation was primarily a function of research and development budgets. Throw enough money at smart people, and breakthroughs would follow. However, decades of evidence have thoroughly debunked this simplistic notion. Some of the most innovative companies spend relatively modest amounts on R and D, while some of the biggest spenders have remarkably poor innovation track records.

What distinguishes consistently innovative organizations is their culture. And by culture, I don't mean ping pong tables and free snacks. I mean the underlying assumptions, values, and practices that shape how decisions are made and how people interact.

Three cultural elements stand out. First is psychological safety, the belief that one can speak up, question assumptions, and even fail without fear of punishment. Google's extensive research into team effectiveness found this to be the single most important factor in high-performing teams.

Second is cross-functional collaboration. Innovation rarely happens in silos. When engineers talk to marketers, when designers interact with manufacturing, unexpected connections emerge. Companies that create structures and incentives for this kind of interaction consistently outperform those that don't.

Third is tolerance for ambiguity and experimentation. Innovative companies understand that not every initiative will succeed. They embrace a portfolio approach, launching multiple experiments knowing that many will fail, but the winners will more than compensate. This requires leadership that can articulate a clear vision while remaining flexible about the path to get there.

Finally, I want to emphasize that culture isn't something you can simply declare or implement overnight. It's built through countless daily interactions, decisions, and particularly, through what leaders model and reward.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'According to the speaker, what has been debunked about innovation?',
            options: ['That it\'s primarily about R&D budgets', 'That culture matters', 'That people are important', 'That competition drives innovation'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did Google\'s research find to be most important for team effectiveness?',
            options: ['Psychological safety', 'High salaries', 'Technical skills', 'Long working hours'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Innovation rarely happens in ____.',
            correctText: 'silos',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker says innovative companies expect all initiatives to succeed.',
            correct: false,
            explanation: 'They understand many experiments will fail.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'How is culture built according to the speaker?',
            options: ['Through daily interactions and what leaders model', 'By writing policies', 'By increasing salaries', 'By hiring consultants'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does "tolerance for ambiguity" mean in this context?',
            options: ['Accepting uncertainty and experimentation', 'Being unclear about goals', 'Having no standards', 'Avoiding decisions'],
            correctIndex: 0,
          ),
        ],
      ),

      // C1-2: Economic analysis
      ListeningExercise(
        id: 'c1_2',
        type: 'C1 - Advanced',
        title: 'Monetary policy explained',
        level: 'C1 - Advanced',
        durationSeconds: 130,
        audioUrl: _placeholderAudio,
        transcript: '''
Central banks wield enormous influence over economies through monetary policy. Understanding how these institutions operate is essential for anyone interested in finance or economics.

The primary tool is interest rate manipulation. When the central bank lowers rates, borrowing becomes cheaper, theoretically stimulating spending and investment. Conversely, raising rates makes borrowing more expensive, cooling an overheating economy.

Quantitative easing represents a more unconventional approach, employed when interest rates approach zero. The central bank purchases government bonds and other securities, injecting money into the financial system and pushing investors toward riskier assets.

The relationship between monetary policy and inflation is complex. Traditional theory holds that increasing money supply leads to inflation. However, the massive monetary expansion following the 2008 financial crisis didn't produce predicted inflation, leading economists to reconsider their models.

Central bank independence is considered crucial. Politicians facing elections might prefer short-term growth over long-term stability. Independent central banks can make unpopular but necessary decisions without political interference.

Critics argue central banks have become too powerful, making decisions that significantly affect wealth distribution without democratic accountability. The debate over appropriate monetary policy continues to evolve.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is the primary tool of central banks?',
            options: ['Interest rate manipulation', 'Tax collection', 'Currency printing', 'Stock trading'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is quantitative easing?',
            options: ['Purchasing bonds to inject money', 'Raising taxes', 'Cutting spending', 'Printing physical currency'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Central bank ____ is considered crucial for making unpopular decisions.',
            correctText: 'independence',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Monetary expansion after 2008 caused high inflation as predicted.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do critics argue about central banks?',
            options: ['They have become too powerful without accountability', 'They are too weak', 'They should be abolished', 'They are perfect'],
            correctIndex: 0,
          ),
        ],
      ),

      // C1-3: Scientific lecture
      ListeningExercise(
        id: 'c1_3',
        type: 'C1 - Advanced',
        title: 'Neuroplasticity and learning',
        level: 'C1 - Advanced',
        durationSeconds: 120,
        audioUrl: _placeholderAudio,
        transcript: '''
The concept of neuroplasticity has revolutionized our understanding of the brain. Contrary to earlier beliefs that adult brains were essentially fixed, we now know that neural connections can be formed and strengthened throughout life.

When we learn something new, neurons that fire together wire together, as the famous saying goes. Repeated practice strengthens synaptic connections, making information retrieval increasingly automatic. This explains why skills that initially require conscious effort eventually become second nature.

The implications for education are profound. Learning is not merely information transfer but actual physical restructuring of the brain. This reframes challenges as opportunities for growth rather than evidence of fixed limitations.

Sleep plays a crucial role in consolidation. During sleep, the brain replays and strengthens newly formed neural pathways while pruning unnecessary connections. This explains why cramming is less effective than distributed practice followed by adequate rest.

Interestingly, learning physical skills and abstract concepts engage overlapping neural mechanisms. Mental practice can partially substitute for physical practice, which has implications for rehabilitation and skill development.

However, neuroplasticity has limits. While the brain remains adaptable, some changes require more effort with age. Critical periods exist where certain types of learning occur most easily. Understanding these nuances helps optimize learning strategies.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does "neurons that fire together wire together" mean?',
            options: ['Repeated practice strengthens connections', 'Neurons are electrical', 'Brain cells are fixed', 'Learning is impossible'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What role does sleep play in learning?',
            options: ['Consolidates and strengthens neural pathways', 'Erases memories', 'Has no effect', 'Only affects dreaming'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Mental practice can partially ____ for physical practice.',
            correctText: 'substitute',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The adult brain cannot form new neural connections.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What are critical periods?',
            options: ['Times when certain learning occurs most easily', 'Dangerous times', 'Test periods', 'Sleep stages'],
            correctIndex: 0,
          ),
        ],
      ),

      // C1-4 through C1-15 (shorter versions)
      ListeningExercise(
        id: 'c1_4',
        type: 'C1 - Advanced',
        title: 'Legal systems compared',
        level: 'C1 - Advanced',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
Legal systems worldwide fall broadly into two categories: common law and civil law traditions. Understanding these distinctions illuminates how different societies approach justice.

Common law, originating in England, relies heavily on precedent. Judges don't merely apply statutes; their decisions become binding authority for future cases. This creates a dynamic, evolving body of law shaped by countless individual rulings.

Civil law systems, predominant in continental Europe and many other regions, place primary emphasis on comprehensive legal codes. Judges interpret and apply these codes, with past decisions serving as guidance but not binding authority.

Each system has advantages. Common law is flexible, adapting to novel situations through judicial reasoning. Civil law offers greater predictability and systematic organization of legal principles.

In practice, many jurisdictions blend elements of both traditions. International commercial law often follows civil law models, while contract interpretation may incorporate common law principles.

The rise of international trade and digital commerce creates pressure for harmonization. Legal systems that evolved for domestic needs must now address cross-border transactions and global platforms.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does common law rely heavily on?',
            options: ['Precedent', 'Codes', 'International treaties', 'Religious texts'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Civil law systems emphasize comprehensive legal ____.',
            correctText: 'codes',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'In civil law, past decisions are binding authority.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What creates pressure for legal harmonization?',
            options: ['International trade and digital commerce', 'Local customs', 'Historical traditions', 'Weather patterns'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Where did common law originate?',
            options: ['England', 'France', 'Germany', 'Rome'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_5',
        type: 'C1 - Advanced',
        title: 'Geopolitics of energy',
        level: 'C1 - Advanced',
        durationSeconds: 115,
        audioUrl: _placeholderAudio,
        transcript: '''
Energy security has driven international relations for over a century. Control of oil and gas resources has sparked conflicts, shaped alliances, and determined the fates of nations.

The transition to renewable energy promises to reshape this landscape fundamentally. Countries currently dependent on fossil fuel imports could achieve energy independence. Traditional petrostates face the prospect of declining relevance as demand for their primary export diminishes.

However, this transition creates new dependencies. Solar panels require rare earth minerals predominantly mined in China. Battery production depends on lithium from a handful of countries. The shift from oil dependency to mineral dependency carries its own geopolitical implications.

Nuclear energy remains controversial. It offers carbon-free baseload power but raises concerns about proliferation, waste storage, and accident risk. Different countries have made dramatically different choices regarding nuclear development.

Energy infrastructure itself has become a strategic asset. Pipelines, shipping lanes, and power grids represent vulnerabilities as well as opportunities. Cyberattacks on energy systems pose growing security concerns.

The pace and nature of energy transition will significantly influence global power dynamics in coming decades.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What has energy security driven for over a century?',
            options: ['International relations', 'Sports competitions', 'Cultural exchange', 'Tourism'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Rare earth minerals are predominantly mined in ____.',
            correctText: 'China',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Renewable energy eliminates all geopolitical dependencies.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What concern does nuclear energy raise?',
            options: ['Proliferation and waste storage', 'Too much energy', 'Low cost', 'Easy construction'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What poses growing security concerns for energy?',
            options: ['Cyberattacks on energy systems', 'Solar power', 'Wind turbines', 'Hydroelectric dams'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_6',
        type: 'C1 - Advanced',
        title: 'Philosophy of science',
        level: 'C1 - Advanced',
        durationSeconds: 120,
        audioUrl: _placeholderAudio,
        transcript: '''
What distinguishes science from other forms of knowledge? This seemingly simple question has generated centuries of philosophical debate without definitive resolution.

Karl Popper proposed falsifiability as the criterion. Genuine scientific theories make predictions that could potentially be proven wrong. Theories that explain everything, predict nothing, and cannot be tested don't qualify as science.

Thomas Kuhn challenged this view with his concept of paradigm shifts. He argued that science doesn't progress through continuous accumulation of knowledge but through revolutionary changes in fundamental assumptions. Scientists working within a paradigm often resist contradictory evidence until anomalies accumulate beyond ignoring.

The scientific method itself is more varied than textbook descriptions suggest. While controlled experiments represent an ideal, many fields like astronomy or paleontology rely primarily on observation. Historical sciences construct explanations for unique past events rather than testing repeatable predictions.

The role of values in science remains contentious. While scientists aspire to objectivity, the choice of what questions to investigate, how to interpret results, and what applications to pursue inevitably involves value judgments.

Understanding science as a human endeavor, with all its complexity and limitations, ultimately strengthens rather than undermines its authority.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did Karl Popper propose as the criterion for science?',
            options: ['Falsifiability', 'Mathematical proof', 'Consensus', 'Repeatability only'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Thomas Kuhn introduced the concept of paradigm ____.',
            correctText: 'shifts',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'According to Kuhn, science progresses continuously.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do historical sciences primarily rely on?',
            options: ['Observation and explanation of past events', 'Controlled experiments', 'Mathematical models only', 'Predictions'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What remains contentious about science?',
            options: ['The role of values', 'Basic math', 'Weather prediction', 'Computer use'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_7',
        type: 'C1 - Advanced',
        title: 'Urban planning challenges',
        level: 'C1 - Advanced',
        durationSeconds: 105,
        audioUrl: _placeholderAudio,
        transcript: '''
Cities face a paradox: they are simultaneously sources of innovation and inequality, efficiency and pollution, opportunity and exclusion.

Housing affordability has reached crisis levels in many successful cities. High-paying jobs attract workers, driving up housing costs and displacing lower-income residents. Exclusionary zoning that limits density compounds the problem, restricting supply while demand rises.

Transportation planning shapes urban form profoundly. Cities built around automobiles sprawl outward, creating long commutes and car dependency. Transit-oriented development concentrates housing and employment near public transportation, enabling car-free lifestyles.

Climate adaptation presents urgent challenges. Coastal cities face rising sea levels and increasing storm intensity. Extreme heat disproportionately affects urban areas due to the heat island effect. Infrastructure designed for historical climate conditions may prove inadequate.

Gentrification illustrates the complexity of urban change. Neighborhood improvement brings investment and services but often displaces longtime residents. Balancing revitalization with community preservation requires careful policy design.

Ultimately, cities reflect the societies that create them. Technical solutions alone cannot resolve fundamentally political questions about who cities are for and how benefits and burdens should be distributed.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What has reached crisis levels in many cities?',
            options: ['Housing affordability', 'Crime', 'Unemployment', 'Traffic'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Transit-oriented development enables car-____ lifestyles.',
            correctText: 'free',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Exclusionary zoning helps increase housing supply.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the heat island effect cause?',
            options: ['Extreme heat in urban areas', 'Cooling cities', 'More rain', 'Earthquakes'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What often happens with gentrification?',
            options: ['Longtime residents are displaced', 'Property values decrease', 'Crime increases', 'Population drops'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_8',
        type: 'C1 - Advanced',
        title: 'Media literacy',
        level: 'C1 - Advanced',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
In an era of information abundance, the ability to critically evaluate media has become essential. Media literacy encompasses skills beyond simply reading or watching; it involves understanding how messages are constructed and for what purposes.

Source evaluation forms the foundation. Who created this content? What is their expertise and potential bias? Is the information verifiable through independent sources? These questions apply whether encountering news articles, social media posts, or academic papers.

Understanding media economics illuminates incentives. Advertising-supported media optimizes for engagement, which often favors sensationalism over accuracy. Subscription models create different pressures. Platform algorithms amplify certain content regardless of veracity.

Visual media presents particular challenges. Images and videos can be manipulated, taken out of context, or entirely fabricated. Deepfake technology makes detecting manipulation increasingly difficult.

Emotional responses deserve scrutiny. Content that triggers strong emotions, especially outrage, may be designed to do so. Taking time to verify before sharing prevents inadvertent spread of misinformation.

Media literacy isn't about dismissing all information but developing judgment about what to trust, how much, and why.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What forms the foundation of media literacy?',
            options: ['Source evaluation', 'Speed reading', 'Memorization', 'Entertainment'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Advertising-supported media often favors ____ over accuracy.',
            correctText: 'sensationalism',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Deepfake technology makes manipulation easier to detect.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What should be scrutinized according to the passage?',
            options: ['Emotional responses to content', 'All images equally', 'Only text media', 'Entertainment only'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is NOT a question for source evaluation?',
            options: ['Is it entertaining?', 'Who created it?', 'What is their bias?', 'Is it verifiable?'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_9',
        type: 'C1 - Advanced',
        title: 'Behavioral economics',
        level: 'C1 - Advanced',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
Behavioral economics bridges psychology and economics, revealing how real humans deviate from rational actor models. These insights have profound implications for policy design.

Nudges represent gentle pushes toward beneficial choices without restricting options. Changing organ donation from opt-in to opt-out dramatically increases participation. Placing healthy food at eye level increases consumption without banning alternatives.

Default effects prove remarkably powerful. People tend to stick with whatever option requires no action. Automatic enrollment in retirement savings plans increases participation rates substantially compared to requiring active sign-up.

Framing influences decisions significantly. Describing meat as seventy-five percent lean versus twenty-five percent fat changes perception, though the information is identical. Loss framing often motivates action more than equivalent gain framing.

Present bias explains why people fail to save adequately despite good intentions. We systematically undervalue future rewards compared to immediate gratification. Commitment devices that make future benefits feel more immediate can help overcome this tendency.

Critics raise concerns about manipulation and paternalism. Who decides what constitutes beneficial behavior? Nevertheless, acknowledging human cognitive limitations leads to more effective and humane policy design.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does behavioral economics bridge?',
            options: ['Psychology and economics', 'Math and science', 'Art and literature', 'History and geography'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Changing organ donation to opt-out is an example of a ____.',
            correctText: 'nudge',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'People readily overcome default options.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does present bias explain?',
            options: ['Why people fail to save adequately', 'Why people save too much', 'Historical events', 'Political preferences'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What concern do critics raise about nudges?',
            options: ['Manipulation and paternalism', 'Too expensive', 'Not effective', 'Too complicated'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_10',
        type: 'C1 - Advanced',
        title: 'International development',
        level: 'C1 - Advanced',
        durationSeconds: 115,
        audioUrl: _placeholderAudio,
        transcript: '''
Development economics has evolved significantly since its post-war origins. Early modernization theory assumed developing nations would follow paths blazed by industrialized countries. Experience proved this oversimplistic.

Structural adjustment programs imposed by international institutions in the 1980s and 1990s demanded market liberalization, privatization, and fiscal austerity. Results were mixed at best, with some countries experiencing deindustrialization and increased inequality.

Current approaches emphasize context-specificity and institutional capacity. What works in one country may fail in another due to different historical, cultural, and political factors. Building effective institutions proves more important than any particular policy prescription.

Human development indices have broadened how progress is measured beyond GDP. Health outcomes, educational attainment, and gender equality now receive consideration alongside economic growth.

China's development trajectory challenges conventional wisdom. State-directed development with selective market reforms produced unprecedented poverty reduction, though the model's applicability elsewhere remains debated.

The sustainable development goals represent the current international consensus, integrating economic, social, and environmental objectives. Achieving these ambitious targets requires not just aid but systemic changes in trade, finance, and governance.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did early modernization theory assume?',
            options: ['Developing nations would follow industrialized paths', 'All nations are equal', 'Development is impossible', 'Only Asia could develop'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Structural adjustment programs demanded market ____.',
            correctText: 'liberalization',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'What works in one country always works in another.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What has broadened beyond GDP?',
            options: ['Human development indices', 'Currency exchange', 'Military power', 'Population count'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does China\'s development trajectory challenge?',
            options: ['Conventional wisdom', 'Western dominance', 'Scientific progress', 'Mathematical models'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_11',
        type: 'C1 - Advanced',
        title: 'Linguistics and communication',
        level: 'C1 - Advanced',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
Language shapes thought in ways we rarely recognize. The Sapir-Whorf hypothesis, in its weak form, suggests that linguistic structures influence habitual thought patterns, even if they don't determine them absolutely.

Languages vary in what they require speakers to express. Some languages grammatically mark whether speakers witnessed events personally or heard about them secondhand. Speakers of these languages develop heightened sensitivity to information sources.

Gendered languages assign masculine or feminine categories to nouns. Research suggests this affects how speakers perceive objects, associating supposedly masculine items with characteristics like strength and feminine items with beauty.

Bilingual individuals sometimes report feeling like different people in different languages. This isn't merely anecdotal; studies show emotional processing varies between first and subsequent languages.

Professional jargon creates both precision and exclusion. Technical vocabulary enables efficient communication among experts but can mystify outsiders and maintain professional boundaries.

Understanding language as action, not just representation, reveals its social power. Speech acts like promising, apologizing, or sentencing don't describe reality; they create it.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does the Sapir-Whorf hypothesis suggest?',
            options: ['Linguistic structures influence thought', 'All languages are identical', 'Language is irrelevant', 'Only English matters'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Bilingual individuals may feel like different ____ in different languages.',
            correctText: 'people',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'All languages require the same information to be expressed.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do speech acts like promising do?',
            options: ['Create reality', 'Only describe', 'Have no effect', 'Confuse listeners'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does professional jargon create?',
            options: ['Both precision and exclusion', 'Only confusion', 'Universal understanding', 'Entertainment'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_12',
        type: 'C1 - Advanced',
        title: 'Architecture and society',
        level: 'C1 - Advanced',
        durationSeconds: 95,
        audioUrl: _placeholderAudio,
        transcript: '''
Architecture embodies societal values in physical form. The buildings we create reflect assumptions about power, community, privacy, and human nature.

Historical architecture often expressed hierarchy explicitly. Grand entrances, elevated positions, and ornate decoration signaled importance. Modern architecture initially rejected such symbolism, embracing functionalism and minimalism.

The built environment shapes behavior in subtle ways. Open office layouts encourage collaboration but can reduce productivity and privacy. Street design influences walkability, which affects physical health and social interaction.

Sustainability has become a central concern. Buildings account for roughly forty percent of global energy use. Green building standards address energy efficiency, material sourcing, and occupant health. However, the embodied carbon in construction materials deserves greater attention.

Accessibility represents both ethical obligation and design challenge. Creating spaces usable by people with diverse abilities requires thinking beyond minimum code compliance toward universal design principles.

Architecture exists in tension between permanence and adaptation. Buildings last decades or centuries, but uses change. Designing for flexibility acknowledges that we cannot perfectly predict future needs.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did historical architecture often express?',
            options: ['Hierarchy explicitly', 'Equality', 'Simplicity', 'Randomness'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Buildings account for roughly ____ percent of global energy use.',
            correctText: 'forty',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Open office layouts always increase productivity.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does universal design aim for?',
            options: ['Spaces usable by people with diverse abilities', 'Minimum code compliance', 'Maximum decoration', 'Cost reduction only'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What tension exists in architecture?',
            options: ['Between permanence and adaptation', 'Between beauty and function', 'Between cost and time', 'Between old and new'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_13',
        type: 'C1 - Advanced',
        title: 'Healthcare systems',
        level: 'C1 - Advanced',
        durationSeconds: 110,
        audioUrl: _placeholderAudio,
        transcript: '''
Healthcare systems vary dramatically across developed nations, reflecting different societal choices about the role of government, individual responsibility, and market mechanisms.

Single-payer systems, as in Canada or the UK, provide universal coverage funded through taxation. The government acts as sole insurer, negotiating prices with providers. Administrative costs are typically lower, but wait times for non-emergency care can be longer.

Multi-payer systems like Germany's use regulated private insurance with mandated coverage standards. Individuals choose among competing insurers, theoretically promoting efficiency through competition while maintaining universal access.

The United States remains an outlier, mixing employer-based private insurance, government programs for elderly and poor populations, and substantial uninsured numbers. Despite spending more per capita than any other nation, health outcomes often lag.

Healthcare inflation consistently outpaces general inflation across systems. Aging populations, advancing technology, and rising chronic disease prevalence drive costs upward. No country has found a sustainable solution to this challenge.

Pandemic response revealed both strengths and weaknesses across systems. Centralized systems could coordinate responses rapidly but sometimes lacked flexibility. Decentralized systems enabled local innovation but sometimes created coordination failures.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What characterizes single-payer systems?',
            options: ['Government acts as sole insurer', 'Multiple private insurers', 'No coverage', 'Only employer insurance'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Healthcare inflation consistently outpaces ____ inflation.',
            correctText: 'general',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The US spends less per capita than other nations on healthcare.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What drives healthcare costs upward?',
            options: ['Aging populations and advancing technology', 'Decreasing population', 'Less disease', 'Simpler treatments'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did pandemic response reveal?',
            options: ['Both strengths and weaknesses across systems', 'All systems are equal', 'Only problems', 'Only solutions'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_14',
        type: 'C1 - Advanced',
        title: 'Democracy and participation',
        level: 'C1 - Advanced',
        durationSeconds: 105,
        audioUrl: _placeholderAudio,
        transcript: '''
Democracy faces challenges from multiple directions: declining trust in institutions, political polarization, misinformation, and questions about whether complex policy decisions can effectively be made through popular vote.

Direct democracy, where citizens vote on specific policies, offers maximum participation but risks uninformed decision-making and tyranny of the majority. Representative democracy delegates decision-making but can create distance between voters and governance.

Deliberative democracy proposes bringing citizens together to discuss issues in depth before voting. Citizens' assemblies have been used successfully in Ireland to address divisive issues like abortion and same-sex marriage.

Digital tools offer new participation possibilities. Online consultations can gather input from millions. However, digital divides exclude some populations, and online discourse often degrades rather than enhances deliberation.

Campaign finance significantly influences political outcomes. In systems where private money dominates, wealthy interests gain disproportionate influence. Public financing of elections presents an alternative but faces political opposition.

Ultimately, democracy requires not just institutions but democratic culture: willingness to accept legitimate losses, commitment to peaceful transfer of power, and recognition of opponents as legitimate competitors rather than enemies.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What risk does direct democracy carry?',
            options: ['Uninformed decisions and tyranny of majority', 'Too much expertise', 'No decisions', 'Perfect outcomes'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Citizens\' assemblies have been used successfully in ____.',
            correctText: 'Ireland',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Online discourse always improves deliberation.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does democracy ultimately require?',
            options: ['Democratic culture', 'Perfect technology', 'Unlimited money', 'No opposition'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does deliberative democracy propose?',
            options: ['Citizens discuss issues before voting', 'No voting', 'Only expert decisions', 'Random selection'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c1_15',
        type: 'C1 - Advanced',
        title: 'Technology ethics',
        level: 'C1 - Advanced',
        durationSeconds: 100,
        audioUrl: _placeholderAudio,
        transcript: '''
Rapid technological advancement has outpaced ethical frameworks and regulatory capacity. We deploy powerful tools before fully understanding their implications.

Algorithmic decision-making increasingly affects consequential life outcomes: who gets loans, jobs, or parole. These systems often encode existing biases present in training data while creating an illusion of objectivity.

Attention engineering optimizes for engagement metrics that don't align with user wellbeing. Social media platforms profit from maximizing time on site, even when this harms mental health, promotes misinformation, or exacerbates polarization.

Surveillance capabilities have expanded dramatically. Governments and corporations collect unprecedented amounts of personal data. The infrastructure enabling convenience also enables control.

Emerging technologies raise novel questions. Should we create artificial general intelligence if we cannot guarantee controlling it? Is it ethical to genetically engineer future generations? Who should decide?

Technology is not neutral; it embeds values and distributes power. Engineers and technologists increasingly recognize ethical responsibility extending beyond technical functionality to broader social consequences. However, individual conscience cannot substitute for collective governance.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What has outpaced ethical frameworks?',
            options: ['Technological advancement', 'Population growth', 'Economic decline', 'Cultural change'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Algorithmic systems often create an illusion of ____.',
            correctText: 'objectivity',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Technology is completely neutral.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does attention engineering optimize for?',
            options: ['Engagement metrics', 'User wellbeing', 'Education', 'Health'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What cannot substitute for collective governance?',
            options: ['Individual conscience', 'Technology', 'Money', 'Power'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ListeningExercise> _levelC2() {
    return [
      // C2-1: Philosophy discussion
      ListeningExercise(
        id: 'c2_1',
        type: 'C2 - Proficiency',
        title: 'The ethics of artificial intelligence',
        level: 'C2 - Proficiency',
        durationSeconds: 180,
        audioUrl: _placeholderAudio,
        transcript: '''
The rapid advancement of artificial intelligence poses profound ethical questions that our philosophical frameworks are arguably ill-equipped to address.

Consider the trolley problem thought experiment applied to autonomous vehicles. In classical formulations, we debate whether it's permissible to actively cause harm to one person to prevent greater harm to others. But when we encode such decisions into algorithms, we're not making a spontaneous moral judgment in an emergency. We're making a deliberate, premeditated choice about whose life an algorithm should prioritize, potentially based on factors like age, number of passengers, or even, controversially, the statistical value of different lives.

This raises uncomfortable questions. Are we comfortable having corporations make these decisions? Should they be subject to democratic oversight? And fundamentally, can moral reasoning even be reduced to algorithmic decision-making, or is there something essentially human about ethical judgment that resists formalization?

Then there's the question of moral agency itself. If an AI system causes harm, who bears responsibility? The programmers? The company? The users who deployed it? Traditional legal concepts of negligence and intent map poorly onto systems whose behavior emerges from training processes that even their creators may not fully understand. We're faced with what philosophers call the problem of many hands, where responsibility is so distributed that it effectively evaporates.

Perhaps most concerning is the potential for AI to amplify and automate existing biases. These systems learn from historical data that reflects historical injustices. Without careful intervention, they risk encoding discrimination at scale, lending the veneer of objectivity to fundamentally subjective, and often unjust, decisions.

I would argue that we need to develop what we might call machine ethics, not just ethics for machines, but a new ethical framework that grapples with the unique challenges of autonomous systems operating at scales and speeds beyond human comprehension.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What thought experiment does the speaker apply to autonomous vehicles?',
            options: ['The trolley problem', 'The prisoner\'s dilemma', 'The paradox of thrift', 'The butterfly effect'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What concern does the speaker raise about algorithm-encoded moral decisions?',
            options: ['They\'re deliberate and premeditated rather than spontaneous', 'They\'re too expensive', 'They\'re too slow', 'They\'re easily hacked'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The "problem of many hands" refers to ____ being so distributed that it evaporates.',
            correctText: 'responsibility',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The speaker believes existing legal concepts work well for AI systems.',
            correct: false,
            explanation: 'The speaker says traditional legal concepts map poorly onto AI systems.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What risk does the speaker identify regarding AI and historical data?',
            options: ['AI may amplify and automate existing biases', 'AI will delete historical data', 'AI will create new data', 'AI will ignore historical data'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the speaker propose as a solution?',
            options: ['Developing machine ethics as a new framework', 'Banning all AI development', 'Ignoring ethical concerns', 'Letting companies decide alone'],
            correctIndex: 0,
          ),
        ],
      ),

      // C2-2: Academic discussion
      ListeningExercise(
        id: 'c2_2',
        type: 'C2 - Proficiency',
        title: 'The nature of consciousness',
        level: 'C2 - Proficiency',
        durationSeconds: 160,
        audioUrl: _placeholderAudio,
        transcript: '''
The question of consciousness remains one of the most intractable problems in philosophy and cognitive science. Despite remarkable advances in neuroscience, we seem no closer to bridging what David Chalmers famously termed the explanatory gap between physical brain processes and subjective experience.

Let me clarify the distinction between what Chalmers calls the easy problems and the hard problem. The easy problems, though technically challenging, are at least conceivably solvable through standard scientific methods. How does the brain process visual information? How do we direct attention? These questions, however complex, involve explaining cognitive functions and behaviors.

The hard problem is qualitatively different. It asks why there is something it is like to be conscious at all. Why does the processing of information give rise to subjective experience? Why isn't all this neural computation occurring "in the dark," as it were, without any accompanying experience?

Several approaches attempt to address this. Materialist theories suggest that consciousness will ultimately be explained in purely physical terms, that the hard problem is perhaps a pseudo-problem arising from our current conceptual limitations. Proponents argue that science has repeatedly explained seemingly mysterious phenomena, and consciousness will prove no different.

Dualist positions maintain that consciousness involves something beyond the physical, though modern dualists are careful to distinguish their views from outdated notions of souls or spirits. Property dualism, for instance, suggests that while consciousness arises from physical systems, mental properties are fundamentally distinct from physical properties.

Then there are more radical proposals like panpsychism, which suggests that consciousness, in some elementary form, is a fundamental feature of reality, present even in basic physical entities. While this may sound far-fetched, it has gained serious consideration from respected philosophers as a way to avoid the explanatory gap.

What's remarkable is that after centuries of inquiry, we still lack consensus on even the basic contours of a solution. This should perhaps humble us about the limits of human understanding.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What term did David Chalmers use for the gap between brain processes and experience?',
            options: ['The explanatory gap', 'The quantum gap', 'The neural gap', 'The physical gap'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is the "hard problem" of consciousness about?',
            options: ['Why processing gives rise to subjective experience', 'How the brain processes visual information', 'How to measure brain activity', 'How to treat brain disorders'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ suggests consciousness is a fundamental feature of all reality.',
            correctText: 'Panpsychism',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Materialists believe consciousness requires something beyond the physical.',
            correct: false,
            explanation: 'Materialists suggest consciousness will be explained in purely physical terms.',
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does property dualism suggest?',
            options: ['Mental properties are distinct from physical properties', 'The soul is separate from the body', 'Consciousness doesn\'t exist', 'Only physical properties exist'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the speaker suggest about our understanding of consciousness?',
            options: ['We still lack consensus after centuries', 'We have solved the problem', 'It\'s not an important question', 'Science has all the answers'],
            correctIndex: 0,
          ),
        ],
      ),

      // C2-3: Philosophy of language
      ListeningExercise(
        id: 'c2_3',
        type: 'C2 - Proficiency',
        title: 'Meaning and reference',
        level: 'C2 - Proficiency',
        durationSeconds: 140,
        audioUrl: _placeholderAudio,
        transcript: '''
The relationship between language and meaning has puzzled philosophers for millennia. How do arbitrary sounds or marks come to represent things in the world? The question seems simple until we examine it closely.

Gottlob Frege distinguished between sense and reference. The morning star and the evening star have different senses, different ways of presenting their referent, yet both refer to the same object: Venus. This distinction illuminates how identity statements can be informative rather than trivially true.

Wittgenstein's later philosophy rejected the idea that meaning resides in some realm of abstract objects. Instead, meaning is use. To understand what a word means is to know how to use it appropriately in various contexts. Language games, as he called them, are embedded in forms of life, shared practices that give words their significance.

This view has radical implications. It suggests that private languages are impossible. If meaning derives from public use, then there can be no language whose terms refer to essentially private experiences. This challenges our intuitive sense that our inner lives are immediately accessible to us in ways others cannot share.

Contemporary debates continue around compositionality, whether the meaning of complex expressions derives systematically from their parts, and externalism, whether meaning depends on factors outside the individual mind, such as one's social or physical environment.

What makes these debates matter beyond academic philosophy is their implications for artificial intelligence, law, and everyday communication.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did Frege distinguish between?',
            options: ['Sense and reference', 'Words and sentences', 'Speaking and writing', 'Grammar and vocabulary'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'According to Wittgenstein, meaning is ____.',
            correctText: 'use',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Wittgenstein believed private languages are possible.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does compositionality concern?',
            options: ['Whether complex meaning derives from parts', 'Musical composition', 'Writing skills', 'Memory'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What example illustrates sense vs reference?',
            options: ['Morning star and evening star', 'Cat and dog', 'Up and down', 'Hot and cold'],
            correctIndex: 0,
          ),
        ],
      ),

      // C2-4: Political theory
      ListeningExercise(
        id: 'c2_4',
        type: 'C2 - Proficiency',
        title: 'Theories of justice',
        level: 'C2 - Proficiency',
        durationSeconds: 150,
        audioUrl: _placeholderAudio,
        transcript: '''
John Rawls fundamentally reshaped political philosophy with his theory of justice as fairness. His thought experiment, the original position, asks what principles rational people would choose if they didn't know their place in society. Behind this veil of ignorance, self-interest transforms into impartiality.

Rawls argued such reasoners would choose two principles: first, maximum equal basic liberties for all; second, inequalities permitted only if they benefit the least advantaged members of society, the difference principle. This represents a sophisticated alternative to utilitarianism, which might sanction sacrificing minorities for aggregate welfare.

Robert Nozick offered a libertarian counter-argument in Anarchy, State, and Utopia. He contended that any pattern of distribution, however just initially, will be disturbed by voluntary exchanges. If people freely give to a basketball star, the resulting inequality is just because it arose through legitimate transfers. Redistributive taxation, on this view, amounts to forced labor.

Communitarians like Michael Sandel critiqued the Rawlsian conception of the self as abstracted from social context. We are not neutral choosers but embedded beings shaped by communities, traditions, and narratives. Justice cannot be determined independently of substantive conceptions of the good life.

These debates have profound implications for policy: taxation, healthcare, education, immigration. Abstract philosophical commitments translate into concrete positions on how societies should be organized.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What is Rawls\'s thought experiment called?',
            options: ['The original position', 'The prisoner\'s dilemma', 'The trolley problem', 'The social contract'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Rawls\'s second principle is called the ____ principle.',
            correctText: 'difference',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Nozick supports redistributive taxation.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do communitarians critique?',
            options: ['The self abstracted from social context', 'All taxation', 'Community involvement', 'Traditional values'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does utilitarianism potentially sanction according to the lecture?',
            options: ['Sacrificing minorities for aggregate welfare', 'Equal distribution', 'No taxation', 'Pure liberty'],
            correctIndex: 0,
          ),
        ],
      ),

      // C2-5: Epistemology
      ListeningExercise(
        id: 'c2_5',
        type: 'C2 - Proficiency',
        title: 'Knowledge and justification',
        level: 'C2 - Proficiency',
        durationSeconds: 145,
        audioUrl: _placeholderAudio,
        transcript: '''
Epistemology, the study of knowledge, grapples with fundamental questions: What can we know? How can we distinguish genuine knowledge from mere belief? What justifies our claims to know?

The traditional definition, knowledge as justified true belief, seemed adequate until Edmund Gettier's famous counterexamples. He demonstrated cases where someone has justified true belief yet intuitively doesn't have knowledge, typically because the justification connects to truth accidentally.

Responses to the Gettier problem have multiplied. Some add a fourth condition, such as requiring that no false beliefs enter the justification chain. Others abandon the justified true belief framework entirely in favor of reliability theories, where knowledge requires beliefs produced by reliable cognitive processes.

Foundationalism holds that some beliefs are basic, requiring no further justification, and all other knowledge rests upon these foundations. Coherentism rejects this hierarchical structure, arguing that beliefs are justified by their coherence with other beliefs in a web of interconnected commitments.

Skeptical challenges remain formidable. How do we know we're not brains in vats being fed illusory experiences? Contemporary responses include contextualism, which holds that knowledge attributions depend on conversational context, and pragmatic approaches that question whether radical skepticism raises genuine practical concerns.

These seemingly arcane debates have surprising relevance for artificial intelligence, scientific methodology, and everyday reasoning about evidence.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What did Gettier\'s examples challenge?',
            options: ['Knowledge as justified true belief', 'Scientific method', 'Religious faith', 'Mathematical proofs'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ holds that some beliefs are basic requiring no justification.',
            correctText: 'Foundationalism',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Coherentism accepts a hierarchical structure of beliefs.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do reliability theories focus on?',
            options: ['Beliefs produced by reliable cognitive processes', 'Traditional justification', 'Intuition only', 'Authority'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What skeptical scenario is mentioned?',
            options: ['Brains in vats', 'Evil demons', 'Dream hypothesis', 'Matrix simulation'],
            correctIndex: 0,
          ),
        ],
      ),

      // C2-6 through C2-15 (adding more)
      ListeningExercise(
        id: 'c2_6',
        type: 'C2 - Proficiency',
        title: 'Philosophy of mind',
        level: 'C2 - Proficiency',
        durationSeconds: 130,
        audioUrl: _placeholderAudio,
        transcript: '''
The mind-body problem asks how mental phenomena relate to physical processes. This seemingly simple question has generated centuries of philosophical debate without resolution.

Substance dualism, associated with Descartes, posits mind and body as fundamentally different kinds of substance. The obvious problem is explaining how they interact. If mind is non-physical, how can mental decisions cause physical movements?

Physicalism holds that everything, including mental states, is ultimately physical. But this faces the challenge of qualia, the subjective qualities of experience. What it is like to see red seems to involve something beyond what any physical description captures.

Functionalism defines mental states by their causal roles rather than their physical composition. Pain is whatever plays the pain role: being caused by tissue damage and causing avoidance behavior. This allows mental states to be multiply realizable in different physical substrates.

The Chinese Room argument challenges computational theories of mind. A person following rules to manipulate Chinese symbols produces appropriate outputs without understanding Chinese. This suggests that syntax is insufficient for semantics; computation alone doesn't constitute understanding.

These debates matter for artificial intelligence. If consciousness requires something beyond computation, can machines ever be genuinely conscious? Or is consciousness merely what computation feels like from the inside?
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What problem does substance dualism face?',
            options: ['Explaining mind-body interaction', 'Being too physical', 'Lacking structure', 'Being too simple'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ defines mental states by their causal roles.',
            correctText: 'Functionalism',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The Chinese Room argument supports computational theories of mind.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What are qualia?',
            options: ['Subjective qualities of experience', 'Brain chemicals', 'Nerve signals', 'Physical movements'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does "multiply realizable" mean?',
            options: ['Can occur in different physical substrates', 'Happens many times', 'Is very complex', 'Cannot be measured'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_7',
        type: 'C2 - Proficiency',
        title: 'Metaphysics of time',
        level: 'C2 - Proficiency',
        durationSeconds: 125,
        audioUrl: _placeholderAudio,
        transcript: '''
The nature of time remains one of the most perplexing topics in metaphysics. Does time flow, carrying us from past through present into future? Or is this sense of passage an illusion?

The A-theory, or tensed theory, holds that the distinction between past, present, and future is objective. The present is metaphysically privileged; the past has ceased to exist while the future hasn't yet come into being. This captures our intuitive sense of temporal experience.

The B-theory, or tenseless theory, denies objective temporal becoming. All times are equally real; the future exists just as the past does. What we call the present is merely our particular temporal location, no more special than our particular spatial location.

Special relativity complicates matters. The relativity of simultaneity suggests there's no absolute present moment shared across the universe. Different observers moving at different velocities will disagree about which events are simultaneous.

Eternalism holds that all times exist equally, forming a four-dimensional block universe. Presentism maintains that only the present exists. Growing block theory offers a middle ground: past and present exist, but the future doesn't yet.

These aren't merely academic puzzles. Our assumptions about time shape how we think about personal identity, free will, and mortality.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does A-theory hold?',
            options: ['The present is metaphysically privileged', 'All times are equal', 'Time doesn\'t exist', 'Only the future matters'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Special relativity shows the ____ of simultaneity.',
            correctText: 'relativity',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'B-theory accepts objective temporal becoming.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does eternalism hold?',
            options: ['All times exist equally', 'Only present exists', 'Time is an illusion', 'Future is unknowable'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What complicates our understanding of time?',
            options: ['Special relativity', 'Everyday experience', 'Simple logic', 'Mathematical formulas'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_8',
        type: 'C2 - Proficiency',
        title: 'Moral realism debate',
        level: 'C2 - Proficiency',
        durationSeconds: 135,
        audioUrl: _placeholderAudio,
        transcript: '''
Meta-ethics asks not what is right or wrong but what it means for something to be right or wrong. Are moral claims objectively true or merely expressions of attitude?

Moral realism holds that moral facts exist independently of what anyone thinks. When we say torture is wrong, we're stating a fact that would remain true even if everyone believed otherwise. These facts are discovered rather than invented.

Non-cognitivism denies that moral statements express beliefs at all. Instead, they express attitudes or prescriptions. Saying torture is wrong is more like saying "Boo torture!" than stating a fact about the universe.

Error theory, associated with J.L. Mackie, accepts that moral statements aim to state facts but claims they're all false. Moral properties like wrongness don't actually exist; morality involves a systematic error.

Constructivism offers a middle path. Moral truths exist but are constructed through rational agreement or cultural practice rather than discovered in nature. Different constructivists disagree about what the construction process involves.

The queerness argument challenges realism: moral facts would have to be metaphysically strange entities unlike anything else in nature. How would we detect them? What would make something wrong?

These abstract debates have concrete implications for how we approach moral disagreement, education, and law.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does moral realism claim?',
            options: ['Moral facts exist independently', 'Morality is subjective', 'Ethics is impossible', 'All cultures agree'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ theory says moral statements aim at facts but are all false.',
            correctText: 'Error',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Non-cognitivism says moral statements express beliefs.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the queerness argument challenge?',
            options: ['Moral realism', 'Non-cognitivism', 'Error theory', 'Constructivism'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does constructivism propose?',
            options: ['Moral truths are constructed through agreement', 'Morality doesn\'t exist', 'Facts are discovered', 'Ethics is simple'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_9',
        type: 'C2 - Proficiency',
        title: 'Free will and determinism',
        level: 'C2 - Proficiency',
        durationSeconds: 140,
        audioUrl: _placeholderAudio,
        transcript: '''
The free will debate asks whether we are genuinely free agents or whether our actions are determined by factors beyond our control. This question has profound implications for moral responsibility, punishment, and self-understanding.

Hard determinism holds that every event, including human decisions, is necessitated by prior causes. If we could rewind the universe to any point and replay it, everything would unfold identically. In such a world, could we meaningfully be held responsible for our actions?

Libertarian free will, not to be confused with political libertarianism, insists on genuine freedom. Some libertarians invoke agent causation, where persons initiate causal chains without themselves being determined. Critics question whether this is coherent or merely relocates the mystery.

Compatibilism, the dominant position among philosophers, argues that free will and determinism are compatible. What matters for freedom isn't the absence of causation but whether our actions flow from our own desires and deliberation rather than external compulsion. You're free if you do what you want, even if what you want is determined.

Modern neuroscience complicates the picture. Benjamin Libet's experiments showed brain activity preceding conscious decisions by hundreds of milliseconds. Does this undermine our sense of conscious agency? Interpretations vary widely.

Perhaps most troubling: if we lack free will, do our concepts of praise, blame, and punishment make sense? Some argue we should abandon retributive justice entirely.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does hard determinism hold?',
            options: ['Every event is necessitated by prior causes', 'We are completely free', 'Randomness determines everything', 'Mind controls matter'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: '____ is the dominant position among philosophers on free will.',
            correctText: 'Compatibilism',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Libertarian free will refers to political philosophy.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did Libet\'s experiments show?',
            options: ['Brain activity precedes conscious decisions', 'Consciousness comes first', 'Free will is proven', 'Determinism is false'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do some argue about punishment without free will?',
            options: ['We should abandon retributive justice', 'Punishment should increase', 'Nothing changes', 'More prisons needed'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_10',
        type: 'C2 - Proficiency',
        title: 'Philosophy of mathematics',
        level: 'C2 - Proficiency',
        durationSeconds: 130,
        audioUrl: _placeholderAudio,
        transcript: '''
Mathematical truth presents a philosophical puzzle. Mathematical statements seem objectively true or false, yet mathematics doesn't describe physical objects we can observe. What makes two plus two equal four?

Platonism holds that mathematical objects exist independently in an abstract realm. Numbers, sets, and functions are real, though non-physical. We discover mathematical truths by somehow accessing this platonic heaven.

Nominalism denies the existence of abstract objects. Mathematical statements are true in virtue of linguistic conventions or useful fictions. The challenge is explaining why mathematics is so effective in describing physical reality if it's merely conventional.

Intuitionism, associated with Brouwer, holds that mathematical objects are mental constructions. A mathematical statement is true only if we have a proof. This leads to rejecting the law of excluded middle for mathematical statements: not every proposition is determinately true or false.

Gödel's incompleteness theorems showed that any consistent formal system capable of expressing arithmetic contains truths that cannot be proved within the system. This has been interpreted variously: as limiting formalism, supporting platonism, or demonstrating the creative nature of mathematical thought.

The unreasonable effectiveness of mathematics in physics, as Wigner called it, remains mysterious. Why should abstract structures conceived by pure thought so perfectly describe physical phenomena?
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Where do mathematical objects exist according to Platonism?',
            options: ['In an abstract realm', 'In physical reality', 'In the brain', 'Nowhere'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Gödel\'s ____ theorems limit what formal systems can prove.',
            correctText: 'incompleteness',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Nominalism accepts the existence of abstract objects.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does intuitionism require for mathematical truth?',
            options: ['A constructive proof', 'Physical evidence', 'Expert agreement', 'Computer calculation'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did Wigner call the relation between math and physics?',
            options: ['The unreasonable effectiveness of mathematics', 'The mathematical universe', 'The physical proof', 'The logical connection'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_11',
        type: 'C2 - Proficiency',
        title: 'Aesthetics and art',
        level: 'C2 - Proficiency',
        durationSeconds: 120,
        audioUrl: _placeholderAudio,
        transcript: '''
Aesthetics asks fundamental questions about beauty and art. Is beauty objective, residing in objects themselves, or subjective, existing only in the eye of the beholder? What makes something a work of art?

Kant argued that aesthetic judgments claim universal validity while remaining grounded in subjective response. When we judge something beautiful, we expect others to agree, yet we can't prove beauty through argument. This peculiar status makes aesthetic judgment distinct from both personal preference and scientific fact.

The institutional theory of art, developed by Danto and Dickie, holds that artworks are objects designated as such by the artworld, a network of artists, critics, galleries, and museums. Duchamp's urinal became art because it was presented in an artistic context, not because of intrinsic properties.

Expression theories focus on art as emotional communication. Artists externalize inner states; audiences receive and respond. But this faces difficulties: artists don't always feel what they express, and audiences may respond in unintended ways.

Formalism emphasizes structural properties, line, color, composition, independent of representation or context. The critic Clive Bell spoke of significant form that produces aesthetic emotion.

These theories matter beyond academia. Copyright law, public funding, and cultural policy all require some conception of what art is and why it matters.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'According to Kant, aesthetic judgments claim what?',
            options: ['Universal validity', 'Complete objectivity', 'Pure subjectivity', 'Scientific proof'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The ____ theory says artworks are designated by the artworld.',
            correctText: 'institutional',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Formalism focuses on emotional expression.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What example illustrates institutional theory?',
            options: ['Duchamp\'s urinal', 'Mona Lisa', 'Beethoven\'s symphonies', 'Greek sculptures'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What did Clive Bell emphasize?',
            options: ['Significant form', 'Emotional truth', 'Historical context', 'Market value'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_12',
        type: 'C2 - Proficiency',
        title: 'Environmental ethics',
        level: 'C2 - Proficiency',
        durationSeconds: 125,
        audioUrl: _placeholderAudio,
        transcript: '''
Environmental ethics challenges traditional moral philosophy's anthropocentrism. Do non-human entities have intrinsic value, or do they matter only instrumentally, as means to human ends?

Biocentrism extends moral consideration to all living things. Albert Schweitzer's reverence for life attributes inherent value to every organism. But this raises difficult questions: is cutting grass immoral? Do bacteria have rights?

Ecocentrism goes further, valuing ecosystems and species as wholes rather than just individual organisms. Aldo Leopold's land ethic holds that an action is right when it preserves the integrity, stability, and beauty of the biotic community.

Deep ecology, associated with Arne Næss, advocates a radical shift in worldview, rejecting the human-nature dualism underlying environmental degradation. We are not separate from nature but embedded within it.

Practical dilemmas abound. Climate change raises questions of intergenerational justice: what do we owe future people who don't yet exist? How should we weigh human development against species preservation? Can market mechanisms adequately protect environmental values?

These debates intersect with indigenous perspectives that often feature more relational, less individualistic conceptions of humans' place in nature.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does biocentrism extend moral consideration to?',
            options: ['All living things', 'Only humans', 'Only animals', 'Only ecosystems'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Aldo Leopold developed the ____ ethic.',
            correctText: 'land',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Deep ecology accepts human-nature dualism.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does intergenerational justice concern?',
            options: ['What we owe future people', 'Current economic policy', 'Past injustices', 'International trade'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'Whose philosophy emphasizes reverence for life?',
            options: ['Albert Schweitzer', 'Aldo Leopold', 'Arne Næss', 'Peter Singer'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_13',
        type: 'C2 - Proficiency',
        title: 'Philosophy of religion',
        level: 'C2 - Proficiency',
        durationSeconds: 135,
        audioUrl: _placeholderAudio,
        transcript: '''
Philosophy of religion examines fundamental questions about God, faith, and religious experience. These inquiries proceed through rational argument rather than appeal to revelation.

The ontological argument, first articulated by Anselm, attempts to prove God's existence from the concept of God alone. God is defined as the greatest conceivable being. A being that exists necessarily is greater than one that might not exist. Therefore, God necessarily exists. Critics, most famously Kant, argue that existence is not a predicate that adds to a concept.

The problem of evil challenges theism: if God is omnipotent, omniscient, and perfectly good, why does suffering exist? Theodicies attempt to reconcile God's attributes with evil's reality, appealing to free will, soul-making, or the limits of human comprehension.

Religious epistemology asks whether religious beliefs can be rational without evidence. Reformed epistemology, developed by Plantinga, argues that belief in God can be properly basic, not requiring argument, like belief in other minds or the past.

Religious experience presents interpretive challenges. Mystical experiences share common features across traditions, but do they reveal transcendent reality or merely reflect brain states?

These debates matter regardless of one's personal beliefs. Religious and secular worldviews continue to shape politics, ethics, and culture globally.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'Who first articulated the ontological argument?',
            options: ['Anselm', 'Kant', 'Aquinas', 'Plantinga'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'The problem of ____ challenges theism regarding suffering.',
            correctText: 'evil',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Kant supported the ontological argument.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does Reformed epistemology argue?',
            options: ['Belief in God can be properly basic', 'God doesn\'t exist', 'Evidence is always needed', 'Religion is irrational'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What do theodicies attempt to do?',
            options: ['Reconcile God with evil', 'Prove evil exists', 'Deny suffering', 'Reject God'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_14',
        type: 'C2 - Proficiency',
        title: 'Personal identity',
        level: 'C2 - Proficiency',
        durationSeconds: 130,
        audioUrl: _placeholderAudio,
        transcript: '''
What makes you the same person across time? This question of personal identity has practical implications for responsibility, survival, and what matters in living.

Bodily continuity theories hold that identity follows the body. But thought experiments challenge this: if your brain were transplanted into another body, wouldn't you go with it? The brain seems more essential than other organs.

Psychological continuity theories, associated with Locke, emphasize memory and mental connections. You are the same person as your younger self because chains of memory connect you. But memory is unreliable and changes with time.

Derek Parfit's influential work questioned whether identity really matters. What we care about, he argued, is psychological continuity and connectedness, not some metaphysical fact of identity. This has radical implications: if teleportation created an exact replica while destroying the original, it might be rational to accept this as survival.

The narrative view emphasizes the stories we tell about ourselves. Identity isn't just metaphysical fact but constructed through autobiographical narrative that gives unity and meaning to life.

These debates intersect with practical ethics: advance directives for dementia patients, criminal responsibility for actions performed years ago, and the nature of death itself.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What do psychological continuity theories emphasize?',
            options: ['Memory and mental connections', 'Bodily continuity', 'Physical location', 'Social relationships'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Derek ____ questioned whether identity really matters.',
            correctText: 'Parfit',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'The narrative view says identity is purely metaphysical fact.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What thought experiment challenges bodily theories?',
            options: ['Brain transplantation', 'Time travel', 'Dream scenarios', 'Twin studies'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What practical issue relates to personal identity?',
            options: ['Advance directives for dementia', 'Traffic laws', 'Building codes', 'Tax policy'],
            correctIndex: 0,
          ),
        ],
      ),

      ListeningExercise(
        id: 'c2_15',
        type: 'C2 - Proficiency',
        title: 'Social epistemology',
        level: 'C2 - Proficiency',
        durationSeconds: 125,
        audioUrl: _placeholderAudio,
        transcript: '''
Traditional epistemology focused on individual knowers in isolation. Social epistemology recognizes that knowledge is fundamentally collaborative, produced and transmitted through social processes.

Testimony is a primary source of knowledge. Most of what we know comes from others rather than direct experience. But when should we trust testimony? Reductionists require independent evidence for reliability; anti-reductionists treat testimony as a default source like perception.

Epistemic injustice, a concept developed by Miranda Fricker, highlights how social power affects knowledge. Testimonial injustice occurs when prejudice leads hearers to give speakers less credibility than they deserve. Hermeneutical injustice occurs when gaps in collective interpretive resources prevent articulating important experiences.

The division of cognitive labor raises questions about expertise and trust. Non-experts must rely on experts but cannot directly verify expert claims. How do we responsibly navigate disagreement among experts?

Collective knowledge and group epistemology ask whether groups can know things beyond what individuals know. Scientific communities, corporations, and governments seem to possess knowledge not reducible to individual members.

In an era of misinformation and polarization, understanding the social dimensions of knowledge has urgent practical importance.
''',
        questions: [
          ListeningQuestion.multipleChoice(
            prompt: 'What does social epistemology recognize?',
            options: ['Knowledge is fundamentally collaborative', 'Individuals know everything', 'Society is irrelevant', 'Truth is impossible'],
            correctIndex: 0,
          ),
          ListeningQuestion.fillBlank(
            prompt: 'Miranda Fricker developed the concept of epistemic ____.',
            correctText: 'injustice',
          ),
          ListeningQuestion.trueFalse(
            prompt: 'Traditional epistemology emphasized social processes.',
            correct: false,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What is testimonial injustice?',
            options: ['Prejudice leading to reduced credibility', 'Lying under oath', 'Bad memory', 'False documents'],
            correctIndex: 0,
          ),
          ListeningQuestion.multipleChoice(
            prompt: 'What does the division of cognitive labor concern?',
            options: ['Expertise and trust', 'Physical work', 'Economic production', 'Political power'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }
}
