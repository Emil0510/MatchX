import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Game.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/create_match_page.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_game_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_states.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/ui/FinishedGamesPage.dart';
import 'package:flutter_app/pages/home/matches_page/ui/GameDetailPage.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../network/network.dart';
import '../create_match_page/create_match_cubit/create_match_cubit.dart';
import '../create_match_page/ui/JoinToMatchWithLink.dart';

class MatchesCubit extends Cubit<MatchesStates> {
  MatchesCubit() : super(MatchesInitialState());

  int selectedId = 7;

  start() {
    emit(MatchesLoadingState());
    getAll();
  }

  void getAll() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + getAllGameApi,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        List<TeamGame>? games = (response.data['data'] as List?)
            ?.map((e) => TeamGame.fromJson(e))
            .toList();

        print(games);
        emit(MatchesPageState(games: games, selectedId: 0));
      }
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  void getSelectedRegionGames(int selectedRegion) async {
    emit(MatchesLoadingState());
    selectedId = selectedRegion;
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + getAllGameApi,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
        queryParameters: {"area": selectedId == -1 ? null : selectedId},
      );

      if (response.statusCode == 200) {
        List<TeamGame>? games = (response.data['data'] as List?)
            ?.map((e) => TeamGame.fromJson(e))
            .toList();

        print(games);

        emit(MatchesPageState(games: games, selectedId: selectedId + 1));
      }
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  void toCreateMatch(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (innerContext) {
        // Return your bottom sheet content here
        return BlocProvider<CreateMatchCubit>(
          create: (BuildContext context) => CreateMatchCubit()..start(),
          child: const CreateMatchPage(),
        );
      },
    );
  }

  void toFinishedGames(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider<FinishedGamesCubit>(
          create: (BuildContext context) => FinishedGamesCubit()..start(),
          child: const FinishedGamesPage(),
        ),
      ),
    );
  }

  void toJoinWithLinkPage(BuildContext context) {
    var cubit = context.read<MatchesCubit>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (innerContext) {
        // Return your bottom sheet content here
        return BlocProvider<MatchesCubit>(
          create: (BuildContext context) => cubit,
          child: JoinToMatchWithLink(
            function: toGameDetail,
          ),
        );
      },
    );
  }

  void toGameDetail(
      TeamGame teamGame, BuildContext context, bool isFromLink, String guide) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (innerContext) {
        return BlocProvider<MatchesCubit>(
          create: (innerContext) => MatchesCubit(),
          child: GameDetailPage(
            teamGame: teamGame,
            isFromLink: isFromLink,
            guide: guide,
          ),
        );
      },
    );
  }

  void joinLinkGame(BuildContext context, String guide) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      Map<String, dynamic> body = {"linkGuid": guide};
      var response = await dio.post(baseUrl + guideLinkApi,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: body);

      if (response.statusCode == 200) {
        Navigator.pop(context);
        showCustomSnackbar(context, "Oyun qəbul edildi");
      } else {
        Navigator.pop(context);
        showCustomSnackbar(context, "Səhvlik");
      }
    } on DioException catch (e) {
      print(e.response?.data);
      Navigator.pop(context);
      showCustomSnackbar(context, e.response?.data['message']);
    }
  }

  void joinGame(BuildContext context, String id) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    // try {
    Map<String, dynamic> body = {"id": id};
    print(id);

    try {
      var response = await dio.post(
        baseUrl + findPairApi + "/" + id,
        options: Options(
          headers: {
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        showCustomSnackbar(context, "Oyun qəbul edildi");
      } else {
        Navigator.pop(context);
        showCustomSnackbar(context, "Səhvlik");
      }
    } on DioException catch (e) {
      print(e);
      Navigator.pop(context);
      showCustomSnackbar(context, "Səhvlik");
    }

    // } on DioException catch (e) {
    //   Navigator.pop(context);
    //   print("Response: ${e.response?.data.toString()}");
    //   showCustomSnackbar(context, "Oyunu qəbul etmək mümkün deil!");
    // }
  }

  void viewTeam(BuildContext context, int teamId) {}

  void toCreateWithLinkPage(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (innerContext) {
        // Return your bottom sheet content here
        return BlocProvider<CreateMatchCubit>(
          create: (BuildContext context) =>
              CreateMatchCubit()..startCreateWithLink(),
          child: const CreateMatchPage(),
        );
      },
    );
  }
}
