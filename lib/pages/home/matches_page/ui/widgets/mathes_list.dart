import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Game.dart';
import 'package:flutter_app/pages/home/matches_page/ui/widgets/text.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';

class MatchesListItem extends StatelessWidget {
  final TeamGame teamGame;
  const MatchesListItem({super.key, required this.teamGame});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(blackColor2), borderRadius: BorderRadius.circular(10)),
        child:  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Padding(
                padding: EdgeInsets.all(8.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: TeamLogoName(teamLogoUrl: teamGame.homeTeamImageUrl??"", name: teamGame.homeTeamName??"",)),
              ),
              SizedBox(
                width: width/4,
                child: Text(
                    getGameDate(teamGame.gameDate ?? ""),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ),

              Padding(
                padding: EdgeInsets.all(8.0),
                child: MatchesText(text: teamGame.homeTeamRating.toString()),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TeamLogoName extends StatelessWidget {
  final String name;
  final String teamLogoUrl;
  const TeamLogoName({super.key, required this.name, required this.teamLogoUrl});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.network(teamLogoUrl, height: width/10, width: width/10,),
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              name,
              style: const TextStyle(color: Colors.white,  fontSize: 16 ),
            ),
          ),
        )
      ],
    );
  }
}