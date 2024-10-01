class Quiz {
  String title;
  List<String> candidates = [];  // 기본값으로 빈 리스트
  int answer;

  Quiz({required this.title, required this.candidates, required this.answer});

  Quiz.fromMap(Map<String, dynamic> map)
      :
        title = map['title'],
        candidates = List<String>.from(map['candidates']),
        answer = map['answer'];
}
