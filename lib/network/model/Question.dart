class Question {
  final String id;
  final String header;
  final String solution;

  Question({required this.id, required this.header, required this.solution});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'], header: json['header'], solution: json['solution']);
  }
}
