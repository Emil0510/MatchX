import 'package:equatable/equatable.dart';

import '../../../../network/model/Team.dart';
import '../../../../network/model/TeamFilter.dart';

abstract class TeamCubitStates extends Equatable {}

class InitialTeamState extends TeamCubitStates {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TeamLoadingState extends TeamCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class TeamErrorState extends TeamCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class AllTeamPageState extends TeamCubitStates {
  final List<Team> teams;
  final TeamFilter filter;
  AllTeamPageState({required this.teams, required this.filter});

  @override
  List<Object?> get props => throw UnimplementedError();
}

class TeamFilterPageState extends TeamCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}



