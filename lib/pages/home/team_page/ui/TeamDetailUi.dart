import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Team.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/edit_team_logics.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_app/pages/home/team_page/ui/ShowAllPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      onRefresh: () async{
        var data = await context.read<TeamDetailCubit>().refreshScreen();
        if(data!=null) {
          setState(() {
            team = data;
          });
        }
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Container(
          width: double.maxFinite,
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
                    child: Image.network(
                      widget.team.teamLogoUrl ?? "",
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.team.name ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                    child:
                        TeamMembersContainer(memberCount: widget.team.members!.length),
                  ),
                  widget.team.id == getMyTeamId() && !checkLeader()
                      ? SizedBox(
                          width: width / 3,
                          child: TeamDetailButton(
                            onPressed: () {
                              //left
                              context.read<TeamDetailCubit>().leftTeam();
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
                                  context
                                      .read<TeamDetailCubit>()
                                      .joinTeam(widget.team.id!, widget.team.isPrivate!);
                                },
                                text: (widget.team.isPrivate!)
                                    ? "Sorğu göndər"
                                    : "Daxil Ol",
                                backgroundColor: (widget.team.isPrivate!)
                                    ? const Color(goldColor)
                                    : const Color(greenColor),
                                textColor: (widget.team.isPrivate!)
                                    ? Colors.black
                                    : Colors.white,
                              ),
                            ),
                  // Padding(
                  //   padding: const EdgeInsets.all(8.0),
                  //   child: Text(
                  //     team.name,
                  //     style: const TextStyle(
                  //         color: Color(goldColor),
                  //         fontSize: 20,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.team.description ?? "",
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  // Container(
                  //   width: width / 3,
                  //   decoration: const BoxDecoration(
                  //       color: Colors.black,
                  //       borderRadius: BorderRadius.all(Radius.circular(30))),
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Center(
                  //       child: Text(
                  //         state.team.isPrivate ? "Private" : "Public",
                  //         style: const TextStyle(
                  //             color: true ? Color(goldColor) : Colors.black,
                  //             fontSize: 18),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  TeamInformationWidget(
                      rank: widget.team.rank,
                      division: widget.team.division?.divisionName,
                      points: widget.team.rating.toInt(),
                      divisionPhoto: widget.team.division?.divisionImage),
                  widget.team.divisionMedals!.isEmpty
                      ? const SizedBox()
                      : TeamDivisionMedalsWidget(
                          divisionMedals: widget.team.divisionMedals),

                  (widget.team.teamGames!.isNotEmpty)
                      ? TeamDetailLatestMatchWidget(
                          teamGame: widget.team.teamGames![0],
                        )
                      : const SizedBox(),

                  (widget.team.teamGames!.isNotEmpty && widget.team.teamGames!.length > 1)
                      ? TeamDetailMatchesList(
                          teamGame: widget.team.teamGames
                                  ?.sublist(1, widget.team.teamGames!.length) ??
                              [])
                      : const SizedBox(),

                  (widget.team.teamGames!.isNotEmpty)
                      ? (widget.team.teamGames!.length >= 3)
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: TeamDetailButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                ShowAllPage(
                                                  id: widget.team.id ?? "",
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
                    members: widget.team.members ?? [],
                    teamCapitanUsername: widget.team.teamCapitanUserName ?? "",
                  ),
                  (getMyTeamId() == widget.team.id && checkLeader())
                      ? SizedBox(
                          width: 2 * width / 3,
                          child: TeamDetailButton(
                            onPressed: () {
                              //left
                              context.read<TeamDetailCubit>().deleteTeam();
                            },
                            text: "Komandanı Sil",
                            backgroundColor: const Color(redColor),
                            textColor: Colors.white,
                          ),
                        )
                      : const SizedBox()
                ],
              ),
              (checkExistingTeam() && checkLeader() && widget.team.teamCapitanUserName == getMyUsername())
                  ? Positioned(
                      top: 10,
                      right: 10,
                      child: GestureDetector(
                        onTap: () async {
                          //To edit page
                          var data = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BlocProvider<TeamDetailCubit>(
                                create: (BuildContext context) =>
                                    TeamDetailCubit()..startEditTeam(widget.team),
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
                  : const SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
