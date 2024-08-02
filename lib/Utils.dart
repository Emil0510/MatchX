import 'package:flutter/cupertino.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  return teamId != "";
}

String? getMyTeamId() {
  var sharedPreferences = locator.get<SharedPreferences>();
  var id = sharedPreferences.getString(myTeamIdKey);

  return id ?? "";
}

void setMyTeamId(String teamId) async {
  var sharedPreferences = locator.get<SharedPreferences>();
  await sharedPreferences.setString(myTeamIdKey, teamId);
}

String getGameDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  var month = DateFormat('MMMM').format(dateTime);
  String gameDate = "${dateTime.day} $month, ${dateTime.hour}:00";
  return gameDate;
}


String getGameLeftTime(String date){
  DateTime dateTime = DateTime.parse(date);
  var now = DateTime.now();
  if(now.isBefore(dateTime)){
    var time = dateTime.difference(now);
    if(time.inDays != 0){
      return "${time.inDays} gün qaldı";
    }else if(time.inHours !=0){
      return "${time.inHours} saat qaldı";
    }else{
      return "${time.inMinutes} dəqiqə qaldı";
    }
  }else{
    return "Bitdi";
  }
}

String getNotificationDate(String date) {
  DateTime dateTime = DateTime.parse(date);
  var month = DateFormat('MMMM').format(dateTime);
  String gameDate = "${dateTime.day} $month, ${dateTime.hour}:${dateTime.minute>9?"":"0"}${dateTime.minute}";
  return gameDate;
}

String getMyUsername(){
  var sharedPreferences = locator.get<SharedPreferences>();
  var username = sharedPreferences.getString(usernameKey);
  return username ?? "";
}

// Step 3: Create BLoC Provider
class CustomBlocProvider extends InheritedWidget {
  final Bloc bloc;

  const CustomBlocProvider({
    Key? key,
    required Widget child,
    required this.bloc,
  }) : super(key: key, child: child);

  static Bloc of(BuildContext context) {
    final CustomBlocProvider? provider = context.dependOnInheritedWidgetOfExactType<CustomBlocProvider>();
    assert(provider != null, 'No BlocProvider found in context');
    return provider!.bloc;
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }
}


