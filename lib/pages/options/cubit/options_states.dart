import 'package:equatable/equatable.dart';

import '../../../network/model/Question.dart';
import '../../../network/model/User.dart';

abstract class OptionsStates extends Equatable{}

class OptionsInitialState extends OptionsStates{
  @override
  List<Object?> get props => [];
}

class OptionsLoadingState extends OptionsStates{
  @override
  List<Object?> get props => [];
}

class OptionsErrorState extends OptionsStates{
  @override
  List<Object?> get props => [];
}

class OptionsLoadingFinishedState extends OptionsStates{
  @override
  List<Object?> get props => [];
}

class OptionsHomePageState extends OptionsStates{
  final bool isLogOut;

  OptionsHomePageState({required this.isLogOut});
  @override
  List<Object?> get props => [isLogOut];

}

class OptionsEditProfileState extends OptionsStates{
  User user;
  OptionsEditProfileState({required this.user});

  @override
  List<Object?> get props => [user];
}


class OptionsChangePasswordState extends OptionsStates{
  User user;
  OptionsChangePasswordState({required this.user});

  @override
  List<Object?> get props => [user];
}


class OptionsHelpPageState extends OptionsStates{
  List<Question> questions;

  OptionsHelpPageState({required this.questions});

  @override
  List<Object?> get props => [questions];

}

class OptionsSuggestionPageState extends OptionsStates{
  @override
  List<Object?> get props => [];

}

class OptionsSuggestionSuccesfullPageState extends OptionsStates{
  @override
  List<Object?> get props => [];

}