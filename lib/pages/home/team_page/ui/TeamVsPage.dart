import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/widgets/FinishedGamesItem.dart';
import 'package:flutter_app/pages/home/team_page/widgets/team_detail_latest_match.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Game.dart';
import '../../../../widgets/infinity_scroll_loading.dart';

class TeamVsPage extends StatefulWidget {
  final String teamId;

  const TeamVsPage({super.key, required this.teamId});

  @override
  State<TeamVsPage> createState() => _TeamVsPageState();
}

class _TeamVsPageState extends State<TeamVsPage> {
  List<TeamGame> games = [];
  int page = 1;
  bool isEnd = false;
  ScrollController scrollController = ScrollController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    requestVsGames();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
              scrollController.offset &&
          !isEnd) {
        //Fetch Data
        page++;
        requestVsGames();
      }
    });
  }

  Future<void> requestVsGames() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(
        baseUrl + getVsGames,
        queryParameters: {"id": widget.teamId, "page": page},
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        if (isLoading) {
          setState(() {
            isLoading = false;
          });
        }
        var list = (response.data["data"] as List)
            .map((e) => TeamGame.fromJson(e))
            .toList();
        if (list.isEmpty) {
          setState(() {
            isEnd = true;
          });
          return;
        } else {
          setState(() {
            if (page == 1) {
              games = [];
              games.addAll(list);
            } else {
              games.addAll(list);
            }
          });
        }
      } else {
        showCustomSnackbar(context, response.data["message"]);
      }
    } on DioException catch (e) {
      showCustomSnackbar(context, e.response?.data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Komanda oyunları",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          page = 1;
          await requestVsGames();
        },
        child: Container(
          constraints: BoxConstraints(minHeight: height, minWidth: width),
          decoration: const BoxDecoration(color: Colors.black),
          child: isLoading
              ? const CircularLoadingWidget()
              : games.isEmpty
                  ? const Center(
                      child: Text(
                        "Bu komandayla oyununuz yoxdur 😓",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: (games.length % 10 == 0 && games.isNotEmpty)
                          ? games.length + 1
                          : games.length,
                      itemBuilder: (context, index) {
                        if (index < games.length) {
                          return (games[index].isVerificated ?? false)
                              ? TeamFinishedGameWidget(
                                  game: games[index],
                                  backgroundColor: const Color(blackColor2),
                                )
                              : FinishedGamesItem(myGame: games[index]);
                        } else {
                          if (isEnd) {
                            return const SizedBox();
                          } else {
                            return const InfinityScrollLoading();
                          }
                        }
                      },
                    ),
        ),
      ),
    );
  }
}
