import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_states.dart';
import 'package:flutter_app/pages/home/team_page/ui/CreateTeamPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/snackbar.dart';

class TeamCreateLogics extends StatefulWidget {
  const TeamCreateLogics({super.key});

  @override
  State<TeamCreateLogics> createState() => _TeamCreateLogicsState();
}

class _TeamCreateLogicsState extends State<TeamCreateLogics> {

  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Komanda Yarat",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: BlocBuilder<TeamDetailCubit, TeamDetailCubitStates>(
          builder: (BuildContext context, TeamDetailCubitStates state) {
        if (state is TeamCreatePageState) {
          count++;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.isSuccessful) {
              print("Create true");
              showCustomSnackbar(context, state.message);
              Navigator.pop(context, true);
            } else if (count > 1) {
              showCustomSnackbar(context, state.message);
            }
          });
          return const CreateTeam();
        } else if (state is TeamDetailLoadingState) {
          return const CircularLoadingWidget();
        } else if (state is TeamDetailErrorState) {
          return const Text("Error");
        } else {
          return const CircularLoadingWidget();
        }
      }),
    );
  }
}
