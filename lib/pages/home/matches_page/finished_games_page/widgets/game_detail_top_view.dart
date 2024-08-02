import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Game.dart';

class GameDetailTopView extends StatelessWidget {
  final TeamGame game;

  const GameDetailTopView({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: game.homeTeamImageUrl ?? "",
                width: width / 5,
                height: width / 5,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              game.homeTeamName ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              getGameDate(game.gameDate ?? ""),
            ),
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      "${game.homeTeamGoal ?? ""}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 35),
                    ),
                    game.homeTeamPointChange != null
                        ? Text(
                            "${game.homeTeamPointChange! > 0 ? "+" : game.homeTeamPointChange! < 0 ? "-" : ""}${game.homeTeamPointChange ?? ""}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                                color: game.homeTeamPointChange! > 0
                                    ? const Color(greenColor)
                                    : game.homeTeamPointChange! < 0
                                        ? const Color(redColor)
                                        : Colors.white),
                          )
                        : const SizedBox(),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(
                    "-",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 35),
                  ),
                ),
                Column(
                  children: [
                    Text(
                      "${game.awayTeamGoal ?? ""}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w900, fontSize: 35),
                    ),
                    game.awayTeamPointChange != null
                        ? Text(
                            "${game.awayTeamPointChange! > 0 ? "+" : game.awayTeamPointChange! < 0 ? "-" : ""}${game.awayTeamPointChange ?? ""}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 25,
                                color: game.awayTeamPointChange! > 0
                                    ? const Color(greenColor)
                                    : game.awayTeamPointChange! < 0
                                        ? const Color(redColor)
                                        : Colors.white),
                          )
                        : const SizedBox(),
                  ],
                ),
              ],
            ),
            Text(getGameLeftTime(game.gameDate ?? "")),
          ],
        ),
        Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: game.awayTeamImageUrl ?? "",
                width: width / 5,
                height: width / 5,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              game.awayTeamName ?? "",
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            )
          ],
        ),
      ],
    );
  }
}
