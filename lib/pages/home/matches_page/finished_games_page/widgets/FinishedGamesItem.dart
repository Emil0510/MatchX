import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/ui/ScheduledGameDetailPage.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../network/model/Game.dart';
import '../cubit/finished_game_cubit.dart';

class FinishedGamesItem extends StatefulWidget {
  final TeamGame myGame;

  const FinishedGamesItem({super.key, required this.myGame});

  @override
  State<FinishedGamesItem> createState() => _FinishedGamesItemState();
}

class _FinishedGamesItemState extends State<FinishedGamesItem> {
  late Function() onPressed;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    onPressed = () {
      if (((widget.myGame.awayTeamImageUrl ?? "").isNotEmpty)) {
        context
            .read<FinishedGamesCubit>()
            .toConfirmPage(widget.myGame, context);
      } else {
        //Cancel game

        AlertDialog alert = AlertDialog(
          title: const Text("Oyunu ləğv etmə"),
          content: const Text("Oyunu ləğv etməyə əminsiz?"),
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
                context.read<FinishedGamesCubit>().cancelGame(
                    (isSuccesfull, message) {
                  setState(() {
                    isLoading = false;
                  });
                  showCustomSnackbar(context, message);
                  if (isSuccesfull) {
                    context.read<FinishedGamesCubit>().start();
                  }
                }, widget.myGame.id ?? "");
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
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => ScheduledGameDetail(
              gameId: widget.myGame.id ?? "",
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          color: const Color(blackColor2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0, top: 8.0),
                      child: Row(
                        children: [
                          CachedNetworkImage(
                            imageUrl: widget.myGame.homeTeamImageUrl ?? "",
                            width: width / 12,
                            height: width / 12,
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
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(widget.myGame.homeTeamName ?? ""),
                          )
                        ],
                      ),
                    ),
                    !checkLeader()
                        ? const SizedBox()
                        : ((widget.myGame.awayTeamImageUrl ?? "").isNotEmpty)
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl:
                                          widget.myGame.awayTeamImageUrl ?? "",
                                      width: width / 12,
                                      height: width / 12,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) =>
                                          Shimmer.fromColors(
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                          "${widget.myGame.awayTeamName}" ??
                                              ""),
                                    )
                                  ],
                                ),
                              )
                            : const SizedBox(),
                  ],
                ),
              ),
              Expanded(
                  child: Text(
                getGameDate(widget.myGame.gameDate ?? ""),
                textAlign: TextAlign.center,
              )),
              !checkLeader()
                  ? ((widget.myGame.awayTeamImageUrl ?? "").isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child:
                                    Text("${widget.myGame.awayTeamName}" ?? ""),
                              ),
                              CachedNetworkImage(
                                imageUrl: widget.myGame.awayTeamImageUrl ?? "",
                                width: width / 12,
                                height: width / 12,
                                fit: BoxFit.cover,
                                placeholder: (context, url) =>
                                    Shimmer.fromColors(
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
                            ],
                          ),
                        )
                      : const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ((widget.myGame.awayTeamImageUrl ?? "").isNotEmpty)
                          ? CustomGoldButton(
                              onPressed: () {
                                onPressed();
                              },
                            )
                          : CustomRedButton(
                              onPressed: () {
                                if (!isLoading) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  onPressed();
                                }
                              },
                              isLoading: isLoading,
                            ))
            ],
          ),
        ),
      ),
    );
  }
}

class CustomGoldButton extends StatelessWidget {
  final Function onPressed;

  const CustomGoldButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(goldColor),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: Text(
          "Təsdiqlə",
          style: TextStyle(
              color: Colors.black,
              fontSize: width / 35,
              overflow: TextOverflow.visible,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomRedButton extends StatelessWidget {
  final Function onPressed;
  final bool isLoading;

  const CustomRedButton(
      {super.key, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(redColor),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(10.0), // Adjust the radius as needed
          ),
        ),
        onPressed: () {
          onPressed();
        },
        child: isLoading
            ? const Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Text(
                "Ləğv et",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width / 35,
                    fontWeight: FontWeight.bold),
              ),
      ),
    );
  }
}
