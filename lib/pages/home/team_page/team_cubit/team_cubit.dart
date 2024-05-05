import 'package:dio/dio.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Team.dart';
import '../../../../network/network.dart';

class TeamCubit extends Cubit<TeamCubitStates> {
  TeamCubit() : super(InitialTeamState());

  List<Team> teams = [];
  bool isLoaded = false;

  set(List<Team> teams, bool isLoaded) {
    this.teams = teams;
    this.isLoaded = isLoaded;
  }

  start() {
    if (isLoaded) {
      emit(AllTeamPageState(teams: teams));
      return;
    }
    emit(TeamLoadingState());
    loadTeams();
  }

  Future<List<Team>> refresh() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString("token");

    var response = await dio.get(baseUrl + teamsApi,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }));
    if (response.statusCode == 200) {
      List<Team>? teams = (response.data['data']['teams'] as List)
          .map((e) => Team.fromJson(e))
          .toList();
      this.teams = teams;
      isLoaded = true;
      teamPageCubit = this;
      return this.teams;
    } else {
      return teams;
    }
  }

  loadTeams() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString("token");

    var response = await dio.get(baseUrl + teamsApi,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }));
    if (response.statusCode == 200) {
      List<Team>? teams = (response.data['data']['teams'] as List)
          .map((e) => Team.fromJson(e))
          .toList();
      this.teams = teams;
      isLoaded = true;
      teamPageCubit = this;
      emit(AllTeamPageState(teams: teams));
    } else if (response.statusCode == 401 || response.statusCode == 404) {
    } else {
      emit(TeamErrorState());
    }
  }

  loadWithFilter(
      int minRange,
      int maxRange,
      bool? isPrivate,
      int minMembersCount,
      int maxMembersCount,
      int sort,
      int division,
      int page) async {
    print(maxRange);
    print(minRange);

    emit(TeamLoadingState());
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString("token");
    Map<String, dynamic> query = {
      "minRange": minRange,
      "maxRange": maxRange,
      "isPrivate": isPrivate,
      "minMembersCount": minMembersCount,
      "maxMembersCount": maxMembersCount,
      "sort": sort,
      "division": division,
      "page": page
    };

    var response = await dio.get(baseUrl + teamsApi,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
        queryParameters: query);

    print(response.data);

    if (response.statusCode == 200) {
      List<Team> teams = (response.data['data']['teams'] as List)
          .map((e) => Team.fromJson(e))
          .toList();
      this.teams = teams;
      isLoaded = true;
      teamPageCubit = this;
      emit(AllTeamPageState(teams: teams));
    } else if (response.statusCode == 401 || response.statusCode == 404) {
    } else {
      emit(TeamErrorState());
    }
  }

  loadWithSearch(String search) async {
    emit(TeamLoadingState());
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString("token");

    var response = await dio.get(baseUrl + teamsApi,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
        queryParameters: {"search": search});

    if (response.statusCode == 200) {
      List<Team>? teams = (response.data['teams'] as List?)
          ?.map((e) => Team.fromJson(e))
          .toList();
      this.teams = teams ?? [];
      isLoaded = true;
      teamPageCubit = this;
      emit(AllTeamPageState(teams: teams ?? []));
    } else if (response.statusCode == 401 || response.statusCode == 404) {
    } else {
      emit(TeamErrorState());
    }
  }

  joinTeam(
      String teamId, bool isPrivate, Function(bool, String) function) async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + joinTeamApi + teamId.toString(),
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        if (response.data["success"]) {
          if (isPrivate) {
            function(true, "Sorğu göndərildi");
          } else {
            sharedPreferences.setString(myTeamIdKey, teamId);
            function(true, "Komandaya qoşuldun");
            start();
          }
        } else {
          function(false, response.data["message"]);
        }
      }
    } on DioException catch (e) {
      print(e.response?.data);
      function(false, e.response?.data ?? "");
    }
  }
}
