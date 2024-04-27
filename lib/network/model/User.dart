import 'package:flutter_app/network/model/Game.dart';
import 'package:flutter_app/network/model/Team.dart';

class ResponseJvt {
  String token;
  String userName;

  ResponseJvt({required this.token, required this.userName});

  factory ResponseJvt.fromJson(Map<String, dynamic> json) {
    return ResponseJvt(token: json['token'], userName: json['userName']);
  }
}

class CheckUserExisting {
  String message;
  bool canSignUp;

  CheckUserExisting({required this.message, required this.canSignUp});
}

class RegisterUser {
  String code;
  String message;

  RegisterUser({required this.code, required this.message});
}

class ProfileUser {
  String? teamId;
  List<String> roles;

  ProfileUser({this.teamId, required this.roles});

  factory ProfileUser.fromJson(Map<String, dynamic> json) {
    return ProfileUser(teamId: json['myTeamId'], roles: json['roles']);
  }
}

class ResponseProfile {
  ProfileUser? profile;
  String message;
  bool isTokenExpired;

  ResponseProfile(
      {required this.profile,
      required this.message,
      required this.isTokenExpired});
}

class User {
  final String? id;
  final String name;
  final String? surName;
  final String? dateOfBirth;
  final String? phoneNumber;
  final String profilePhotoUrl;
  final Team? userTeam;
  final String? joinDate;
  final String? email;
  final String? userName;
  final String? teamName;
  final int? seasonPerformance;
  final int? seasonGoalCount;
  final int? rank;
  final TeamGame? upComingGame;
  final List<TeamGame>? userGames;
  final List<dynamic>? roles;
  final String? lockoutLimitForMessaging;
  final int? countCursing;
  final String? status;
  final double? average;
  final int? goalCount;

  User(
      {required this.id,
      required this.status,
      required this.name,
      required this.surName,
      required this.dateOfBirth,
      required this.phoneNumber,
      required this.profilePhotoUrl,
      required this.userTeam,
      required this.joinDate,
      required this.email,
      required this.upComingGame,
      required this.userName,
      required this.teamName,
      required this.seasonPerformance,
      required this.seasonGoalCount,
      required this.rank,
      required this.userGames,
      required this.roles,
      required this.goalCount,
      required this.lockoutLimitForMessaging,
      required this.countCursing,
      required this.average});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        surName: json['surName'],
        dateOfBirth: json['dateOfBirth'],
        phoneNumber: json['phoneNumber'],
        profilePhotoUrl: json['profilePhotoUrl'],
        userTeam:
            json['userTeam'] != null ? Team.fromJson(json['userTeam']) : null,
        joinDate: json['joinDate'],
        email: json['email'],
        userName: json['userName'],
        seasonPerformance: json['seasonPerformance'],
        seasonGoalCount: json['seasonGoalCount'],
        rank: json['rank'],
        userGames: (json['userGames'] as List?)
            ?.map((e) => TeamGame.fromJson(e))
            .toList(),
        roles: json['roles'],
        lockoutLimitForMessaging: json['lockoutLimitForMessaging'],
        countCursing: json['countCursing'],
        status: json['status'],
        average: json['avarage'],
        upComingGame: json['upComing'] != null
            ? TeamGame.fromJson(json['upComing'])
            : null,
        goalCount: json['goalCount'],
        teamName: json['teamName']);
  }
}

class UserCredentials {
  final int myTeamId;
  final List<String> roles;

  UserCredentials({required this.myTeamId, required this.roles});

  factory UserCredentials.fromJson(Map<String, dynamic> json) {
    return UserCredentials(
        myTeamId: json['myTeamId'],
        roles: (json['roles'] as List).map((e) => e.toString()).toList());
  }
}
