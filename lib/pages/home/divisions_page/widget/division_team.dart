import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Team.dart';
import 'package:shimmer/shimmer.dart';

class DivisionTeamWidget extends StatelessWidget {
  final Team team;
  final int order;

  const DivisionTeamWidget(
      {super.key, required this.team, required this.order});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.black, borderRadius: BorderRadius.circular(10)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12.0),
                  child: Text(order.toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: CachedNetworkImage(
                     imageUrl:  team.teamLogoUrl ?? "",
                      width: width / 10,
                      height: width / 10,
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
                Text(team.name ?? "", style: const TextStyle(fontSize: 16),),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                decoration: BoxDecoration(
                    color: const Color(goldColor),
                    borderRadius: BorderRadius.circular(5)),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    "Xal: ${(team.divisionPoint ?? 0).toString()}\nRatinq: ${(team.rating).toString()}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
