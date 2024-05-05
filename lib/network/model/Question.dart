class Question {
  final String? id;
  final String header;
  final String description;

  Question({required this.id, required this.header, required this.description});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        id: json['id'], header: json['header'], description: json['description']);
  }
}
