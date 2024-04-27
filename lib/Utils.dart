import 'package:flutter_app/Constants.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool checkLeader() {
  var sharedPreferences = locator.get<SharedPreferences>();
  var roles = sharedPreferences.getStringList(rolesKey);
  return roles?.contains("TeamCapitan") ?? false;

}

bool checkExistingTeam() {
  var sharedPreferences = locator.get<SharedPreferences>();
  var teamId = sharedPreferences.getString(myTeamIdKey);
  print("Team id $teamId");
  print(teamId != -1);
  return teamId != "";
}

String? getMyTeamId() {
  var sharedPreferences = locator.get<SharedPreferences>();
  var id = sharedPreferences.getString(myTeamIdKey);
  return id ?? "";
}

String getGameDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  var month = DateFormat('MMMM').format(dateTime);
  String gameDate = "${dateTime.day} $month, ${dateTime.hour}:00";
  return gameDate;
}


String getNotificationDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  var month = DateFormat('MMMM').format(dateTime);
  print(dateTime.hour);
  String gameDate = "${dateTime.day} $month, ${dateTime.hour}:${dateTime.minute>9?"":"0"}${dateTime.minute}";
  return gameDate;
}

String getMyUsername(){
  var sharedPreferences = locator.get<SharedPreferences>();
  var username = sharedPreferences.getString(usernameKey);
  return username ?? "";
}
