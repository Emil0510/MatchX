import 'package:equatable/equatable.dart';
import 'package:spinner_dropdown/spinner_list_item.dart';

abstract class CreateMatchStates extends Equatable{}


class CreateMatchInitialState extends CreateMatchStates{
  @override
  List<Object?> get props => [];
}

class CreateMatchLoadingState extends CreateMatchStates{
  @override
  List<Object?> get props => [];
}

class CreateMatchErrorState extends CreateMatchStates{
  @override
  List<Object?> get props => [];
}

class CreateMatchesPageState extends CreateMatchStates{
  final bool isError;
  final String message;

  CreateMatchesPageState({required this.isError, required this.message});
  @override
  List<Object?> get props => [];
}

class CreateMatchesWithLinkPageState extends CreateMatchStates{
  final String guide;
  final bool isSuccesfull;
  final String message;
  CreateMatchesWithLinkPageState({required this.guide, required this.isSuccesfull, required this.message});
  @override
  List<Object?> get props => [];
}