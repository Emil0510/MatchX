import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_game_cubit.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../network/model/Game.dart';
import '../widgets/FinishedGamesItem.dart';

class AllFinishedGamesPage extends StatefulWidget {
  final List<TeamGame> myGames;

  const AllFinishedGamesPage({super.key, required this.myGames});

  @override
  State<AllFinishedGamesPage> createState() => _AllFinishedGamesPageState();
}

class _AllFinishedGamesPageState extends State<AllFinishedGamesPage> {
  late List<TeamGame> games;
  @override
  void initState() {
    super.initState();
    games = widget.myGames;
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
       var list =  await context.read<FinishedGamesCubit>().refreshUnverifyGames();
       setState(() {
         games = list;
         print(games);
       });
      },
      child: SizedBox(
        height: height,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: games.length,
          itemBuilder: (innerContext, int index) {
            return FinishedGamesItem(
              myGame: games[index],
            );
          },
        ),
      ),
    );
  }
}
