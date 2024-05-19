import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../network/model/Team.dart';
import '../../../../network/model/User.dart';
import '../../../user/user_cubit/user_logics.dart';

class TeamMembersContainer extends StatelessWidget {
  final int memberCount;

  const TeamMembersContainer({super.key, required this.memberCount});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width / 3,
      decoration: const BoxDecoration(
          color: Color(goldColor),
          borderRadius: BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(
            "Üzvlər: $memberCount/11",
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class TeamDetailButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  const TeamDetailButton(
      {super.key,
      required this.onPressed,
      required this.text,
      required this.backgroundColor,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        backgroundColor: backgroundColor,
      ),
      child: Text(
        text,
        style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TeamInformationWidget extends StatelessWidget {
  final int? rank;
  final String? division;
  final int points;
  final String? divisionPhoto;

  const TeamInformationWidget(
      {super.key,
      required this.rank,
      required this.division,
      required this.points,
      required this.divisionPhoto});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TeamInformationSingleItem(
              topText: "Rank", informationText: "#${rank ?? 0}"),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TeamInformationPhotoSingleItem(
              topText: division ?? "", photoUrl: divisionPhoto ?? ""),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TeamInformationSingleItem(
              topText: "Reyting", informationText: points.toString()),
        )
      ],
    );
  }
}

class TeamInformationSingleItem extends StatelessWidget {
  final String topText;
  final String informationText;

  const TeamInformationSingleItem(
      {super.key, required this.topText, required this.informationText});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width / 5,
      child: Column(
        children: [
          Container(
            color: const Color(goldColor),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  topText,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
          Container(
            width: width / 4,
            height: width / 4,
            color: Colors.black,
            child: Center(
              child: Text(
                informationText,
                style: const TextStyle(
                    color: Color(goldColor),
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TeamInformationPhotoSingleItem extends StatelessWidget {
  final String topText;
  final String photoUrl;

  const TeamInformationPhotoSingleItem(
      {super.key, required this.topText, required this.photoUrl});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width / 4,
      child: Column(
        children: [
          Container(
            color: const Color(goldColor),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  topText,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
            ),
          ),
          Container(
            width: width / 4,
            height: width / 4,
            color: Colors.black,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                imageUrl: photoUrl,
                fit: BoxFit.fill,
              ),
            )),
          )
        ],
      ),
    );
  }
}

class TeamDivisionMedalsWidget extends StatelessWidget {
  final List<DivisionMedal>? divisionMedals;

  const TeamDivisionMedalsWidget({super.key, required this.divisionMedals});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        height: width / 4 + 16,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: divisionMedals?.length,
            itemBuilder: (builder, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: width / 5,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: width / 5,
                        height: width / 5,
                        color: const Color(brownColor),
                        child: Center(
                          child: Padding(
                            padding:
                                const EdgeInsets.only(top: 14.0, bottom: 14),
                            child: Image.network(
                              divisionMedals?[index].division?.divisionImage ??
                                  "",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: width / 5,
                        height: width / 20,
                        color: const Color(openBrownColor),
                        child: const Center(
                          child: Text(
                            "0",
                            style: TextStyle(
                                color: Color(brownColor),
                                fontSize: 14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class TeamMembersListWidget extends StatelessWidget {
  final List<User> members;
  final String teamCapitanUsername;

  const TeamMembersListWidget(
      {super.key, required this.members, required this.teamCapitanUsername});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: members.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            //To member profile
            if (getMyUsername() != members[index].userName) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => UserLogics(
                        username: members[index].userName ?? "")),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: members[index].profilePhotoUrl,
                          width: 50,
                          height: 50,
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            members[index].name,
                            style: const TextStyle(color: Colors.white),
                          ),
                          Text(
                            "@${members[index].userName}",
                            style: const TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          if ((teamCapitanUsername != members[index].userName &&
                              getMyUsername() == teamCapitanUsername)) {
                            AlertDialog alert = AlertDialog(
                              title: const Text(
                                  "Oyunçunu komandadan atmağa əminsiz?"),
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
                                          .throwUser(members[index].id ?? "");
                                    },
                                    child: const Text("Bəli",
                                        style: TextStyle(color: Colors.white))),
                              ],
                            );

                            // show the dialog
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return alert;
                              },
                            );
                          }
                        },
                        child: (teamCapitanUsername != members[index].userName &&
                                getMyUsername() == teamCapitanUsername)
                            ? const Icon(
                                Icons.exit_to_app,
                                color: Colors.grey,
                              )
                            : Text(
                                teamCapitanUsername == members[index].userName
                                    ? "Lider"
                                    : "       ",
                                style: const TextStyle(color: Color(goldColor)),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
