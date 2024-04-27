import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_states.dart';
import 'package:flutter_app/pages/home/team_page/ui/CreateTeamPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/loading_widget.dart';
import '../ui/AllTeamPage.dart';


class TeamPageLogics extends StatefulWidget {
  const TeamPageLogics({super.key});

  @override
  State<TeamPageLogics> createState() => _TeamPageLogicsState();
}

class _TeamPageLogicsState extends State<TeamPageLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamCubit, TeamCubitStates>(builder: (context, state){

      if(state is TeamLoadingState){
        return const CircularLoadingWidget();
      }else if (state is AllTeamPageState){
        return AllTeamPage(teams: state.teams,);
      }else{
        return const CircularLoadingWidget();
      }
    });
  }
}
