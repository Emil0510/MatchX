import 'package:equatable/equatable.dart';

import '../../../network/model/User.dart';

abstract class UserStates extends Equatable{}

class UserInitialState extends UserStates{
  @override
  List<Object?> get props => [];

}

class UserLoadingState extends UserStates{
  @override
  List<Object?> get props => [];

}
class UserErrorState extends UserStates{
  final String message;
  UserErrorState({required this.message});
  @override
  List<Object?> get props => [message];

}

class UserPageState extends UserStates{
  final User user;
  final int age;
  UserPageState({required this.user, required this.age});
  @override
  List<Object?> get props => [user, age];

}