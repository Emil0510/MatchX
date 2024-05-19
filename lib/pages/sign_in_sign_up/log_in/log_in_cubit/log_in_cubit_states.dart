
abstract class LogInCubitStates {}

class LogInInitialState extends LogInCubitStates {
  @override
  List<Object?> get props => [];
}

class LogInLoadingState extends LogInCubitStates {
  @override
  List<Object?> get props => [];
}

class LogInErrorState extends LogInCubitStates {
  @override
  List<Object?> get props => [];
}

class LogInPageState extends LogInCubitStates {
  @override
  List<Object?> get props => [];
}

class LogInLoggedInState extends LogInCubitStates {
  @override
  List<Object?> get props => [];
}

class LogInUsernamePasswordWrongState extends LogInCubitStates {
  final String message;

  LogInUsernamePasswordWrongState({required this.message});
  @override
  List<Object?> get props => [];
}
