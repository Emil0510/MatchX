import 'package:equatable/equatable.dart';

import '../../../../network/model/Blog.dart';
import '../../../../network/model/Team.dart';
import '../../../../network/model/User.dart';
import '../../../../network/model/Weather.dart';

abstract class HomePageStates extends Equatable{}

class HomePageInitialState extends HomePageStates{
  @override
  List<Object?> get props => [];

}

class HomePageLoadingState extends HomePageStates{
  @override
  List<Object?> get props => [];

}
class HomePageErrorState extends HomePageStates{
  @override
  List<Object?> get props => [];

}

class HomePageMainState extends HomePageStates{
  final List<Team> top10Teams;
  final List<User> top10Users;
  final List<Blog> blogs;
  final Weather weather;

  HomePageMainState( {required this.top10Teams, required this.top10Users, required this.blogs, required this.weather});

  @override
  List<Object?> get props => [top10Users, top10Teams, blogs];

}


class HomePageBlogsState extends HomePageStates{
  final List<Blog> blogs;

  HomePageBlogsState( {required this.blogs,});

  @override
  List<Object?> get props => [blogs];

}



