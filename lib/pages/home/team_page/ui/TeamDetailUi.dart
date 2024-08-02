import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Team.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_game_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/edit_team_logics.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_app/pages/home/team_page/ui/ShowAllPage.dart';
import 'package:flutter_app/pages/home/team_page/ui/TeamVsPage.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../Constants.dart';
import '../widgets/team_detail_latest_match.dart';
import '../widgets/team_detail_widgets.dart';

class TeamDetailUI extends StatefulWidget {
  final Team team;

  const TeamDetailUI({super.key, required this.team});

  @override
  State<TeamDetailUI> createState() => _TeamDetailUIState();
}

class _TeamDetailUIState extends State<TeamDetailUI> {
  late Team team;

  @override
  void initState() {
    super.initState();
    team = widget.team;
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        var data = await context.read<TeamDetailCubit>().refreshScreen();
        if (data != null) {
          setState(() {
            team = data;
          });
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.maxFinite,
          constraints: BoxConstraints(minHeight: height),
          color: const Color(blackColor2),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: height / 40,
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                      imageUrl: team.teamLogoUrl ?? "",
                      height: 150,
                      width: 150,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      team.name ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8.0, right: 8.0, bottom: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: TeamMembersContainer(
                              memberCount: team.members!.length),
                        ),
                        Container(
                          width: width / 3,
                          decoration: BoxDecoration(
                              color: team.isPrivate == true
                                  ? Colors.black
                                  : const Color(goldColor),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(15))),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: Text(
                                team.isPrivate == true ? "Qapalı" : "Açıq",
                                style: TextStyle(
                                    color: team.isPrivate == true
                                        ? const Color(goldColor)
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  team.id == getMyTeamId() && !checkLeader()
                      ? SizedBox(
                          width: width / 3,
                          child: TeamDetailButton(
                            onPressed: () {
                              //left
                              AlertDialog alert = AlertDialog(
                                title: const Text("Ayrılma"),
                                content:
                                    const Text("Komandadan ayrılmağa əminsiz?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Xeyr",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      context
                                          .read<TeamDetailCubit>()
                                          .leftTeam();
                                    },
                                    child: const Text(
                                      "Bəli",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            },
                            text: "Ayrıl",
                            backgroundColor: const Color(redColor),
                            textColor: Colors.white,
                          ),
                        )
                      : checkExistingTeam()
                          ? const SizedBox()
                          : SizedBox(
                              child: TeamDetailButton(
                                onPressed: () {
                                  //join
                                  if (team.members!.length >= 11) {
                                    showCustomSnackbar(
                                        context, "Komanda doludur");
                                  } else {
                                    context
                                        .read<TeamDetailCubit>()
                                        .joinTeam(team.id!, team.isPrivate!);
                                  }
                                },
                                text: (team.isPrivate!)
                                    ? "Sorğu göndər"
                                    : "Daxil Ol",
                                backgroundColor: (team.isPrivate!)
                                    ? const Color(goldColor)
                                    : const Color(greenColor),
                                textColor: (team.isPrivate!)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      team.description ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  TeamInformationWidget(
                      rank: team.rank,
                      division: team.division?.divisionName,
                      points: team.rating.toInt(),
                      divisionPhoto: team.division?.divisionImage),
                  team.divisionMedals!.isEmpty
                      ? const SizedBox()
                      : TeamDivisionMedalsWidget(
                          divisionMedals: team.divisionMedals),
                  (team.teamGames!.isNotEmpty)
                      ? TeamDetailLatestMatchWidget(
                          teamGame: team.teamGames![0],
                        )
                      : const SizedBox(),
                  (team.teamGames!.isNotEmpty && team.teamGames!.length > 1)
                      ? TeamDetailMatchesList(
                          id: team.id ?? "",
                          teamGame: team.teamGames
                                  ?.sublist(1, team.teamGames!.length) ??
                              [])
                      : const SizedBox(),
                  (team.teamGames!.isNotEmpty)
                      ? (team.teamGames!.length >= 3)
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TeamDetailButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ShowAllPage(
                                                  id: team.id ?? "",
                                                )));
                                  },
                                  text: "Hamısını Göstər",
                                  backgroundColor: const Color(goldColor),
                                  textColor: Colors.black),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Üzvlər",
                      style: TextStyle(color: Color(goldColor), fontSize: 18),
                    ),
                  ),
                  TeamMembersListWidget(
                    members: team.members ?? [],
                    teamCapitanUsername: team.teamCapitanUserName ?? "",
                  ),
                  (getMyTeamId() == team.id && checkLeader())
                      ? SizedBox(
                          width: 2 * width / 3,
                          child: TeamDetailButton(
                            onPressed: () {
                              AlertDialog alert = AlertDialog(
                                title: const Text("Komanda silmə"),
                                content:
                                    const Text("Komandanızı silməyə əminsiz?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Xeyr",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      context
                                          .read<TeamDetailCubit>()
                                          .deleteTeam();
                                    },
                                    child: const Text(
                                      "Bəli",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              );

                              // show the dialog
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return alert;
                                },
                              );
                            },
                            text: "Komandanı Sil",
                            backgroundColor: const Color(redColor),
                            textColor: Colors.white,
                          ),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 64,)
                ],
              ),
              (checkExistingTeam() &&
                      checkLeader() &&
                      team.teamCapitanUserName == getMyUsername())
                  ? Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          //To edit page
                          var data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BlocProvider<TeamDetailCubit>(
                                create: (BuildContext context) =>
                                    TeamDetailCubit()..startEditTeam(team),
                                child: const EditTeamLogics(),
                              ),
                            ),
                          );
                          if (data != null) {
                            context.read<TeamDetailCubit>().refresh(false);
                          }
                        },
                        child: const Icon(Icons.edit),
                      ),
                    )
                  : const SizedBox(),
              checkExistingTeam() && getMyTeamId() != team.id
                  ? Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          //To edit page
                          var data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider(
                                create: (BuildContext context) =>
                                    FinishedGamesCubit(),
                                child: TeamVsPage(
                                  teamId: team.id ?? "",
                                ),
                              ),
                            ),
                          );
                        },
                        child: Image.asset(
                          "assets/vs.png",
                          width: 32,
                          height: 32,
                        ),
                      ),
                    )
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
