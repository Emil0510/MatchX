import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Team.dart';
import 'package:flutter_app/pages/home/home_page/widgets/last_3_games_widget.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../network/model/User.dart';

class Top10UserSingleItem extends StatelessWidget {
  final User user;
  final int index;

  const Top10UserSingleItem(
      {super.key, required this.user, required this.index});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(blackColor2),
            borderRadius: BorderRadius.circular(5)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TopListContainer(
                  color: const Color(blackColor3),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text((index + 1).toString(), maxLines: 1,style: const TextStyle(fontSize: 12),)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 18,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TopListContainer(
                  color: const Color(blackColor2),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${user.name} ${user.surName}",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    user.goalCount.toString(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TopListContainer(
                  color: const Color(goldColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        user.average.toString(),
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Top10TeamSingleItem extends StatelessWidget {
  final Team team;
  final int index;

  const Top10TeamSingleItem(
      {super.key, required this.team, required this.index});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(blackColor2),
            borderRadius: BorderRadius.circular(5)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 3,
                child: TopListContainer(
                  color: const Color(blackColor3),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: index==0 ? Image.asset("assets/first.png", fit: BoxFit.contain,width: width/12, height: width/12,) : index==1?Image.asset("assets/second.png", fit: BoxFit.contain,width: width/12, height: width/12,) :index==2? Image.asset("assets/third.png", fit: BoxFit.contain,width: width/12, height: width/12,): Text((index + 1).toString(), style: const TextStyle(fontSize: 12),)),
                  ),
                ),
              ),
              Expanded(
                flex: 15,
                child: Padding(
                  padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CachedNetworkImage(
                            imageUrl: team.teamLogoUrl ?? "",
                            height: width / 10,
                            width: width / 10,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Shimmer.fromColors(
                              baseColor: Colors.grey.shade300,
                              highlightColor: Colors.grey.shade100,
                              enabled: true,
                              child: Container(
                                width: width*4/5,
                                height: width*4/5,
                                color: Colors.black54,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            "${team.name}",
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 7,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      (team.lastGames!.split('').isNotEmpty)
                          ? Last3GamesWidget(game: team.lastGames!.split('')[0])
                          : SizedBox(
                              width: width / 20,
                            ),
                      (team.lastGames!.split('').length >= 2)
                          ? Last3GamesWidget(game: team.lastGames!.split('')[1])
                          : SizedBox(
                              width: width / 20,
                            ),
                      (team.lastGames!.split('').length == 3)
                          ? Last3GamesWidget(game: team.lastGames!.split('')[2])
                          : SizedBox(
                              width: width / 20,
                            ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 4,
                child: TopListContainer(
                  color: const Color(goldColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: Text(
                        team.point.toString(),
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TopListContainer extends StatelessWidget {
  final Widget child;
  final Color color;

  const TopListContainer({super.key, required this.child, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(8)),
      child: child,
    );
  }
}
