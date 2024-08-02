import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/network/model/Game.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/widgets/game_detail_top_view.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/widgets/game_staff_view.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Constants.dart';

class ScheduledGameDetail extends StatefulWidget {
  final String gameId;

  const ScheduledGameDetail({super.key, required this.gameId});

  @override
  State<ScheduledGameDetail> createState() => _ScheduledGameDetailState();
}

class _ScheduledGameDetailState extends State<ScheduledGameDetail> {
  late TeamGame game;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getGame();
  }

  Future<void> getGame() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);
    try {
      var response = await dio.get(
        baseUrl + getGameDetails,
        options: Options(headers: {"Authorization": "Bearer $token"}),
        queryParameters: {"id": widget.gameId},
      );

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          game = TeamGame.fromJson(response.data["data"]);
        });
      } else {
        showCustomSnackbar(context, response.data["message"]);
      }
    } on DioException catch (e) {
      showCustomSnackbar(context, e.response?.data["message"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Oyun detalı",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: isLoading
          ? const CircularLoadingWidget()
          : Container(
              constraints: BoxConstraints(minWidth: width, minHeight: height),
              decoration: const BoxDecoration(color: Colors.black),
              child: RefreshIndicator(
                onRefresh: () async{
                  await getGame();
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      const SizedBox(height: 16,),
                      GameDetailTopView(
                        game: game,
                      ),
                      const SizedBox(height: 16,),
                      Container(
                        color: const Color(blackColor3),
                        width: width,
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              "Oyunçular",
                              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16,),
                      GameStaffView(game: game)
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
