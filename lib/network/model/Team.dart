import 'Game.dart';
import 'User.dart';

class TeamDetail {
  final Team team;

  TeamDetail({required this.team});

  factory TeamDetail.fromJson(Map<String, dynamic> json) {
    return TeamDetail(
      team: Team.fromJson(json['team']),
    );
  }
}

class Team {
  final String? id;
  final String? name;
  final String? teamCapitanUserName;
  final double rating;
  final String? description;
  final String? teamLogoUrl;
  final bool? isPrivate;
  final List<User>? members;
  final int? rank;
  int? draw;
  int? victory;
  int? fail;
  int? gameCount;
  int? goalCount;
  final int? divisionId;
  final Division? division;
  final int? divisionPoint;
  final String? createdAt;
  final List<DivisionMedal>? divisionMedals;
  final int? memberCount;
  final int? point;
  final String? lastGames;
  final List<TeamGame>? teamGames;

  Team(
      {required this.id,
      required this.name,
      required this.teamCapitanUserName,
      required this.rating,
      required this.description,
      required this.teamLogoUrl,
      required this.isPrivate,
      required this.members,
      required this.draw,
      required this.victory,
      required this.lastGames,
      required this.point,
      required this.fail,
      required this.rank,
      required this.memberCount,
      required this.gameCount,
      required this.goalCount,
      required this.teamGames,
      required this.divisionId,
      required this.division,
      required this.divisionPoint,
      required this.createdAt,
      required this.divisionMedals});

  factory Team.fromJson(Map<String, dynamic>? json) {
    Division? division =
        json?['division'] != null ? Division.fromJson(json?['division']) : null;

    return Team(
        id: json?['id'],
        name: json?['name'],
        teamCapitanUserName: json?['teamCapitanUserName'],
        rating: json?['rating'] ?? 0,
        description: json?['description'],
        teamLogoUrl: json?['teamLogoUrl'],
        isPrivate: json?['isPrivate'],
        members: ((json?['members'] ?? []) as List?)
            ?.map((e) => User.fromJson(e))
            .toList(),
        draw: json?['draw'],
        rank: json?['rank'],
        memberCount: json?['memberCount'],
        victory: json?['victory'],
        fail: json?['fail'],
        lastGames: json?['lastGames'],
        point: json?['point'],
        gameCount: json?['gameCount'],
        goalCount: json?['goalCount'],
        divisionId: json?['divisionId'],
        division: division,
        divisionPoint: json?['divisionPoint'],
        createdAt: json?['createdAt'],
        teamGames: (json?['teamGames'] as List?)
            ?.map((e) => TeamGame.fromJson(e))
            .toList(),
        divisionMedals: ((json?['divisionMedals'] ?? []) as List?)
            ?.map((e) => DivisionMedal.fromJson(e))
            .toList());
  }
}

class Division {
  final int? id;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final String? divisionName;
  final int? passTeamCount;
  final int? failTeamCount;
  final String? divisionImage;
  final List<Team>? teams;

  Division(
      {required this.id,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      required this.divisionName,
      required this.passTeamCount,
      required this.failTeamCount,
      required this.divisionImage,
      required this.teams});

  factory Division.fromJson(Map<String, dynamic> json) {
    List<DivisionMedal>? divisionMedals = (json['divisionMedals'] as List?)
        ?.map((e) => DivisionMedal.fromJson(e))
        .toList();
    return Division(
        id: json['id'],
        createdAt: json['createdAt'],
        createdBy: json['createdBy'],
        updatedAt: json['updatedAt'],
        updatedBy: json['updatedBy'],
        divisionName: json['divisionName'],
        passTeamCount: json['passTeamCount'],
        failTeamCount: json['failTeamCount'],
        divisionImage: json['divisionImage'],
        teams: json['teams']);
  }
}

class DivisionMedal {
  final int id;
  final String? createdAt;
  final String? createdBy;
  final String? updatedAt;
  final String? updatedBy;
  final dynamic team;
  final int? teamId;
  final Division? division;
  final int? divisionId;
  final int? count;

  DivisionMedal(
      {required this.id,
      required this.createdAt,
      required this.createdBy,
      required this.updatedAt,
      required this.updatedBy,
      required this.team,
      required this.teamId,
      required this.division,
      required this.divisionId,
      required this.count});

  factory DivisionMedal.fromJson(Map<String, dynamic> json) {
    return DivisionMedal(
        id: json['id'],
        createdAt: json['createdAt'],
        createdBy: json['createdBy'],
        updatedAt: json['updatedAt'],
        updatedBy: json['updatedBy'],
        team: json['team'],
        teamId: json['teamId'],
        division: Division.fromJson(json['division']),
        divisionId: json['divisionId'],
        count: json['count']);
  }
}
