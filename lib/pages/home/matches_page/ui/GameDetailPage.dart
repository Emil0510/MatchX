import "package:flutter/material.dart";
import "package:flutter_app/Utils.dart";
import "package:flutter_app/pages/home/matches_page/mathches_cubit/matches_cubit.dart";
import "package:flutter_app/pages/home/team_page/widgets/team_detail_latest_match.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "../../../../Constants.dart";
import "../../../../network/model/Game.dart";
import "../../team_page/team_detail_cubit/team_detail_cubit.dart";
import "../../team_page/ui/TeamDetailPage.dart";

class GameDetailPage extends StatefulWidget {
  final TeamGame teamGame;
  final bool isFromLink;
  final String guide;

  const GameDetailPage(
      {super.key,
      required this.teamGame,
      required this.isFromLink,
      required this.guide});

  @override
  State<GameDetailPage> createState() => _GameDetailPageState();
}

class _GameDetailPageState extends State<GameDetailPage> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var selectedDate = DateTime.parse(widget.teamGame.gameDate ?? "");

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: height / 50,
        ),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Align(
            child: Text(
              "Oyun Detalı",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {},
            child: TeamNameWidget(
                photoUrl: widget.teamGame.homeTeamImageUrl ?? "",
                teamName: widget.teamGame.homeTeamName ?? ""),
          ),
        ),
        SizedBox(
          height: height / 30,
        ),
        SizedBox(
          width: width * 2 / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: widget.teamGame.isRated!
                    ? const Color(goldColor)
                    : Colors.black),
            onPressed: () {},
            child: Center(
              child: Text(
                widget.teamGame.isRated! ? "Reytinglidir" : "Reytingsizdir",
                style: TextStyle(
                    color: widget.teamGame.isRated!
                        ? Colors.black
                        : const Color(goldColor),
                    fontSize: 18),
              ),
            ),
          ),
        ),
        Container(
          width: width * 2 / 3,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black38, // Shadow color
                offset: Offset(0, 4), // Offset of the shadow (x, y)
                blurRadius: 6, // Spread of the shadow
                spreadRadius: 0, // Expansion of the shadow
              ),
            ],
          ),
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(goldColor)),
            child: Text(
              "Tarix: ${"${selectedDate.toLocal()}".split(' ')[0]} ${selectedDate.hour}:00",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        SizedBox(
          width: width * 2 / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {},
            child: Center(
              child: Text(
                "Mesaj: ${widget.teamGame.message ?? "Yoxdur"}",
                style: const TextStyle(color: Color(goldColor), fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        SizedBox(
          width: width * 2 / 3,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
            onPressed: () {},
            child: Center(
              child: Text(
                "Region: ${regionsConstants[widget.teamGame.region ?? 0]}",
                style: const TextStyle(color: Color(goldColor), fontSize: 18),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        SizedBox(
          height: height / 20,
        ),
        checkLeader()
            ? ElevatedButton(
                onPressed: () {
                  if (!isLoading) {
                    setState(() {
                      isLoading = true;
                    });
                    if (widget.isFromLink) {
                      context
                          .read<MatchesCubit>()
                          .joinLinkGame(context, widget.guide);
                    } else {
                      print("Normal Join");
                      context
                          .read<MatchesCubit>()
                          .joinGame(context, widget.teamGame.id!);
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(goldColor)),
                child: isLoading
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          color: Colors.black,
                        ),
                      )
                    : const Text(
                        "Oyuna qoşul",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
              )
            : const SizedBox(),
        SizedBox(
          height: height / 20,
        ),
      ],
    );
  }
}
