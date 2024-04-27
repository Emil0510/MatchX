import 'package:flutter/material.dart';

import '../../../../../Constants.dart';
import '../../../../../network/model/Team.dart';

class UserTeamWidget extends StatelessWidget {
  final Team team;

  const UserTeamWidget({super.key, required this.team});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            "Komanda",
            style: TextStyle(color: Color(goldColor), fontSize: 18),
          ),
        ),
        Container(
          width: width,
          decoration: BoxDecoration(
              color: Color(blackColor2),
              borderRadius: BorderRadius.circular(8)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.network(
                  team.teamLogoUrl ?? "",
                  width: width / 4,
                  height: width / 4,
                ),
              ),
              Text(
                team.name ?? "",
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  team.description ?? "",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: const Color(blackColor3),
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Reyting: ${team.rating.toString()}",
                      style: const TextStyle(color: Color(goldColor)),
                    ),
                  ),
                ),
              ),
              TeamResultWidget(resultName: "Oyun sayı", resultCount: ((team.victory??0) + (team.fail??0) + (team.draw??0)), resultColor: const Color(goldColor),),
              TeamResultWidget(resultName: "Qələbə", resultCount: team.victory??0, resultColor: const Color(greenColor),),
              TeamResultWidget(resultName: "Məğlubiyyət", resultCount: team.fail??0, resultColor: const Color(redColor),),
              TeamResultWidget(resultName: "Heç-heçə", resultCount: team.draw??0, resultColor: Color(goldColor),),
            ],
          ),
        )
      ],
    );
  }
}

class TeamResultWidget extends StatelessWidget {
  final String resultName;
  final int resultCount;
  final Color resultColor;

  const TeamResultWidget(
      {super.key, required this.resultName, required this.resultCount, required this.resultColor});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Color(blackColor3),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text(resultName, style: TextStyle(fontSize: 18),),
              ),
              Padding(
                padding:  EdgeInsets.only(right: width/10),
                child: Text(
                  resultCount.toString(),
                  style:  TextStyle(color: resultColor, fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
