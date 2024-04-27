import 'package:equatable/equatable.dart';

import '../../../../network/model/Game.dart';

abstract class MatchesStates extends Equatable{}

class MatchesInitialState extends MatchesStates{
  @override
  List<Object?> get props => [];
}


class MatchesLoadingState extends MatchesStates{
  @override
  List<Object?> get props => [];
}


class MatchesErrorState extends MatchesStates{
  @override
  List<Object?> get props => [];
}

class MatchesPageState extends MatchesStates{
  final  List<TeamGame>? games;
  final int selectedId;
  MatchesPageState({required this.games, required this.selectedId});
  @override
  List<Object?> get props => [games];
}