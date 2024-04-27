import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_cubit/team_page_logics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants.dart';


class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>TeamCubit()..start(),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: const TeamPageLogics(),
      ),
    );
  }
}

