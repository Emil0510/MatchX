class GameResult {
  final String userId;
  final int goalCount;

  GameResult({required this.userId, required this.goalCount});

  Map<String, dynamic> toJson() {
    return {'userId': userId, 'goalCount': goalCount};
  }
}
