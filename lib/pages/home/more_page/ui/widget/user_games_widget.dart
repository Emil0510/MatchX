import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/home/team_page/widgets/team_detail_latest_match.dart';
import '../../../../../network/model/Game.dart';

class UpcomingGameWidget extends StatelessWidget {
  final TeamGame game;

  const UpcomingGameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Qarşıdan gələn oyun",
            style: TextStyle(color: Color(goldColor), fontSize: 18),
          ),
        ),
        SingleGameWidget(game: game)
      ],
    );
  }
}

class SingleGameWidget extends StatelessWidget {
  final TeamGame game;

  const SingleGameWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
            color: const Color(blackColor2),
            borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                game.homeTeamImageUrl ?? "",
                width: width / 10,
                height: width / 10,
              ),
            ),
            Text(game.homeTeamName ?? "", style: const TextStyle(color: Color(goldColor)),),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                getGameDate(game.gameDate ?? ""),
                textAlign: TextAlign.center,
              ),
            )),
            Text(game.awayTeamName ?? "", style: const TextStyle(color: Color(goldColor))),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.network(
                game.awayTeamImageUrl ?? "",
                width: width / 10,
                height: width / 10,
              ),
            ),
          ],
        ));
  }
}

class UserGamesWidget extends StatelessWidget {
  final List<TeamGame> games;

  const UserGamesWidget({super.key, required this.games});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height / 50,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Bitmiş oyunlar",
            style: TextStyle(color: Color(goldColor), fontSize: 18),
          ),
        ),
        ListView.builder(
          itemCount: games.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            return TeamFinishedGameWidget(game: games[index]);
          },
        )
      ],
    );
  }
}
