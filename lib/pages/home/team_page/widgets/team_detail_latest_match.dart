import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Game.dart';
import 'package:flutter_app/widgets/infinity_scroll_loading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../network/network.dart';
import '../../matches_page/finished_games_page/ui/ScheduledGameDetailPage.dart';

class TeamDetailLatestMatchWidget extends StatelessWidget {
  final TeamGame teamGame;

  const TeamDetailLatestMatchWidget({super.key, required this.teamGame});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(clipBehavior: Clip.none, children: [
        Column(
          children: [
            SizedBox(
              height: height / 45,
            ),
            Container(
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TeamNameWidget(
                          photoUrl: teamGame.homeTeamImageUrl ?? "",
                          teamName: teamGame.homeTeamName ?? ""),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TeamResultGoalsWidget(
                          homeTeamRating: teamGame.homeTeamRating ?? 0.0,
                          awayTeamRating: teamGame.awayTeamRating ?? 0.0,
                          homeTeamChange: teamGame.homeTeamPointChange ?? 0,
                          awayTeamChange: teamGame.awayTeamPointChange ?? 0,
                          homeTeamGoalCount: teamGame.homeTeamGoal ?? 0,
                          awayTeamGoalCount: teamGame.awayTeamGoal ?? 0),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TeamNameWidget(
                          photoUrl: teamGame.awayTeamImageUrl ?? "",
                          teamName: teamGame.awayTeamName ?? ""),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.maxFinite,
              color: const Color(goldColor),
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  getGameDate(teamGame.gameDate ?? ""),
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              )),
            )
          ],
        ),
        Positioned(
          top: -8,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              height: height / 28,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(goldColor),
              ),
              child: const Padding(
                padding: EdgeInsets.all(2.0),
                child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: Text(
                    "Sonuncu Matç",
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class TeamNameWidget extends StatelessWidget {
  final String photoUrl;
  final String teamName;

  const TeamNameWidget(
      {super.key, required this.photoUrl, required this.teamName});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: CachedNetworkImage(
            imageUrl: photoUrl,
            width: width / 5,
            height: width / 5,
            fit: BoxFit.cover,
            placeholder: (context, url) => Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              enabled: true,
              child: Container(
                width: width * 4 / 5,
                height: width * 4 / 5,
                color: Colors.black54,
              ),
            ),
          ),
        ),
        Center(
          child: Text(
            teamName,
            style: const TextStyle(
                color: Color(goldColor), fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}

class TeamResultGoalsWidget extends StatelessWidget {
  final double homeTeamRating;
  final double awayTeamRating;
  final int homeTeamChange;
  final int awayTeamChange;
  final int homeTeamGoalCount;
  final int awayTeamGoalCount;

  const TeamResultGoalsWidget(
      {super.key,
      required this.homeTeamRating,
      required this.awayTeamRating,
      required this.homeTeamChange,
      required this.awayTeamChange,
      required this.homeTeamGoalCount,
      required this.awayTeamGoalCount});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(grayColor2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  homeTeamGoalCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "-",
                style: TextStyle(
                    color: Color(goldColor),
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Color(grayColor2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  awayTeamGoalCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          ],
        ),
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: TextSpan(
                    text: "${homeTeamRating.toString()}\n",
                    style: const TextStyle(color: Colors.white, fontSize: 13),
                    children: [
                      TextSpan(
                          text:
                              "(${homeTeamChange > 0 ? "+$homeTeamChange" : homeTeamChange.toString()})",
                          style: TextStyle(
                              fontSize: 13,
                              color: homeTeamChange == 0
                                  ? Colors.white
                                  : homeTeamChange > 0
                                      ? const Color(greenColor)
                                      : const Color(redColor)))
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: RichText(
                  text: TextSpan(
                      text: "${awayTeamRating.toString()}\n",
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      children: [
                        TextSpan(
                            text:
                                "(${awayTeamChange > 0 ? "+$awayTeamChange" : awayTeamChange.toString()})",
                            style: TextStyle(
                                fontSize: 13,
                                color: awayTeamChange == 0
                                    ? Colors.white
                                    : awayTeamChange > 0
                                        ? const Color(greenColor)
                                        : const Color(redColor)))
                      ]),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class TeamDetailMatchesList extends StatefulWidget {
  final List<TeamGame> teamGame;
  final String id;

  const TeamDetailMatchesList(
      {super.key, required this.teamGame, required this.id});

  @override
  State<TeamDetailMatchesList> createState() => _TeamDetailMatchesListState();
}

class _TeamDetailMatchesListState extends State<TeamDetailMatchesList> {
  late List<TeamGame> games;
  var page = 1;
  var controller = ScrollController();
  var isEnd = false;

  @override
  void initState() {
    super.initState();
    games = widget.teamGame;
    controller.addListener(() async {
      if (controller.position.maxScrollExtent == controller.offset && !isEnd) {
        //Fetch Data
        page++;
        getAllGames();
      }
    });
  }

  void getAllGames() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + seeMoreApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          queryParameters: {"id": widget.id, "page": page});

      if (response.statusCode == 200) {
        var list = (response.data['data']['games'] as List)
            .map((e) => TeamGame.fromJson(e))
            .toList();
        if (list.isEmpty) {
          setState(() {
            isEnd = true;
          });
          return;
        }
        setState(() {
          games.addAll(list);
        });
      }
    } on DioException catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: controller,
      padding: EdgeInsets.zero,
      itemCount: games.length % 10 == 0 && games.isNotEmpty
          ? games.length + 1
          : games.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index < games.length) {
          return TeamFinishedGameWidget(game: games[index]);
        } else {
          if (isEnd) {
            return const SizedBox();
          } else {
            return const InfinityScrollLoading();
          }
        }
      },
    );
  }
}

class TeamFinishedGameWidget extends StatelessWidget {
  final TeamGame game;
  final Color? backgroundColor;
  const TeamFinishedGameWidget({super.key, required this.game, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ScheduledGameDetail(
              gameId: game.id ?? "",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              color: backgroundColor ?? const Color(blackColor3),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      CachedNetworkImage(
                        imageUrl: game.homeTeamImageUrl ?? "",
                        width: width / 8,
                        height: width / 8,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Container(
                            width: width * 4 / 5,
                            height: width * 4 / 5,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                game.homeTeamName ?? "",
                                style: const TextStyle(color: Color(goldColor)),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: game.homeTeamRating.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text:
                                          " (${game.homeTeamPointChange.toString()})",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: game.homeTeamPointChange == 0
                                            ? Colors.white
                                            : (game.homeTeamPointChange??0) > 0
                                                ? const Color(greenColor)
                                                : const Color(redColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      "${game.homeTeamGoal}-${game.awayTeamGoal}",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            children: [
                              Text(
                                textAlign: TextAlign.center,
                                game.awayTeamName!,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Color(goldColor)),
                              ),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: game.awayTeamRating.toString(),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 13),
                                  children: [
                                    TextSpan(
                                      text:
                                          " (${game.awayTeamPointChange.toString()})",
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: game.awayTeamPointChange == 0
                                            ? Colors.white
                                            : (game.awayTeamPointChange??0) > 0
                                                ? const Color(greenColor)
                                                : const Color(redColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      CachedNetworkImage(
                        imageUrl: game.awayTeamImageUrl ?? "",
                        width: width / 8,
                        height: width / 8,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: Container(
                            width: width * 4 / 5,
                            height: width * 4 / 5,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
