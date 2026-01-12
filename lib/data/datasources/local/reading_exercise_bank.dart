import 'dart:math';

class ReadingQuestion {
  final String prompt;
  final List<String> options;
  final int correctIndex;
  final String? explanation;

  const ReadingQuestion({
    required this.prompt,
    required this.options,
    required this.correctIndex,
    this.explanation,
  });
}

class ReadingPassage {
  final String id;
  final String category; // e.g. "Tin tức – báo chí"
  final String topic; // e.g. "Công nghệ mới"
  final String title;
  final String text;
  final List<ReadingQuestion> questions; // 6–8

  const ReadingPassage({
    required this.id,
    required this.category,
    required this.topic,
    required this.title,
    required this.text,
    required this.questions,
  });
}

class ReadingExerciseBank {
  static List<String> categories = const [
    'Tin tức – báo chí',
    'Truyện ngắn – câu chuyện',
    'Miêu tả',
    'Phân tích – quan điểm',
    'Lịch sử – khoa học',
  ];

  static List<ReadingPassage> byCategory(String category) {
    switch (category) {
      case 'Tin tức – báo chí':
        return _newsBank();
      case 'Truyện ngắn – câu chuyện':
        return _storiesBank();
      case 'Miêu tả':
        return _descriptionsBank();
      case 'Phân tích – quan điểm':
        return _opinionsBank();
      case 'Lịch sử – khoa học':
        return _scienceHistoryBank();
      default:
        return _newsBank();
    }
  }

  static ReadingPassage randomOne(String category) {
    final list = byCategory(category);
    list.shuffle(Random());
    return list.first;
  }

  static List<ReadingPassage> _newsBank() {
    return [
      ReadingPassage(
        id: 'news_climate_1',
        category: 'Tin tức – báo chí',
        topic: 'Biến đổi khí hậu',
        title: 'Cities prepare for hotter summers',
        text:
            'Many cities are experiencing hotter summers than before, with more frequent heat waves lasting several days. In crowded neighborhoods, concrete roads and tall buildings can trap heat and make temperatures feel even higher, especially at night.\n\n'
            'To respond, local governments are planting more trees, creating shaded public spaces, and improving public transportation so fewer cars are on the streets. Some cities are also painting rooftops in lighter colors and adding water fountains in parks. These changes may look small, but they can lower the “urban heat island” effect and provide cooler places for people to rest.\n\n'
            'Experts say the most important goal is protecting vulnerable residents such as older adults, children, and outdoor workers. During extreme heat, officials may open public cooling centers and send alerts advising people to drink water and avoid exercising at midday. While no single action can stop a heat wave, a combination of smart city planning and public awareness can reduce risk and help residents stay safe.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main idea of the passage?',
            options: [
              'Cities are taking actions to deal with hotter summers',
              'Public transportation is always expensive',
              'Trees grow faster in winter',
              'Heat waves never affect cities',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which action is mentioned?',
            options: [
              'Planting more trees',
              'Closing all parks',
              'Building more factories',
              'Reducing water supply',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why are shaded public spaces useful?',
            options: [
              'They help reduce heat and keep people safe',
              'They make streets darker',
              'They increase traffic',
              'They stop public transportation',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “reduce” is closest in meaning to:',
            options: ['lower', 'increase', 'repeat', 'hide'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred about heat waves?',
            options: [
              'They can be dangerous for residents',
              'They only happen at night',
              'They are always mild',
              'They are unrelated to cities',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which title fits best?',
            options: [
              'City plans for extreme heat',
              'How to bake a cake',
              'The history of trains',
              'A day at the beach',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'news_tech_1',
        category: 'Tin tức – báo chí',
        topic: 'Công nghệ mới',
        title: 'AI helps doctors review scans',
        text:
            'Some hospitals are testing AI tools that assist doctors in reviewing medical scans such as X-rays and CT images. The software can highlight areas that may need attention, for example a small shadow in the lungs or an unusual shape in a bone. This does not mean the computer “diagnoses” patients by itself; instead, it acts like a second pair of eyes.\n\n'
            'Doctors still make the final decision because medical cases can be complex. A scan result must be considered together with symptoms, test results, and the patient’s history. Supporters believe that when used carefully, AI can save time and reduce mistakes, especially in busy hospitals where staff must handle many cases each day.\n\n'
            'However, experts also warn that AI systems can be biased if they are trained on limited data. For this reason, hospitals require strong safety rules, regular testing, and clear responsibility. Most researchers agree that the best use of AI is not replacing doctors, but helping them work faster and more accurately.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the passage mainly about?',
            options: [
              'AI assisting doctors with medical scans',
              'AI replacing all doctors',
              'Hospitals closing down',
              'Cooking lessons in hospitals',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Who makes the final decision?',
            options: ['Doctors', 'AI', 'Patients', 'Robots'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can AI do according to the text?',
            options: [
              'Highlight areas that may need attention',
              'Write a complete diagnosis without doctors',
              'Operate hospitals alone',
              'Cancel appointments',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “assist” is closest in meaning to:',
            options: ['help', 'stop', 'forget', 'hide'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Supporters believe AI can:',
            options: [
              'Save time and reduce mistakes',
              'Increase mistakes',
              'Make scans disappear',
              'Replace all hospitals',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is a reasonable inference?',
            options: [
              'AI should be used carefully in healthcare',
              'AI is never useful',
              'Doctors do not need training',
              'Scans are no longer needed',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'news_health_1',
        category: 'Tin tức – báo chí',
        topic: 'Y tế – sức khỏe',
        title: 'A community clinic expands services',
        text:
            'A community health clinic in the city center has expanded its services to meet growing demand. In the past, the clinic mainly offered basic checkups, but now it also provides mental health counseling and nutrition advice. Staff members say more people are seeking help early, instead of waiting until problems become serious.\n\n'
            'The clinic introduced an online booking system to reduce long lines. Patients can choose time slots and receive reminders, which helps them keep appointments. Doctors also run short workshops on stress management and healthy eating. According to the clinic director, education is just as important as treatment because it prevents illness in the first place.\n\n'
            'Local residents welcomed the changes, especially older adults and busy workers. However, the clinic still faces challenges such as limited funding and a shortage of qualified nurses. The director hopes the city will invest more in community healthcare, arguing that prevention can reduce costs for hospitals in the long run.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main purpose of the passage?',
            options: [
              'To report that a clinic expanded services and explain its impact',
              'To describe a new shopping mall',
              'To advertise a private gym',
              'To explain how to cook healthy food',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which new service is mentioned?',
            options: ['Mental health counseling', 'Car repair', 'Language translation', 'Hotel booking'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why did the clinic add online booking?',
            options: [
              'To reduce long lines and help patients manage appointments',
              'To replace all doctors',
              'To increase prices',
              'To close the clinic early',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “prevention” is closest in meaning to:',
            options: ['stopping problems before they happen', 'increasing illness', 'ignoring symptoms', 'buying medicine'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What challenge does the clinic face?',
            options: ['Limited funding and staff shortage', 'Too many shopping centers', 'No patients at all', 'Too many holidays'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred from the passage?',
            options: [
              'Community healthcare can reduce pressure on hospitals',
              'Only hospitals matter for health',
              'Appointments are unnecessary',
              'Workshops are always harmful',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'news_edu_1',
        category: 'Tin tức – báo chí',
        topic: 'Giáo dục',
        title: 'Schools adopt project-based learning',
        text:
            'Several schools have started using project-based learning to improve student engagement. Instead of memorizing facts for tests, students work in teams to solve real problems. For example, one class designed a plan to reduce plastic waste at school, while another group created a simple mobile app to help classmates organize study time.\n\n'
            'Teachers say projects encourage critical thinking and communication skills. Students must research information, present their ideas, and reflect on what worked and what did not. Supporters believe this approach helps students learn how to learn, which is important in a world where information changes quickly.\n\n'
            'However, some parents worry that projects may reduce time for basic knowledge such as grammar and math skills. School leaders respond that projects do not replace fundamentals; they connect them to practical situations. Most schools are now trying a balanced schedule that includes both traditional lessons and project work.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the passage mainly about?',
            options: [
              'Project-based learning in schools and its pros/cons',
              'A new bus schedule',
              'How to build a house',
              'The history of sports',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did one class design?',
            options: ['A plan to reduce plastic waste', 'A new restaurant menu', 'A movie script', 'A bank loan'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Supporters believe project work helps because:',
            options: [
              'It develops skills like research, presentation, and reflection',
              'It removes all homework forever',
              'It stops students from working in teams',
              'It makes information change slower',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What concern do some parents have?',
            options: [
              'Less time for basic knowledge',
              'Too many sports classes',
              'Too many school holidays',
              'No internet access at home',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “fundamentals” refers to:',
            options: ['basic skills', 'holiday plans', 'sports rules', 'phone brands'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which statement is supported by the passage?',
            options: [
              'Many schools try to balance projects and traditional lessons',
              'Projects completely replace all tests',
              'Teachers dislike teamwork',
              'Students do not present ideas',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'news_econ_1',
        category: 'Tin tức – báo chí',
        topic: 'Kinh tế – xã hội',
        title: 'Remote work reshapes city centers',
        text:
            'Remote work has changed how many people use city centers. Before, office workers filled cafés and restaurants during lunch breaks. Now, some businesses report fewer customers on weekdays because employees work from home. In response, shop owners are experimenting with new strategies, such as offering discounts in the morning and organizing small community events.\n\n'
            'City planners are also paying attention. Some are considering turning unused office spaces into apartments, libraries, or training centers. This could create a more mixed and lively downtown area where people live, study, and work instead of only commuting for jobs.\n\n'
            'Experts say the shift brings both challenges and opportunities. While some companies save money on office costs, workers may feel isolated if they rarely meet colleagues. Many organizations now try “hybrid” schedules, combining home and office days. Over time, cities may need to redesign public transport and services to match new daily patterns.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main topic of the passage?',
            options: [
              'How remote work changes city centers',
              'How to bake bread',
              'A new music festival',
              'Why people dislike cafés',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why do some businesses have fewer customers on weekdays?',
            options: [
              'More employees work from home',
              'All cafés are closed',
              'Public transport stopped forever',
              'People only drink tea now',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is one idea city planners consider?',
            options: [
              'Turning unused offices into apartments or community spaces',
              'Building only more offices',
              'Removing libraries from downtown',
              'Closing all restaurants',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “hybrid” most likely means:',
            options: ['a mix of home and office work', 'working only at night', 'working only outside', 'never working'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What problem might remote workers face?',
            options: ['Feeling isolated', 'Too many meetings', 'No free time at all', 'No electricity'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which inference is reasonable?',
            options: [
              'Cities may need to adapt services and transport to new routines',
              'Remote work will end next week',
              'Downtown areas will disappear completely',
              'Hybrid schedules are impossible',
            ],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ReadingPassage> _storiesBank() {
    return [
      ReadingPassage(
        id: 'story_friendship_1',
        category: 'Truyện ngắn – câu chuyện',
        topic: 'Tình bạn',
        title: 'A small favor',
        text:
            'Linh forgot her notebook before an important class, and her heart sank as soon as she realized it. The teacher was known for calling on students to answer questions, and Linh worried she would look unprepared. She searched her bag again and again, but the notebook was not there.\n\n'
            'Mai, who sat next to her, noticed Linh’s anxious face. Without making a big scene, she quietly moved her notebook closer and whispered, “You can share mine.” Linh felt relieved. During the lesson, Mai pointed at the key parts and helped Linh follow along.\n\n'
            'After class, Linh thanked Mai sincerely and promised to help her whenever she needed it. Mai simply smiled and said, “That’s what friends are for.” Linh realized that true friendship is not about perfect days; it is about small acts of support when someone needs them most.',
        questions: [
          ReadingQuestion(
            prompt: 'Why was Linh nervous?',
            options: [
              'She forgot her notebook',
              'She was late for a movie',
              'She lost her phone',
              'She broke a chair',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Mai do?',
            options: [
              'Shared her notes',
              'Ignored Linh',
              'Left the class',
              'Took Linh’s notebook',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is the message of the story?',
            options: [
              'Good friends help each other',
              'Mistakes should be punished',
              'School is always easy',
              'Notebooks are expensive',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “quietly” suggests Mai acted:',
            options: ['without drawing attention', 'angrily', 'loudly', 'carelessly'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred about Linh?',
            options: [
              'She values her friendship with Mai',
              'She dislikes studying',
              'She often refuses help',
              'She never makes mistakes',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which title fits best?',
            options: ['A small favor', 'A long journey', 'A broken bicycle', 'A new laptop'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'story_family_1',
        category: 'Truyện ngắn – câu chuyện',
        topic: 'Gia đình',
        title: 'Grandma’s recipe',
        text:
            'On a rainy Sunday, Minh visited his grandmother and found her making soup in the kitchen. The warm smell filled the house, and Minh suddenly remembered the same soup from his childhood. His grandmother smiled and said the secret was not the ingredients, but the patience.\n\n'
            'She asked Minh to help chop vegetables and stir the pot slowly. At first, Minh wanted to finish quickly, but his grandmother explained that good cooking needs attention. They talked about school, work, and family stories while the soup gently boiled. Minh realized that the kitchen was more than a place to cook; it was a place to connect.\n\n'
            'When the soup was ready, they ate together and laughed about old memories. Before Minh left, his grandmother wrote the recipe on a piece of paper and handed it to him. Minh felt grateful, knowing that the recipe carried love and tradition, not just instructions.',
        questions: [
          ReadingQuestion(
            prompt: 'Where does the story take place?',
            options: ['At Minh’s grandmother’s house', 'At a restaurant', 'At school', 'At a hospital'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Grandma say was the “secret” of the soup?',
            options: ['Patience', 'Sugar', 'Fast cooking', 'Expensive meat'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Minh realize in the kitchen?',
            options: [
              'It was a place to connect with family',
              'Cooking is always boring',
              'Vegetables are unnecessary',
              'Rainy days are dangerous',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Grandma give Minh at the end?',
            options: ['The recipe on paper', 'A new phone', 'A bicycle', 'A ticket'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “tradition” is closest in meaning to:',
            options: ['custom passed down', 'new technology', 'a quick idea', 'a loud sound'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is the main message?',
            options: [
              'Family time and small moments can be meaningful',
              'Cooking must be fast',
              'Recipes are always secret',
              'Rainy days ruin everything',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'story_school_1',
        category: 'Truyện ngắn – câu chuyện',
        topic: 'Tuổi học trò',
        title: 'The class project',
        text:
            'When the teacher announced a group project, Lan felt nervous because she preferred working alone. Her group members had different opinions, and the first meeting was messy. Everyone talked at the same time, and no one listened.\n\n'
            'Lan suggested they write a simple plan: goals, tasks, and deadlines. She also suggested that each person speak for one minute without interruption. Surprisingly, the group became calmer. They divided the work fairly, and Lan discovered that one teammate was great at design while another was good at research.\n\n'
            'On presentation day, the group performed confidently and received positive feedback. Lan realized teamwork was not about being perfect; it was about communication and respect. She left the classroom feeling proud—not only of the project, but also of the new skill she had learned.',
        questions: [
          ReadingQuestion(
            prompt: 'Why was Lan nervous at first?',
            options: [
              'She preferred working alone',
              'She hated school',
              'She forgot her homework',
              'She lost her bag',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What problem happened in the first meeting?',
            options: [
              'People talked at the same time and did not listen',
              'The teacher was absent',
              'The classroom was closed',
              'No one came',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Lan suggest to improve the teamwork?',
            options: [
              'A simple plan with tasks and deadlines',
              'Cancel the project',
              'Work without any rules',
              'Let only one person do everything',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What happened on presentation day?',
            options: ['They performed confidently and got positive feedback', 'They refused to present', 'They failed completely', 'They left early'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “respect” is closest in meaning to:',
            options: ['valuing others', 'ignoring others', 'laughing loudly', 'running away'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred about Lan?',
            options: [
              'She learned teamwork skills through experience',
              'She will never work with others again',
              'She dislikes planning',
              'She hates presentations',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'story_decision_1',
        category: 'Truyện ngắn – câu chuyện',
        topic: 'Một quyết định quan trọng',
        title: 'Choosing a new club',
        text:
            'Nam wanted to join a school club, but he could not decide between the music club and the science club. Music felt relaxing, while science felt exciting. His friends gave different advice, and Nam worried about making the wrong choice.\n\n'
            'He decided to attend one meeting for each club. In the music club, he enjoyed playing simple rhythms with others and felt less stressed. In the science club, he watched a small experiment and asked many questions. The leader encouraged him to learn by doing, not just by reading.\n\n'
            'After a week, Nam chose the science club because he wanted new challenges, but he promised himself to keep music as a hobby at home. He realized that a good decision does not always mean giving up one interest; sometimes it means organizing your time and committing to what matters most.',
        questions: [
          ReadingQuestion(
            prompt: 'What decision did Nam need to make?',
            options: ['Which school club to join', 'Which city to visit', 'Which job to quit', 'Which food to buy'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Nam do to help him decide?',
            options: ['Attended one meeting for each club', 'Asked no one', 'Chose randomly', 'Quit school'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why did Nam finally choose the science club?',
            options: ['He wanted new challenges', 'He hated music', 'It was closer to his house', 'His friends forced him'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did Nam plan to do with music?',
            options: ['Keep it as a hobby at home', 'Never listen again', 'Sell his instruments', 'Only play at school'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “commit” is closest in meaning to:',
            options: ['dedicate yourself', 'forget quickly', 'argue loudly', 'travel far'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Main message:',
            options: [
              'Making choices can involve trying options and organizing time',
              'You must choose what friends want',
              'Decisions are always easy',
              'Hobbies are useless',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'story_special_1',
        category: 'Truyện ngắn – câu chuyện',
        topic: 'Một ngày đặc biệt',
        title: 'The surprise celebration',
        text:
            'Hoa thought her birthday would be ordinary this year. She had a busy schedule and did not plan any party. On the morning of her birthday, she went to school as usual and focused on her classes.\n\n'
            'After school, her best friend invited her to “study together” at a small café. When Hoa arrived, the lights suddenly turned on and her friends shouted, “Surprise!” They had prepared a simple cake, handwritten cards, and a playlist of her favorite songs. Hoa felt her eyes fill with tears because she did not expect anyone to remember so carefully.\n\n'
            'They spent the evening laughing, sharing stories, and taking photos. Hoa realized that a celebration does not need to be expensive; it needs to be sincere. She went home feeling thankful, knowing she was surrounded by people who truly cared about her.',
        questions: [
          ReadingQuestion(
            prompt: 'How did Hoa expect her birthday to be?',
            options: ['Ordinary', 'Very expensive', 'Dangerous', 'Boring forever'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Where did the surprise happen?',
            options: ['At a café', 'At a hospital', 'At the airport', 'At the gym'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did her friends prepare?',
            options: ['A cake and handwritten cards', 'A new car', 'A hotel trip', 'A new computer'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why did Hoa feel emotional?',
            options: ['She did not expect people to remember so carefully', 'She was angry', 'She lost her phone', 'She failed an exam'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What does the story suggest about celebrations?',
            options: ['They do not need to be expensive to be meaningful', 'They must be expensive', 'They are always stressful', 'They should be avoided'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: ['The surprise celebration', 'The lost wallet', 'A rainy holiday', 'The new bicycle'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ReadingPassage> _descriptionsBank() {
    return [
      ReadingPassage(
        id: 'desc_city_1',
        category: 'Miêu tả',
        topic: 'Thành phố',
        title: 'A city by the river',
        text:
            'The city sits beside a wide river, with bridges connecting both sides like long lines across the water. In the early morning, the air feels fresh and cool. Small cafés open their doors, and the smell of coffee mixes with the gentle wind coming from the river.\n\n'
            'People walk or jog along the riverside path while street vendors prepare breakfast. Boats move slowly, and the sound of the water is soft and relaxing. In the afternoon, the area becomes busier. Families visit parks, students gather to take photos, and musicians sometimes play near the bridges.\n\n'
            'At night, the city changes again. Lights from buildings reflect on the river, creating a calm and beautiful view. Even though the city is lively, the riverside offers a peaceful space where people can slow down, breathe, and enjoy the moment.',
        questions: [
          ReadingQuestion(
            prompt: 'What is described?',
            options: ['A city by a river', 'A desert', 'A mountain village', 'A factory'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'When do cafés open?',
            options: ['Early in the morning', 'Late at night', 'At noon only', 'Never'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What creates a beautiful view at night?',
            options: [
              'Lights reflecting on the water',
              'Heavy rain',
              'Snow on the streets',
              'Empty bridges',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “calm” is closest in meaning to:',
            options: ['peaceful', 'noisy', 'dangerous', 'crowded'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which detail supports the main idea?',
            options: [
              'People walk along the riverside path',
              'Cars are broken',
              'Schools are closed',
              'The river is frozen',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: ['A city by the river', 'A stormy night', 'A new library', 'A football game'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'desc_travel_1',
        category: 'Miêu tả',
        topic: 'Du lịch',
        title: 'A quiet mountain village',
        text:
            'The village is hidden between green mountains and a narrow river. In the morning, mist covers the hills like a soft blanket, and the air smells of pine trees. Small wooden houses stand close together, and smoke rises gently from kitchen fires.\n\n'
            'People in the village live a simple life. Farmers walk to their fields early, while children ride bicycles to school. Visitors often stop at a local market to buy handmade crafts and taste warm corn cakes. Because the village is far from the city, the nights are very quiet, and the sky is full of stars.\n\n'
            'What makes this place special is its peaceful rhythm. There are no loud advertisements or crowded streets. Instead, the sound of water and wind creates a natural music. Many travelers come here not to “do more,” but to slow down, rest their minds, and appreciate a simpler way of living.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the passage mainly describing?',
            options: ['A mountain village', 'A busy airport', 'A modern factory', 'A shopping center'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is the air compared to in the morning?',
            options: ['Mist covers the hills like a soft blanket', 'Noise covers the river', 'Cars cover the roads', 'Rain covers the market'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What do visitors often do at the market?',
            options: ['Buy crafts and taste local food', 'Buy airplanes', 'Fix cars', 'Play video games'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “rhythm” is closest in meaning to:',
            options: ['daily pattern', 'loud argument', 'new building', 'fast train'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why do travelers come to the village?',
            options: ['To slow down and rest', 'To work in factories', 'To attend meetings', 'To shop for luxury brands'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which title fits best?',
            options: ['A quiet mountain village', 'A noisy downtown', 'The fastest road', 'A crowded stadium'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'desc_nature_1',
        category: 'Miêu tả',
        topic: 'Thiên nhiên',
        title: 'A national park in spring',
        text:
            'In spring, the national park becomes bright and alive. Wildflowers appear beside the trails, and small birds sing from the trees. The lake in the center reflects the sky like a mirror, and the water looks clear after months of winter rain.\n\n'
            'Hikers follow different paths depending on their energy and experience. Some choose easy routes through forests, while others climb steep hills for a wide view of the valley. Rangers remind visitors to stay on marked trails to protect plants and keep animals safe. Along the way, signs explain local species and the importance of conservation.\n\n'
            'Many visitors say the park feels like a natural classroom. It teaches patience and respect for the environment. When people return home, they often carry not only photos, but also a stronger awareness of how valuable clean air and green spaces are for future generations.',
        questions: [
          ReadingQuestion(
            prompt: 'What season is described?',
            options: ['Spring', 'Winter', 'Autumn', 'Summer'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What do rangers remind visitors to do?',
            options: ['Stay on marked trails', 'Feed wild animals', 'Pick flowers', 'Throw trash in the lake'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why are signs placed along the way?',
            options: ['To explain species and conservation', 'To sell tickets', 'To block hikers', 'To change the weather'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The phrase “natural classroom” suggests the park:',
            options: ['Teaches people about nature', 'Has many exams', 'Is a school building', 'Is always noisy'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['Visiting nature can increase environmental awareness', 'Conservation is useless', 'Birds are silent in spring', 'Trails are unnecessary'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: ['A national park in spring', 'A shopping trip', 'A cooking contest', 'A city traffic report'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'desc_festival_1',
        category: 'Miêu tả',
        topic: 'Lễ hội',
        title: 'The lantern festival',
        text:
            'Every year, the town holds a lantern festival near the old bridge. As the sun sets, streets fill with families and tourists carrying colorful lanterns made of paper and bamboo. The smell of street food spreads through the air, and traditional music plays softly in the background.\n\n'
            'The most exciting moment happens when people release lanterns onto the river. Each lantern carries a small wish written on it—health, success, peace, or love. The river becomes a moving line of light, and even strangers feel connected as they watch the glowing path.\n\n'
            'Besides beauty, the festival also has meaning. It reminds people to hope for a better future and to share happiness with others. Many visitors say the festival is unforgettable because it combines culture, community, and a quiet sense of wonder.',
        questions: [
          ReadingQuestion(
            prompt: 'Where does the festival take place?',
            options: ['Near the old bridge', 'In a desert', 'On a mountain top', 'Inside a factory'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What do people write on the lanterns?',
            options: ['Wishes', 'Shopping lists', 'Math formulas', 'Phone numbers only'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What happens when lanterns are released?',
            options: ['The river becomes a moving line of light', 'The river dries up', 'The bridge disappears', 'The town becomes silent'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “connected” is closest in meaning to:',
            options: ['linked', 'angry', 'sleepy', 'lost'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is one meaning of the festival?',
            options: ['It encourages hope and shared happiness', 'It teaches people to drive', 'It is about business competition', 'It is only for tourists'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: ['The lantern festival', 'A rainy morning', 'A football match', 'A train schedule'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'desc_people_1',
        category: 'Miêu tả',
        topic: 'Con người',
        title: 'The street musician',
        text:
            'On the corner of a busy street, a street musician plays the violin every evening. His case lies open with a few coins inside, and a small sign says, “Music makes the city kinder.” At first, many people walk past quickly, focused on their phones or rushing home.\n\n'
            'But as the melody rises, some slow down. A child stops and listens, then smiles at the musician. A tired office worker pauses for a moment, as if the music helps him breathe again. The musician does not speak much; he communicates through sound, turning noise into something peaceful.\n\n'
            'Over time, the musician becomes part of the neighborhood. People recognize him and greet him with a nod. His music reminds them that even in a busy city, small moments of art can create warmth and connection among strangers.',
        questions: [
          ReadingQuestion(
            prompt: 'What instrument does the musician play?',
            options: ['Violin', 'Drums', 'Guitar', 'Piano'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why do many people walk past at first?',
            options: ['They are busy and rushing', 'They are sleeping', 'They are lost in a forest', 'They do not hear any sound'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'How does the music affect some listeners?',
            options: ['It makes them slow down and feel calmer', 'It makes them shout', 'It makes them run faster', 'It makes them angry'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The musician “communicates through sound” means he:',
            options: ['expresses feelings using music', 'only writes letters', 'never plays', 'sells food'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['Art can create connection in everyday life', 'Cities have no music', 'Strangers never interact', 'People hate melodies'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: ['The street musician', 'The busy highway', 'A broken phone', 'A quiet classroom'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ReadingPassage> _opinionsBank() {
    return [
      ReadingPassage(
        id: 'op_social_1',
        category: 'Phân tích – quan điểm',
        topic: 'Mạng xã hội',
        title: 'Social media: useful but risky',
        text:
            'Social media helps people stay connected and share information quickly. Friends who live far apart can chat in seconds, and students can join study groups online. During emergencies, important updates can spread fast and reach many people.\n\n'
            'However, social media can also distract users and reduce concentration. Many people check their phones repeatedly, even when they want to focus on work or study. Another serious problem is misinformation: false news may look believable, and it can be shared thousands of times before anyone corrects it.\n\n'
            'To benefit from social media, people should limit screen time and follow reliable sources. Before sharing news, it is a good habit to check the original source and compare information from different websites. Used responsibly, social media can be a helpful tool; used carelessly, it can waste time and spread confusion.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the author’s purpose?',
            options: [
              'To discuss benefits and risks and give advice',
              'To sell a phone',
              'To describe a holiday',
              'To teach cooking',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'One risk mentioned is:',
            options: ['Misinformation', 'Better sleep', 'More exercise', 'Less connection'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What advice is given?',
            options: [
              'Limit screen time',
              'Share all news immediately',
              'Avoid checking sources',
              'Use social media all day',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “reliable” is closest in meaning to:',
            options: ['trustworthy', 'funny', 'cheap', 'fast'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: [
              'Social media should be used responsibly',
              'Social media has no benefits',
              'Social media is only for news',
              'Misinformation is harmless',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: [
              'Social media: useful but risky',
              'A guide to painting',
              'The history of airplanes',
              'How to run faster',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'op_techlife_1',
        category: 'Phân tích – quan điểm',
        topic: 'Công nghệ & đời sống',
        title: 'Technology and attention',
        text:
            'Technology makes daily life easier in many ways. People can pay bills online, communicate instantly, and find information quickly. For students, learning resources are available anytime, and many apps help them organize tasks and track progress.\n\n'
            'However, technology also competes for attention. Notifications, short videos, and endless scrolling can train the brain to seek quick rewards. As a result, some people find it harder to focus on long reading, deep study, or meaningful conversations. The problem is not technology itself, but the way it is designed and used.\n\n'
            'A balanced approach can reduce negative effects. Turning off unnecessary notifications, setting specific study times, and taking short breaks without screens can help. In the end, technology should serve human goals. When people control their habits, they can enjoy the benefits without losing their concentration and time.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the author mainly discussing?',
            options: [
              'Benefits and risks of technology, especially attention',
              'How to buy a new laptop',
              'Why people dislike learning',
              'The history of the internet only',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can notifications and short videos do?',
            options: ['Compete for attention', 'Improve sleep automatically', 'Stop people from using phones', 'Increase reading speed instantly'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'According to the passage, the problem is mostly:',
            options: ['How technology is designed and used', 'Technology never changes', 'Books are too long', 'Conversations are impossible'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which advice is mentioned?',
            options: ['Turn off unnecessary notifications', 'Never use technology again', 'Study only at midnight', 'Watch more short videos'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “balanced” is closest in meaning to:',
            options: ['reasonable', 'extreme', 'careless', 'impossible'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['People can control habits to benefit from technology', 'Technology must control people', 'Attention does not matter', 'Screens always improve focus'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'op_reading_1',
        category: 'Phân tích – quan điểm',
        topic: 'Thói quen đọc sách',
        title: 'Why reading still matters',
        text:
            'In a world of short posts and quick videos, some people think reading books is old-fashioned. Yet reading still matters because it trains the mind to concentrate for longer periods. A book asks readers to follow ideas, connect details, and imagine situations beyond their own experience.\n\n'
            'Reading also builds vocabulary and improves writing. When readers meet new words in context, they understand not only meanings but also how words are used naturally. Over time, this exposure makes communication clearer and more confident.\n\n'
            'Of course, reading requires effort, especially for beginners. A helpful method is starting with shorter texts, choosing interesting topics, and reading regularly for 10–15 minutes a day. With patience, reading becomes a habit—and a powerful tool for learning throughout life.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the author’s main point?',
            options: [
              'Reading is still important and useful today',
              'Videos are always better than books',
              'Vocabulary cannot be improved',
              'Books are only for children',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'How does reading help the mind?',
            options: ['It trains concentration for longer periods', 'It removes the need to think', 'It makes people forget details', 'It stops imagination'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What benefit is mentioned besides concentration?',
            options: ['Building vocabulary and improving writing', 'Learning to drive', 'Cooking faster', 'Running faster'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What method is suggested for beginners?',
            options: ['Read regularly for 10–15 minutes a day', 'Read only once a year', 'Avoid interesting topics', 'Stop at the first new word'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “context” is closest in meaning to:',
            options: ['surrounding text and situation', 'a loud noise', 'a train station', 'a secret code'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['Reading becomes easier with regular practice', 'Reading is impossible for beginners', 'Short videos improve writing more than books', 'Vocabulary is fixed forever'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'op_healthy_1',
        category: 'Phân tích – quan điểm',
        topic: 'Lối sống lành mạnh',
        title: 'Small habits, big change',
        text:
            'Many people want a healthier lifestyle, but they think it requires dramatic changes. In reality, small habits can create big results over time. Simple actions such as drinking more water, walking after meals, and sleeping regularly are easier to maintain than strict plans.\n\n'
            'Healthy habits also affect the mind. When people exercise lightly and eat balanced meals, they often feel less stressed and more energetic. This makes it easier to focus at work or school. The key is consistency: doing something small every day is more effective than doing something big once a month.\n\n'
            'Of course, everyone’s situation is different. A good strategy is choosing one habit to start with, tracking progress, and adjusting when necessary. Instead of aiming for perfection, people should aim for progress. Over time, these small steps can build a healthier and happier life.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main idea of the passage?',
            options: [
              'Small habits can lead to big health improvements',
              'Only strict diets work',
              'Walking is dangerous',
              'Health does not affect the mind',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which habit is mentioned?',
            options: ['Walking after meals', 'Eating only sugar', 'Sleeping at random times', 'Never drinking water'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why is consistency important?',
            options: ['Small daily actions are more effective long-term', 'It makes people stop trying', 'It removes energy', 'It avoids progress'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The author suggests starting by:',
            options: ['Choosing one habit and tracking progress', 'Doing everything at once', 'Ignoring your situation', 'Aiming for perfection only'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “maintain” is closest in meaning to:',
            options: ['keep', 'destroy', 'forget', 'hide'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['Progress is more realistic than perfection', 'People must change everything immediately', 'Health is only physical', 'Tracking habits never helps'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'op_lifelong_1',
        category: 'Phân tích – quan điểm',
        topic: 'Học tập suốt đời',
        title: 'Learning beyond school',
        text:
            'Many people believe learning ends after graduation, but modern life proves the opposite. Technology, workplaces, and society change quickly, so skills that were useful five years ago may not be enough today. Lifelong learning helps people adapt and stay confident.\n\n'
            'Learning does not always mean taking formal classes. It can include reading, watching tutorials, practicing new skills, or joining communities that share knowledge. For example, someone may learn a new software program for work, improve communication skills, or study a foreign language for travel.\n\n'
            'The biggest challenge is time and motivation. A practical solution is setting small goals—such as learning 20 minutes a day—and connecting learning to personal interests. When learning becomes part of daily life, it can open new opportunities and keep the mind active at any age.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main idea?',
            options: [
              'Lifelong learning helps people adapt in a changing world',
              'Learning ends after graduation',
              'Technology never changes',
              'Only children can learn',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which is an example of lifelong learning?',
            options: ['Learning new software for work', 'Stopping all reading', 'Avoiding new skills', 'Never setting goals'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is one challenge mentioned?',
            options: ['Time and motivation', 'Too many holidays', 'No internet anywhere', 'No workplaces'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What solution is suggested?',
            options: ['Set small goals like 20 minutes a day', 'Learn only once a year', 'Wait for someone to teach you', 'Avoid interests'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “adapt” is closest in meaning to:',
            options: ['adjust', 'refuse', 'forget', 'complain'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['Learning can create opportunities at any age', 'Learning is only for school exams', 'Motivation is unnecessary', 'Daily practice never works'],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }

  static List<ReadingPassage> _scienceHistoryBank() {
    return [
      ReadingPassage(
        id: 'sci_ai_1',
        category: 'Lịch sử – khoa học',
        topic: 'Internet & AI',
        title: 'From the internet to modern AI',
        text:
            'The internet changed how people access information and communicate. Instead of waiting for newspapers or TV programs, people can search for answers instantly and share ideas with others around the world. This global connection also created a huge amount of online data: articles, videos, photos, and conversations.\n\n'
            'Over time, these large amounts of data helped researchers develop better AI systems. Modern AI can learn patterns from examples, such as recognizing images or predicting the next word in a sentence. Today, AI can translate languages, recommend content, and assist in many industries, from education to healthcare.\n\n'
            'However, AI still requires careful design and oversight. Systems can make mistakes, reflect biases in their training data, or be misused. As AI becomes more common, many experts argue that society needs clear rules and responsible development so the technology supports people rather than harms them.',
        questions: [
          ReadingQuestion(
            prompt: 'What helped researchers develop better AI systems?',
            options: ['Large amounts of online data', 'Less communication', 'No internet', 'Old newspapers only'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which AI ability is mentioned?',
            options: ['Translate languages', 'Grow plants', 'Fly planes', 'Cook meals automatically'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What does the passage say AI still needs?',
            options: ['Careful design and oversight', 'No rules', 'No data', 'No researchers'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “access” is closest in meaning to:',
            options: ['reach', 'lose', 'break', 'hide'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is the main idea?',
            options: [
              'The internet and data helped AI develop, and AI is useful but needs oversight',
              'AI will replace the internet soon',
              'Data is always dangerous',
              'Communication is impossible',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Best title:',
            options: [
              'From the internet to modern AI',
              'A recipe book',
              'A travel diary',
              'A sports report',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'sci_invention_1',
        category: 'Lịch sử – khoa học',
        topic: 'Phát minh quan trọng',
        title: 'The light bulb and everyday life',
        text:
            'Before electric light became common, most people relied on candles or oil lamps after sunset. These sources were dim, produced smoke, and could easily cause fires. The invention and improvement of the light bulb changed daily life by making homes, streets, and workplaces brighter and safer.\n\n'
            'Early versions of the light bulb did not last long, and inventors faced many problems. They experimented with different materials for the filament and searched for ways to keep oxygen out of the bulb to prevent burning. Over time, better designs made bulbs more reliable and cheaper to produce.\n\n'
            'Electric light also transformed society. Factories could operate longer hours, cities developed night-time activities, and students could read and study after dark. While modern technology has advanced to LEDs and smart lighting, the basic idea remains the same: a simple invention can reshape how people live, work, and learn.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the passage mainly about?',
            options: [
              'How the light bulb changed daily life',
              'How to make candles',
              'Why streets should be darker',
              'How to build a bridge',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why were candles and oil lamps problematic?',
            options: [
              'They were dim, smoky, and could cause fires',
              'They were too bright',
              'They never produced light',
              'They made electricity cheaper',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What did inventors experiment with?',
            options: ['Filament materials and oxygen control', 'New music styles', 'Sports training', 'Food recipes'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is one social change mentioned?',
            options: ['Students could study after dark', 'People stopped reading forever', 'Factories closed permanently', 'Cities became silent at night'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “reliable” is closest in meaning to:',
            options: ['dependable', 'dangerous', 'invisible', 'confusing'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Which statement is supported?',
            options: [
              'The light bulb influenced work, learning, and city life',
              'Oil lamps are safer than electric light',
              'LEDs existed before early light bulbs',
              'Night-time activities disappeared because of light',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'sci_figure_1',
        category: 'Lịch sử – khoa học',
        topic: 'Nhân vật lịch sử',
        title: 'Marie Curie’s determination',
        text:
            'Marie Curie is remembered as one of the most influential scientists in history. She was born in Poland and later moved to France to study. At a time when women faced many limitations, she continued her education with strong determination and curiosity.\n\n'
            'Curie and her husband Pierre researched radioactivity, a term she helped develop. Their work led to major scientific discoveries and new ways to understand matter. Curie later won Nobel Prizes, becoming the first person to win in two different scientific fields.\n\n'
            'Beyond her achievements, Curie’s story is also about persistence. She worked in difficult conditions and often lacked resources. Yet she focused on learning and discovery. Today, many people see her as a symbol of courage, reminding students that talent is important, but effort and resilience matter as well.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the passage mainly about?',
            options: [
              'Marie Curie’s life and scientific contribution',
              'A famous athlete’s career',
              'How to travel to France',
              'A recipe for soup',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Where was Marie Curie born?',
            options: ['Poland', 'France', 'Canada', 'Japan'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What scientific topic is mentioned?',
            options: ['Radioactivity', 'Ocean tides', 'Space tourism', 'Cooking chemistry'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why is Curie’s story inspiring according to the passage?',
            options: [
              'She showed persistence despite difficulties',
              'She avoided learning',
              'She never faced limitations',
              'She disliked research',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “resilience” is closest in meaning to:',
            options: ['ability to recover and keep going', 'fear of success', 'lack of curiosity', 'fast travel'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: ['Effort can be as important as talent', 'Only men can succeed in science', 'Curie worked with unlimited resources', 'Studying abroad is always easy'],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'sci_industry_1',
        category: 'Lịch sử – khoa học',
        topic: 'Cách mạng công nghiệp',
        title: 'Factories and new working lives',
        text:
            'The Industrial Revolution changed how goods were produced. Before factories became common, many items were made by hand in small workshops or at home. With new machines and energy sources, factories could produce large quantities faster and at lower cost.\n\n'
            'This shift created new jobs, but it also brought challenges. Many workers moved from rural areas to cities, searching for employment. Factory work often involved long hours and repetitive tasks, and early workplaces were sometimes unsafe. Over time, social movements and laws began to improve working conditions.\n\n'
            'The Industrial Revolution also influenced education and technology. As industries grew, people needed new skills, and schools expanded to prepare workers. While modern jobs look different today, the main lesson remains: technological progress can improve living standards, but society must manage its effects carefully to protect people.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main idea of the passage?',
            options: [
              'The Industrial Revolution changed production and society',
              'Factories have no impact on cities',
              'Handmade goods disappeared overnight',
              'Machines always make work safer immediately',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What happened as factories grew?',
            options: ['Many workers moved to cities for jobs', 'People stopped working', 'Cities became smaller', 'No new skills were needed'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What challenge is mentioned?',
            options: ['Long hours and unsafe conditions', 'Too many holidays', 'No machines anywhere', 'Too much free time'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What helped improve working conditions over time?',
            options: ['Social movements and laws', 'More smoke', 'Less education', 'More repetition'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “repetitive” is closest in meaning to:',
            options: ['done again and again', 'creative and new', 'dangerous and fast', 'quiet and calm'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: [
              'Progress requires careful management to protect people',
              'Technology never affects society',
              'Education became less important',
              'Factories ended the need for laws',
            ],
            correctIndex: 0,
          ),
        ],
      ),
      ReadingPassage(
        id: 'sci_progress_1',
        category: 'Lịch sử – khoa học',
        topic: 'Tiến bộ khoa học',
        title: 'Vaccines and public health',
        text:
            'Vaccines are one of the most important scientific achievements in public health. They help the body learn to fight certain diseases without experiencing the full illness. When many people are vaccinated, outbreaks become less likely, which protects not only individuals but also communities.\n\n'
            'Developing a vaccine takes time and careful testing. Scientists must confirm that it is safe and effective, and health organizations monitor results after release. Public communication is also crucial because misunderstanding and fear can reduce vaccination rates. Clear information helps people make informed decisions.\n\n'
            'While vaccines are not perfect, history shows they have reduced many deadly diseases and saved millions of lives. In the future, continued research may create new vaccines and improve existing ones. The broader lesson is that science works best when combined with trust, responsibility, and cooperation.',
        questions: [
          ReadingQuestion(
            prompt: 'What is the main topic of the passage?',
            options: ['Vaccines and public health', 'How to build a hospital', 'A sports competition', 'Cooking for beginners'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What do vaccines help the body do?',
            options: ['Learn to fight diseases', 'Forget how to heal', 'Avoid all exercise', 'Increase fear'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'Why is public communication important?',
            options: [
              'Misunderstanding can reduce vaccination rates',
              'It makes diseases spread faster',
              'It replaces all testing',
              'It stops research',
            ],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What is required when developing vaccines?',
            options: ['Careful testing for safety and effectiveness', 'No monitoring', 'No data', 'No time'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'The word “outbreaks” is closest in meaning to:',
            options: ['sudden spread of disease', 'quiet holidays', 'city traffic', 'music events'],
            correctIndex: 0,
          ),
          ReadingQuestion(
            prompt: 'What can be inferred?',
            options: [
              'Science and cooperation together protect communities',
              'Vaccines have never helped anyone',
              'Testing is unnecessary for health',
              'Trust is harmful in public health',
            ],
            correctIndex: 0,
          ),
        ],
      ),
    ];
  }
}


