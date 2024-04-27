import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_states.dart';
import 'package:flutter_app/pages/home/team_page/ui/TeamEditUi.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants.dart';
import '../../../../widgets/snackbar.dart';

class EditTeamLogics extends StatefulWidget {
  const EditTeamLogics({super.key});

  @override
  State<EditTeamLogics> createState() => _EditTeamLogicsState();
}

class _EditTeamLogicsState extends State<EditTeamLogics> {
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
          "Komandanı redaktə et",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: BlocBuilder<TeamDetailCubit, TeamDetailCubitStates>(builder: (BuildContext context, TeamDetailCubitStates state) {
        if(state is TeamDetailLoadingState){
          return const CircularLoadingWidget();
        }else if(state is TeamDetailErrorState){
          return const Text("Xeta bash verdi");
        }else if(state is EditTeamPageState){
          count++;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (state.isSuccessful) {
              showCustomSnackbar(context, state.message);
              Navigator.pop(context, true);
            } else if (count > 1) {
              showCustomSnackbar(context, state.message);
            }
          });
          return TeamEditPage(team: state.team);
        }else{
          return const CircularLoadingWidget();
        }
      },),
    );
  }
}
