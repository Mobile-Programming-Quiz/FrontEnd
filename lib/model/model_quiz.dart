// class Quiz {
//   String title;
//   List<String> candidates = [];
//   int answer;
//   String? hint; // 힌트 추가 (nullable)
//
//   Quiz({required this.title, required this.candidates, required this.answer, this.hint});
//
//   Quiz.fromMap(Map<String, dynamic> map)
//       : title = map['title'],
//         candidates = List<String>.from(map['candidates']),
//         answer = map['answer'],
//         hint = map['hint'];
//
//
// }

class Quiz {
  String title;
  List<String> candidates = [];
  int answer;
  String? hint; // 힌트 추가 (nullable)
  bool used; // 사용 여부를 나타내는 필드 추가

  Quiz({required this.title, required this.candidates, required this.answer, this.hint, this.used = false});

  Quiz.fromMap(Map<String, dynamic> map)
      : title = map['title'],
        candidates = List<String>.from(map['candidates']),
        answer = map['answer'],
        hint = map['hint'],
        used = map['used'] ?? false;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'candidates': candidates,
      'answer': answer,
      'hint': hint,
      'used': used,
    };
  }
}

