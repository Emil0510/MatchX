import 'package:flutter/material.dart';
import '../../../network/model/User.dart';
import '../../../widgets/text.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import '../home/more_page/ui/widget/profile_grid_item.dart';
import '../home/more_page/ui/widget/team_widget.dart';
import '../home/more_page/ui/widget/user_games_widget.dart';



class UserDetailPage extends StatelessWidget {
  final User user;
  final int age;
  const UserDetailPage({super.key, required this.user, required this.age});

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
      child: SingleChildScrollView(
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
                        "${user.profilePhotoUrl}",
                        height: width / 4,
                        width: width / 4,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextWhiteColorWidget(text: "${user.name} ${user.surName}"),
                  TextGrayColorWidget(text: "@${user.userName}"),
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
                                text: user.seasonGoalCount.toString()),
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
                            TextWhiteColorWidget(text: user.average.toString()),
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
                            TextWhiteColorWidget(text: "$age"),
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
                      user.phoneNumber != null
                          ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProfileGridItemWidget(
                              onPressed: () async {
                                String url = "tel://${user.phoneNumber}";
                                if(!await launcher.launchUrl(Uri.parse(url))){
                                  debugPrint("Couldnot opened");
                                }
                              },
                              icon: const Icon(Icons.phone),
                              label: "${user.phoneNumber}"),
                        ),
                      )
                          : const SizedBox(),
                      (user.roles!.length > 1)
                          ? Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ProfileGridItemWidget(
                              onPressed: () {},
                              icon: const Icon(Icons.people),
                              label: "${user.roles?[0]}"),
                        ),
                      )
                          : SizedBox()
                    ],
                  ),
                  user.upComingGame != null
                      ? UpcomingGameWidget(game: user.upComingGame!)
                      : SizedBox(),
                  user.userGames!.isNotEmpty
                      ? UserGamesWidget(games: user.userGames!)
                      : SizedBox(),
                  user.userTeam != null
                      ? UserTeamWidget(team: user.userTeam!)
                      : SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
