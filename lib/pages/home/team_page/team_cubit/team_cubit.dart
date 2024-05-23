import 'package:dio/dio.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/network/model/TeamFilter.dart';
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
  Map<String, dynamic> body = {};
  int page = 1;
  TeamFilter filter = TeamFilter();

  set(List<Team> teams, bool isLoaded, Map<String, dynamic> body, int page,
      TeamFilter filter) {
    this.teams = teams;
    this.isLoaded = isLoaded;
    this.body = body;
    this.page = page;
    this.filter = filter;
  }

  start() {
    if (isLoaded) {
      emit(AllTeamPageState(teams: teams, filter: filter));
      return;
    }
    emit(TeamLoadingState());
    loadTeams();
  }

  Future<List<Team>> refresh() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString("token");

    body = {};
    page = 1;
    filter = TeamFilter();
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

    page = 1;
    filter = TeamFilter();
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
      emit(AllTeamPageState(teams: teams, filter: TeamFilter()));
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
    emit(TeamLoadingState());

    this.page = 1;

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
      "page": this.page
    };

    body = query;

    filter = TeamFilter(
        minRange: minRange,
        maxRange: maxRange,
        isPrivate: isPrivate,
        minMembersCount: minMembersCount,
        maxMembersCount: maxMembersCount,
        sort: sort,
        division: division);
    var response = await dio.get(baseUrl + teamsApi,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
        queryParameters: body);

    if (response.statusCode == 200) {
      List<Team> teams = (response.data['data']['teams'] as List)
          .map((e) => Team.fromJson(e))
          .toList();
      this.teams = teams;
      isLoaded = true;
      teamPageCubit = this;
      emit(AllTeamPageState(teams: teams, filter: filter));
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

    body = {"search": search};
    page = 1;
    filter = TeamFilter(search: search);
    var response = await dio.get(baseUrl + teamsApi,
        options: Options(headers: {
          "Authorization": "Bearer $token",
        }),
        queryParameters: body);

    if (response.statusCode == 200) {
      List<Team>? teams = (response.data['data']['teams'] as List?)
          ?.map((e) => Team.fromJson(e))
          .toList();

      this.teams = teams ?? [];
      isLoaded = true;
      teamPageCubit = this;
      emit(AllTeamPageState(teams: teams ?? [], filter: filter));
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
            isLoaded = false;
            start();
          }
        } else {
          function(false, response.data["message"]);
        }
      }
    } on DioException catch (e) {
      function(false, e.response?.data['message'] ?? "");
    }
  }

  void loadMore(Function(List<Team>) callback) async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString("token");

    try {
      page++;

      if (!body.containsKey("page")) {
        body["page"] = page;
      } else {
        body.update("page", (value) => page);
      }

      var response = await dio.get(baseUrl + teamsApi,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: body);

      if (response.statusCode == 200) {
        List<Team>? teams = (response.data['data']['teams'] as List?)
            ?.map((e) => Team.fromJson(e))
            .toList();
        this.teams.addAll(teams ?? []);
        isLoaded = true;
        teamPageCubit = this;

        callback(teams ?? []);
      } else {
        callback([]);
      }
    } on DioException catch (e) {
      callback([]);
    }
  }
}
