import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/GameResult.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_game_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/widgets/confirm_row_item.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../Constants.dart';
import '../../../../../network/model/Game.dart';

class FinishedGamesConfirmPage extends StatefulWidget {
  final TeamGame game;

  const FinishedGamesConfirmPage({super.key, required this.game});

  @override
  State<FinishedGamesConfirmPage> createState() =>
      _FinishedGamesConfirmPageState();
}

class _FinishedGamesConfirmPageState extends State<FinishedGamesConfirmPage> {
  late TextEditingController homeGoalController;
  late TextEditingController awayGoalController;
  late bool isHome;
  late List<TextEditingController> controllers;
  bool isLoading = false;
  bool isLoadingReject = false;

  @override
  void initState() {
    super.initState();
    homeGoalController = TextEditingController();
    awayGoalController = TextEditingController();
    isHome = (getMyTeamId() == widget.game.homeTeamId);
    controllers = [];
    if (isHome) {
      widget.game.homeTeamMembers?.forEach((element) {
        var elementt = TextEditingController();
        elementt.text = "0";
        controllers.add(elementt);
      });

      if (widget.game.homeTeamGoal != null) {
        homeGoalController.text = widget.game.homeTeamGoal.toString();
        awayGoalController.text = widget.game.awayTeamGoal.toString();
        widget.game.homeTeamMembers?.forEach((element) {
          var elementt = TextEditingController();
          elementt.text = "0";
          controllers.add(elementt);
        });
      }
    } else {
      widget.game.awayTeamMembers?.forEach((element) {
        var elementt = TextEditingController();
        elementt.text = "0";
        controllers.add(elementt);
      });

      if (widget.game.homeTeamGoal != null) {
        homeGoalController.text = widget.game.homeTeamGoal.toString();
        awayGoalController.text = widget.game.awayTeamGoal.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Təsdiqlə",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          color: Colors.black,
          child: SingleChildScrollView(
            child: Container(
              width: double.maxFinite,
              constraints: BoxConstraints(
                minHeight: height
              ),
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Komandaların qol sayları",
                      style: TextStyle(
                          color: const Color(goldColor),
                          fontSize: width / 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConfirmRow(
                      isReadOnly: !isHome || widget.game.homeTeamGoal != null,
                      text: widget.game.homeTeamName ?? "",
                      controller: homeGoalController,
                      image: widget.game.homeTeamImageUrl ?? "",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConfirmRow(
                        isReadOnly: !isHome,
                        text: widget.game.awayTeamName ?? "",
                        controller: awayGoalController,
                        image: widget.game.awayTeamImageUrl ?? ""),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Oyunçuların qol sayları ${isHome ? "(Ev)" : "(Qonaq)"}",
                      style: TextStyle(
                          color: const Color(goldColor),
                          fontSize: width / 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: isHome
                        ? widget.game.homeTeamMembers?.length
                        : widget.game.awayTeamMembers?.length,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ConfirmRow(
                          isReadOnly:
                              isHome && widget.game.homeTeamGoal != null,
                          text: isHome
                              ? widget.game.homeTeamMembers![index].name
                              : widget.game.awayTeamMembers![index].name,
                          image: isHome
                              ? widget
                                  .game.homeTeamMembers![index].profilePhotoUrl
                              : widget
                                  .game.awayTeamMembers![index].profilePhotoUrl,
                          controller: controllers[index],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoadingButton(
                        onPressed: () {
                          if (!isLoadingReject) {
                            if (isHome) {

                              AlertDialog alert = AlertDialog(
                                title: const Text("Oyun silmə"),
                                content: const Text("Oyunu silməyə əminsiz?"),
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
                                      setState(() {
                                        isLoadingReject = true;
                                      });
                                      context.read<FinishedGamesCubit>().cancelGame(
                                              (isSuccesfull, message) {
                                            showCustomSnackbar(context, message);
                                            if (isSuccesfull) {
                                              Navigator.of(context).pop();
                                            }
                                          }, widget.game.id ?? "");
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

                            } else {


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
                                      Navigator.pop(context);
                                      setState(() {
                                        isLoadingReject = true;
                                      });
                                      context
                                          .read<FinishedGamesCubit>()
                                          .rejectGame(widget.game.id ?? "",
                                              (isSuccesfull, message) {
                                            showCustomSnackbar(context, message);
                                            if (isSuccesfull) {
                                              Navigator.of(context).pop();
                                            }
                                          });
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
                          }
                        },
                        isLoading: isLoadingReject,
                        text: isHome ? "Oyunu sil" : "Ləğv et",
                        color: Colors.red,
                        textColor: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomLoadingButton(
                        onPressed: () {
                          if (!isLoading) {
                            if (isHome) {
                              var check = true;
                              for (var i in controllers) {
                                check = i.text.trim().isNotEmpty;
                                if (!check) {
                                  break;
                                }
                              }
                              if (check &&
                                  homeGoalController.text.trim().isNotEmpty &&
                                  awayGoalController.text.trim().isNotEmpty) {
                                if (widget.game.homeTeamGoal == null) {
                                  AlertDialog alert = AlertDialog(
                                    title: const Text("Oyunu təsdiqləmə"),
                                    content: const Text(
                                        "Oyunu təsdiqləməyə əminsiz?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text(
                                            "Xeyr",
                                            style:
                                                TextStyle(color: Colors.white),
                                          )),
                                      TextButton(
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          setState(() {
                                            isLoading = true;
                                          });
                                          List<GameResult> results = [];
                                          for (int i = 0;
                                              i < controllers.length;
                                              i++) {
                                            results.add(GameResult(
                                                userId: widget
                                                        .game
                                                        .homeTeamMembers![i]
                                                        .id ??
                                                    "",
                                                goalCount: int.parse(
                                                    controllers[i]
                                                        .text
                                                        .trim())));
                                          }
                                          context
                                              .read<FinishedGamesCubit>()
                                              .setGameResult(
                                            widget.game.id ?? "",
                                            int.parse(
                                                homeGoalController.text.trim()),
                                            int.parse(
                                                awayGoalController.text.trim()),
                                            results,
                                            (isSuccesfull, message) {
                                              setState(() {
                                                isLoading = false;
                                              });
                                              showCustomSnackbar(
                                                  context, message);
                                              if (isSuccesfull) {
                                                Navigator.of(context).pop();
                                              }
                                            },
                                          );
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
                                } else {
                                  showCustomSnackbar(context,
                                      "Öz oyun nəticənizi əlavə etmisiniz, qonaq komandanın nəticəsini əlavə etməsini gğzləyin!");
                                }
                              } else {
                                showCustomSnackbar(
                                    context, "Məlumatları tam daxil edin!");
                              }
                            } else {
                              var check = true;
                              for (var i in controllers) {
                                check = i.text.trim().isNotEmpty;
                                if (!check) {
                                  break;
                                }
                              }
                              if (check) {
                                AlertDialog alert = AlertDialog(
                                  title: const Text("Oyunu təsdiqləmə"),
                                  content:
                                      const Text("Oyunu təsdiqləməyə əminsiz?"),
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
                                        setState(() {
                                          isLoading = true;
                                        });
                                        List<GameResult> results = [];
                                        for (int i = 0;
                                            i < controllers.length;
                                            i++) {
                                          results.add(GameResult(
                                              userId: widget.game
                                                      .awayTeamMembers![i].id ??
                                                  "",
                                              goalCount: int.parse(
                                                  controllers[i].text.trim())));
                                        }
                                        context
                                            .read<FinishedGamesCubit>()
                                            .verifyGame(
                                          widget.game.id ?? "",
                                          widget.game.awayTeamGoal,
                                          results,
                                          (isSuccesfull, message) {
                                            setState(() {
                                              isLoading = false;
                                            });
                                            showCustomSnackbar(
                                                context, message);
                                            if (isSuccesfull) {
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        );
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
                              } else {
                                showCustomSnackbar(
                                    context, "Məlumatları tam daxil edin!");
                              }
                            }
                          }
                        },
                        isLoading: isLoading,
                        text: "Təsdiqlə",
                        color: const Color(goldColor),
                        textColor: Colors.black),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
