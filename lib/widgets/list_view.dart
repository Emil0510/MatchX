import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Team.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_cubit.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../Constants.dart';
import '../pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import '../pages/home/team_page/ui/TeamDetailPage.dart';

class TeamListItem extends StatefulWidget {
  final Team team;

  const TeamListItem({super.key, required this.team});

  @override
  State<TeamListItem> createState() => _TeamListItemState();
}

class _TeamListItemState extends State<TeamListItem> {
  void sendRequest(bool isSucessful, String message) {
    //Send request
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8),
      child: Center(
        child: Card(
          color: const Color(blackColor2),
          child: GestureDetector(
            onTap: () async {
              var data = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BlocProvider(
                    create: (context) =>
                        TeamDetailCubit()..startTeamDetail(widget.team.id!),
                    child: TeamDetailPage(teamName: widget.team.name ?? ""),
                  ),
                ),
              );

              if (data != null) {
                context.read<TeamCubit>().isLoaded = false;
                context.read<TeamCubit>().start();
              }
            },
            child: ListTile(
              leading: CachedNetworkImage(
                imageUrl: widget.team.teamLogoUrl ?? "",
                height: width / 8,
                width: width / 8,
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
              title: Text(
                widget.team.name ?? "",
                textAlign: TextAlign.center,
                style: const TextStyle(color: Color(goldColor)),
              ),
              trailing: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 8,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Üzvlər",
                        style: TextStyle(color: Color(goldColor), fontSize: 14),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          // color: const Color(0xFF1C1918),
                          color: const Color(blackColor3),
                          borderRadius: BorderRadius.circular(
                              8.0), // Set the border radius here
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "${widget.team.memberCount}/11",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  checkExistingTeam() || widget.team.members?.length == 8
                      ? const SizedBox()
                      : GestureDetector(
                          onTap: () {
                            if (isLoading == false) {
                              if (widget.team.memberCount! >= 11) {
                                showCustomSnackbar(context, "Komanda doludur");
                              } else {
                                setState(() {
                                  isLoading = true;
                                });
                                context.read<TeamCubit>().joinTeam(
                                    widget.team.id!, widget.team.isPrivate!,
                                    (isSucessful, message) {
                                  setState(() {
                                    isLoading = false;
                                  });
                                  showCustomSnackbar(context, message);
                                });
                              }
                            }
                          },
                          child: Container(
                            width: 0.25 * width,
                            decoration: BoxDecoration(
                              color: widget.team.isPrivate!
                                  ? const Color(goldColor)
                                  : const Color(greenColor),
                              borderRadius: BorderRadius.circular(
                                  8.0), // Set the border radius here
                            ),
                            child: isLoading
                                ? Center(
                                    child: Transform.scale(
                                      scale: 0.8,
                                      child: const CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : widget.team.isPrivate!
                                    ? const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "Sorğu göndər",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      )
                                    : const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Center(
                                          child: Text(
                                            "Daxil Ol",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                      ),
                          ),
                        ),
                ],
              ),
              // You can add more widgets here based on your item layout
            ),
          ),
        ),
      ),
    );
  }
}
