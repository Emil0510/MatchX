import 'package:flutter/material.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_page_logics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TeamCubit()
        ..set(teamPageCubit.teams, teamPageCubit.isLoaded, teamPageCubit.body, teamPageCubit.page, teamPageCubit.filter)
        ..start(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: const TeamPageLogics(),
      ),
    );
  }
}
