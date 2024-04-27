import 'package:equatable/equatable.dart';

import '../../../../../network/model/Game.dart';

abstract class FinishedGamesStates extends Equatable{}

class FinishedGamesInitialState extends FinishedGamesStates{
  @override
  List<Object?> get props => [];
}


class FinishedGamesLoadingState extends FinishedGamesStates{
  @override
  List<Object?> get props => [];
}

class FinishedGamesErrorState extends FinishedGamesStates{
  @override
  List<Object?> get props => [];
}

class FinishedGamesPageState extends FinishedGamesStates{
  final List<TeamGame> myGames;
  FinishedGamesPageState({required this.myGames});

  @override
  List<Object?> get props => [myGames];
}

class FinishedGameConfirmPageState extends FinishedGamesStates{
  final TeamGame myGame;
  FinishedGameConfirmPageState({required this.myGame});

  @override
  List<Object?> get props => [myGame];
}




