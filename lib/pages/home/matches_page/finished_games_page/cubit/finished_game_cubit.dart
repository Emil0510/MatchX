import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_games_state.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/ui/FinishedGamesConfirmPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../network/model/Game.dart';
import '../../../../../network/model/GameResult.dart';


class FinishedGamesCubit extends Cubit<FinishedGamesStates> {
  FinishedGamesCubit() : super(FinishedGamesInitialState());

  List<TeamGame> allGames = [];

  start() async {
    emit(FinishedGamesLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + getUnverfyGames,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        List<TeamGame> myTeamGames = (response.data['data'] as List)
            .map((e) => TeamGame.fromJson(e))
            .toList();
        allGames = (myTeamGames);
        emit(FinishedGamesPageState(myGames: allGames));
      } else {
        emit(FinishedGamesErrorState());
      }
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }


  Future<List<TeamGame>> refreshUnverifyGames () async{

    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + getUnverfyGames,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        List<TeamGame> myTeamGames = (response.data['data'] as List)
            .map((e) => TeamGame.fromJson(e))
            .toList();
        allGames = (myTeamGames);
        return Future.value(allGames);
      } else {
        return Future.value([]);
      }
    } on DioException catch (e) {
      print(e.response?.data);
      return Future.value([]);
    }
  }

  toConfirmPage(TeamGame game, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<FinishedGamesCubit>(
          create: (BuildContext context) => FinishedGamesCubit(),
          child: FinishedGamesConfirmPage(game: game),
        ),
      ),
    );
  }

  verifyGame(String gameId, int? awayGoal, List<GameResult> gameResult,
      Function(bool, String) fun) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    if(awayGoal == null){
      fun(false,
          "Əvvəlcə oyun nəticəsi əlavə olunmalıdır!");
      return;
    }

    int goalCount = 0;
    for (var i in gameResult) {
      goalCount += i.goalCount;
    }

    if (goalCount != awayGoal) {
      fun(false,
          "Oyunçuların qol sayları komandanın qol sayına bərabər olmalıdır!");
      return;
    }

    var json = jsonEncode(gameResult.map((e) => e.toJson()).toList());

    print(json);

    var formData = FormData.fromMap({"id": gameId, "gameResult": json});
    try {
      var response = await dio.post(baseUrl + verifyGameApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      if (response.statusCode == 200) {
        fun(true, "Oyun təsdiqləndi!");
      } else {
        print(response.data);
        fun(false, "Səhvlik");
      }
    } on DioException catch (e) {
      print(e.response?.data);
      fun(false, "Səhvlik");
    }
  }

  setGameResult(String gameId, int homeGoal, int awayGoal,
      List<GameResult> gameResult, Function(bool, String) fun) async {
    //Check goals
    int goalCount = 0;
    for (var i in gameResult) {
      goalCount += i.goalCount;
    }

    if (goalCount != homeGoal) {
      fun(false,
          "Oyunçuların qol sayları komandanın qol sayına bərabər olmalıdır!");
      return;
    }

    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    var json = jsonEncode(gameResult.map((e) => e.toJson()).toList());

    print(json);

    var formData = FormData.fromMap({
      "id": gameId,
      "homeTeamGoal": homeGoal,
      "awayTeamGoal": awayGoal,
      "gameResults": json
    });
    try {
      var response = await dio.post(baseUrl + resultGameApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          data: formData);

      if (response.statusCode == 200) {
        fun(true, "Oyun nəticəsi əlavə edildi");
      } else {
        print(response.data);
        fun(false, "Səhvlik");
      }
    } on DioException catch (e) {
      print(e.response?.data);
      fun(false, e.response?.data['message']);
    }
  }

  cancelGame(Function(bool, String) fun, String id) async {
    // emit(FinishedGamesLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(baseUrl + cancelGameApi,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          queryParameters: {"id": id});

      if (response.statusCode == 200) {
        fun(true, "Oyun ləğv edildi");
      } else {
        fun(false, "Səhvlik");
        emit(FinishedGamesPageState(myGames: allGames));
      }
    } on DioException catch (e) {
      fun(false, "Səhvlik");
      emit(FinishedGamesPageState(myGames: allGames));
    }
  }

  rejectGame(String gameId, Function(bool, String) fun) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + rejectGameApi,
        options: Options(headers: {"Authorization": "Bearer $token"}),
        queryParameters: {"id": gameId},
      );
      if (response.statusCode == 200) {
        fun(true, "Nəticələr ləğv edildi");
      } else {
        fun(false, "Səhvlik");
      }

    } on DioException catch (e) {
      fun(false, "Səhvlik");
    }
  }

  deleteGame() {}
}
