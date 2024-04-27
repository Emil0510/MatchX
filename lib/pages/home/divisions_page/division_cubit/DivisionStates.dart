import 'package:equatable/equatable.dart';

import '../../../../network/model/Division.dart';

abstract class DivisionStates extends Equatable{}

class DivisionInitialState extends DivisionStates{
  @override
  List<Object?> get props => [];
}

class DivisionLoadingState extends DivisionStates{
  @override
  List<Object?> get props => [];
}

class DivisionErrorState extends DivisionStates{
  @override
  List<Object?> get props => [];
}

class DivisionPageState extends DivisionStates{
  final List<Division> divisions;

  DivisionPageState({required this.divisions});

  @override
  List<Object?> get props => [divisions];
}