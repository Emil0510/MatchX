import 'Team.dart';

class Division {
  final String divisionName;
  final List<Team> divisionTeams;
  final int passTeamCount;
  final bool isActive;
  final String divisionImage;

  Division(
      {required this.divisionName,
      required this.divisionTeams,
      required this.passTeamCount,
      required this.isActive,
      required this.divisionImage});


  factory Division.fromJson(Map<String, dynamic> json) {
    return Division(
        divisionName: json['divisionName'],
        divisionTeams: ((json['divisionTeams'] as List?)??[]).map((e) => Team.fromJson(e)).toList(),
        passTeamCount: json['passTeamCount'],
        isActive: json['isActive'],
        divisionImage: json['divisionImage']);
  }
}
