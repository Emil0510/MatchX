import 'package:flutter/material.dart';
import 'package:flutter_app/pages/user/user_cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../network/model/User.dart';
import '../../../widgets/text.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../home/more_page/ui/widget/profile_grid_item.dart';
import '../home/more_page/ui/widget/team_widget.dart';
import '../home/more_page/ui/widget/user_games_widget.dart';

class UserDetailPage extends StatefulWidget {
  final User user;
  final int age;

  const UserDetailPage({super.key, required this.user, required this.age});

  @override
  State<UserDetailPage> createState() => _UserDetailPageState();
}

class _UserDetailPageState extends State<UserDetailPage> {
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
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      height: double.maxFinite,
      width: double.maxFinite,
      decoration: const BoxDecoration(
          // color: Color.fromRGBO(18, 17, 17, 1),
          color: Colors.black),
      child: RefreshIndicator(
        onRefresh: () async {
          var data = await context.read<UserCubit>().refresh();
          if (data != null) {
            setState(() {
              user = data.user;
              age = data.age;
            });
          }
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                          "${widget.user.profilePhotoUrl}",
                          height: width / 4,
                          width: width / 4,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    TextWhiteColorWidget(
                        text: "${widget.user.name} ${widget.user.surName}"),
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
                              TextWhiteColorWidget(
                                  text: widget.user.average.toString()),
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
                                        String url =
                                            "tel://${widget.user.phoneNumber}";
                                        if (!await launcher
                                            .launchUrl(Uri.parse(url))) {
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
    );
  }
}
