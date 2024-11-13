class Quiz {
  String title;
  List<String> candidates = [];
  int answer;
  String? hint; // 힌트 추가 (nullable)

  Quiz({required this.title, required this.candidates, required this.answer, this.hint});

  Quiz.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        candidates = List<String>.from(map['candidates']),
        answer = map['answer'],
        hint = map['hint']; // 힌트 초기화
}
