import 'User.dart';

class TeamGame {
  final String? id;
  final String? homeTeamName;
  final String? awayTeamName;
  final List<User>? homeTeamMembers;
  final List<User>? awayTeamMembers;
  final String? homeTeamId;
  final String? message;
  final String? awayTeamId;
  final int? region;
  final String? homeTeamImageUrl;
  final String? awayTeamImageUrl;
  final String? gameDate;
  final int? awayTeamPointChange;
  final int? homeTeamPointChange;
  final int? homeTeamGoal;
  final int? awayTeamGoal;
  final bool? isRated;
  final double? homeTeamRating;
  final double? awayTeamRating;
  final bool? isVerificated;
  final List<StaffItem>? stats;

  TeamGame(
      {required this.homeTeamName,
      required this.awayTeamName,
      required this.homeTeamImageUrl,
      required this.awayTeamImageUrl,
      required this.gameDate,
      required this.message,
      required this.awayTeamPointChange,
      required this.homeTeamPointChange,
      required this.homeTeamGoal,
      required this.awayTeamGoal,
      required this.isRated,
      required this.homeTeamRating,
      required this.awayTeamRating,
      required this.id,
      required this.region,
      required this.homeTeamId,
      required this.awayTeamId,
      required this.homeTeamMembers,
      required this.awayTeamMembers,
      this.stats,
      this.isVerificated});

  factory TeamGame.fromJson(Map<String, dynamic> json) {
    return TeamGame(
        homeTeamName: json['homeTeamName'],
        awayTeamName: json['awayTeamName'],
        homeTeamImageUrl: json['homeTeamImage'],
        awayTeamImageUrl: json['awayTeamImage'],
        gameDate: json['gameDate'],
        awayTeamPointChange: json['awayTeamPointChange'],
        homeTeamPointChange: json['homeTeamPointChange'],
        homeTeamGoal: json['homeTeamGoal'],
        awayTeamGoal: json['awayTeamGoal'],
        isRated: json['isRated'],
        message: json['message'],
        region: json['region'],
        homeTeamRating: json['homeTeamRating'],
        awayTeamRating: json['awayTeamRating'],
        id: json['id'],
        homeTeamId: json['homeTeamId'],
        awayTeamId: json['awayTeamId'],
        homeTeamMembers: (json['homeTeamMembers'] as List?)
            ?.map((e) => User.fromJson(e))
            .toList(),
        awayTeamMembers: (json['awayTeamMembers'] as List?)
            ?.map((e) => User.fromJson(e))
            .toList(),
        stats: (json['stats'] as List?)
            ?.map((e) => StaffItem.fromJson(e))
            .toList(),
        isVerificated: json["isVerificated"]);
  }
}
