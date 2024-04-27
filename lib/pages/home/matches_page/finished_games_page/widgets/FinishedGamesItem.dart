import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
        // Navigator.of(context).pop();
        context.read<FinishedGamesCubit>().cancelGame((isSuccesfull, message) {
          print(message);
          // Navigator.of(context).pop();
          // showCustomSnackbar(contextt, message);
          showCustomSnackbar(context, message);
          if (isSuccesfull) {
            context.read<FinishedGamesCubit>().start();
          }
        }, widget.myGame.id ?? "");
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
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
                        Image.network(
                          widget.myGame.homeTeamImageUrl ?? "",
                          width: width / 12,
                          height: width / 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.myGame.homeTeamName ?? ""),
                        )
                      ],
                    ),
                  ),
                  ((widget.myGame.awayTeamImageUrl ?? "").isNotEmpty)
                      ? Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              Image.network(
                                widget.myGame.awayTeamImageUrl ?? "",
                                width: width / 12,
                                height: width / 12,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.myGame.awayTeamName ?? ""),
                              )
                            ],
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            Text(getGameDate(widget.myGame.gameDate ?? "")),
            Padding(
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
                    ),
            )
          ],
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
