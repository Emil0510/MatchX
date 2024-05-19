import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_game_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_games_state.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/ui/AllFinishedGamesPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FinishedGamesLogics extends StatefulWidget {
  const FinishedGamesLogics({super.key});

  @override
  State<FinishedGamesLogics> createState() => _FinishedGamesLogicsState();
}

class _FinishedGamesLogicsState extends State<FinishedGamesLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FinishedGamesCubit, FinishedGamesStates>(
      builder: (BuildContext context, FinishedGamesStates state) {
        if (state is FinishedGamesLoadingState) {
          return const CircularLoadingWidget();
        } else if (state is FinishedGamesErrorState) {
          return const Center(
            child: Text(
              "Error",
              style: TextStyle(color: Colors.white),
            ),
          );
        } else if (state is FinishedGamesPageState) {
          return AllFinishedGamesPage(
            myGames: state.myGames,
          );
        } else {
          return const CircularLoadingWidget();
        }
      },
    );
  }
}
