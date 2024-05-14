class Message {
  final String message;
  final String username;
  final String? myTeamId;
  int? activeCount;
  final bool? isSystemMessage;
  final bool isFirst;
  final String? tagUserName;

  Message(
      {required this.tagUserName,
      required this.message,
      required this.username,
      this.myTeamId,
      required this.activeCount,
      required this.isFirst,
      required this.isSystemMessage});

  factory Message.fromJson(Map<String, dynamic> json, bool isFirst) {
    return Message(
      tagUserName: json['tagUserName'],
      message: json['message'],
      username: json['userName'],
      myTeamId: json['teamId'],
      activeCount: json['activeCount'],
      isFirst: isFirst,
      isSystemMessage: json['isSystemMessage'],
    );
  }
}
