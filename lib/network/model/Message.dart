class Message{
  final String message;
  final String username;
  final String? myTeamId;
  final int? activeCount;
  final bool? isSystemMessage;
  final bool isFirst;

  Message( {required this.message, required this.username, this.myTeamId, required this.activeCount, required this.isFirst, required this.isSystemMessage});

  factory Message.fromJson(Map<String, dynamic> json, bool isFirst) {
    return Message(message: json['message'],username: json['userName'], myTeamId: json['teamId'], activeCount: json['activeCount'], isFirst: isFirst, isSystemMessage: json['isSystemMessage'] );
  }
}