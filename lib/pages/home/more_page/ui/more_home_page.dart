import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/more_page/more_cubit/more_page_cubit.dart';
import 'package:flutter_app/pages/home/more_page/ui/widget/profile_grid_item.dart';
import 'package:flutter_app/pages/home/more_page/ui/widget/team_widget.dart';
import 'package:flutter_app/pages/home/more_page/ui/widget/user_games_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../../../../network/model/User.dart';
import '../../../../widgets/text.dart';

class MorePageHome extends StatefulWidget {
  final User user;
  final int age;
  const MorePageHome(
      {super.key, required this.user, required this.age});

  @override
  State<MorePageHome> createState() => _MorePageHomeState();
}

class _MorePageHomeState extends State<MorePageHome> {
  late User user;
  late int age;

  @override
  void initState() {
    super.initState();
    user = widget.user;
    age = widget.age;
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    print(widget.user.userTeam);
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: const BoxDecoration(
          // color: Color.fromRGBO(18, 17, 17, 1),
          color: Colors.black),
      child: RefreshIndicator(
        onRefresh: () async {
          var data = await context.read<MorePageCubit>().refresh();
          if(data!=null) {
            setState(() {
              user = data.user;
              age = data.age;
            });
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
            constraints: BoxConstraints(minHeight: height),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipOval(
                          child: Image.network(
                            widget.user.profilePhotoUrl,
                            height: width / 4,
                            width: width / 4,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Shimmer.fromColors(
                                baseColor: Colors.grey.shade300,
                                highlightColor: Colors.grey.shade100,
                                enabled: true,
                                child: Container(
                                  height: width / 4,
                                  width: width / 4,
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      TextWhiteColorWidget(text: "${widget.user.name} ${widget.user.surName}"),
                      TextGrayColorWidget(text: "@${widget.user.userName}"),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                TextWhiteColorWidget(
                                    text: widget.user.seasonGoalCount.toString()),
                                const TextWhiteColorWidget(text: "Qol sayı"),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                TextWhiteColorWidget(text: widget.user.average.toString()),
                                const TextWhiteColorWidget(text: "Ortalama"),
                              ],
                            ),
                          ),
                          Container(
                            width: 1,
                            height: 30,
                            color: Colors.white,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                TextWhiteColorWidget(text: "${widget.age}"),
                                const TextWhiteColorWidget(text: "Yaş"),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          widget.user.phoneNumber != null
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProfileGridItemWidget(
                                        onPressed: () async {
                                          String url = "tel://${widget.user.phoneNumber}";
                                          if(!await launcher.launchUrl(Uri.parse(url))){
                                              debugPrint("Couldnot opened");
                                          }
                                        },
                                        icon: const Icon(Icons.phone),
                                        label: "${widget.user.phoneNumber}"),
                                  ),
                                )
                              : const SizedBox(),
                          (widget.user.roles!.length > 1)
                              ? Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ProfileGridItemWidget(
                                         onPressed: () {},
                                        icon: const Icon(Icons.people),
                                        label: "${widget.user.roles?[0]}"),
                                  ),
                                )
                              : SizedBox()
                        ],
                      ),

                      widget.user.upComingGame != null
                          ? UpcomingGameWidget(game: widget.user.upComingGame!)
                          : SizedBox(),
                      widget.user.userGames!.isNotEmpty
                          ? UserGamesWidget(games: widget.user.userGames!)
                          : SizedBox(),
                      widget.user.userTeam != null
                          ? UserTeamWidget(team: widget.user.userTeam!)
                          : SizedBox()

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
