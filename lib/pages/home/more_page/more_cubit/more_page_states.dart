import 'package:equatable/equatable.dart';

import '../../../../network/model/User.dart';

abstract class MorePageCubitStates extends Equatable{}

class MorePageInitialState extends MorePageCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class MorePageLoadingState extends MorePageCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class MorePageHomeState extends MorePageCubitStates{
  final User user;
  final int age;
  final String joinDate;
  final String birthDate;
  MorePageHomeState(this.age, this.joinDate, this.birthDate, {required this.user});
  @override
  List<Object?> get props => throw UnimplementedError();

}

class MorePageEditProfileState extends MorePageCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class MorePageErrorState extends MorePageCubitStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}