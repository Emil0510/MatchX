import 'package:equatable/equatable.dart';

import '../../../../network/model/Team.dart';

abstract class TeamDetailCubitStates extends Equatable {}

class TeamDetailInitialState extends TeamDetailCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();
}

class TeamDetailLoadingState extends TeamDetailCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();
}


class TeamDetailErrorState extends TeamDetailCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();
}


class TeamDetailPageState extends TeamDetailCubitStates{
  final Team? team;
  final bool isSuccessful;
  final String message;
  final bool isThrow;
  TeamDetailPageState( {required this.team, required this.isSuccessful, required this.message, required this.isThrow});
  @override
  List<Object?> get props => [team];
}

class TeamCreatePageState extends TeamDetailCubitStates{
  final bool isSuccessful;
  final String message;

  TeamCreatePageState({required this.isSuccessful, required this.message});
  @override
  List<Object?> get props => [];
}

class TeamResulState extends TeamDetailCubitStates{
  final bool isSuccessful;
  final String message;

  TeamResulState({required this.isSuccessful, required this.message});
  @override
  List<Object?> get props => [];
}


class EditTeamPageState extends TeamDetailCubitStates{
  final bool isSuccessful;
  final String message;
  final Team? team;

  EditTeamPageState({required this.isSuccessful, required this.message, required this.team,});
  @override
  List<Object?> get props => [];
}





