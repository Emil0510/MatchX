import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Game.dart';

import '../../../../../network/model/User.dart';
import '../../../../user/user_cubit/user_logics.dart';

class GameStaffView extends StatefulWidget {
  final TeamGame game;

  const GameStaffView({super.key, required this.game});

  @override
  State<GameStaffView> createState() => _GameStaffViewState();
}

class _GameStaffViewState extends State<GameStaffView> {
  List<StaffItem> homeStaff = [];
  List<StaffItem> awayStaff = [];

  @override
  void initState() {
    super.initState();
    widget.game.stats?.forEach((element) {
      if (element.side) {
        homeStaff.add(element);
      } else {
        awayStaff.add(element);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: homeStaff.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserLogics(username: homeStaff[index].userName ?? ""),
                    ),
                  );
                },
                child: StaffItemView(
                  isVerificated: widget.game.isVerificated ?? false,
                  staff: homeStaff[index],
                ),
              );
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: awayStaff.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UserLogics(username: homeStaff[index].userName ?? ""),
                    ),
                  );
                },
                child: StaffItemView(
                  isVerificated:  widget.game.isVerificated ?? false,
                  staff: awayStaff[index],
                  isReverse: true,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StaffItemView extends StatelessWidget {
  final StaffItem staff;
  final bool isReverse;
  final bool isVerificated;

  const StaffItemView(
      {super.key,
      required this.staff,
      this.isReverse = false,
      required this.isVerificated});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(blackColor2),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          mainAxisAlignment:
              isReverse ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            isReverse
                ? Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            isVerificated ? staff.goalCount.toString() ?? "" : "",
                            style: const TextStyle(color: Color(goldColor)),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                staff.fullName,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "@${staff.userName}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                )
                : ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: staff.imageUrl,
                      width: width / 10,
                      height: width / 10,
                      fit: BoxFit.cover,
                    ),
                  ),
            isReverse
                ? ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: staff.imageUrl,
                      width: width / 10,
                      height: width / 10,
                      fit: BoxFit.cover,
                    ),
                  )
                : Expanded(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                staff.fullName,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(fontSize: 12),
                              ),
                              Text(
                                "@${staff.userName}",
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          Text(
                            isVerificated ? staff.goalCount.toString() ?? "" : "",
                            style: const TextStyle(color: Color(goldColor)),
                          ),
                        ],
                      ),
                    ),
                ),
          ],
        ),
      ),
    );
  }
}
