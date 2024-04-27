import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_cubit.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_states.dart';
import 'package:flutter_app/pages/home/team_page/ui/TeamDetailUi.dart';
import 'package:flutter_app/widgets/container.dart';
import 'package:flutter_app/widgets/error_widget.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/snackbar.dart';

class TeamDetailLogics extends StatefulWidget {
  const TeamDetailLogics({super.key});

  @override
  State<TeamDetailLogics> createState() => _TeamDetailLogicsState();
}

class _TeamDetailLogicsState extends State<TeamDetailLogics> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TeamDetailCubit, TeamDetailCubitStates>(
        builder: (context, state) {
      if (state is TeamResulState) {
        return const CustomContainer(color: Colors.black);
      } else if (state is TeamDetailLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is TeamDetailErrorState) {
        return const CustomErrorWidget();
      } else if (state is TeamDetailPageState) {
        count++;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.isSuccessful) {
            showCustomSnackbar(context, state.message);
            if(state.isThrow){
              context.read<TeamDetailCubit>().refresh(true);
              count = 0;
            }else {
              Navigator.pop(context, true);
            }
          } else if (count > 1) {
            showCustomSnackbar(context, state.message);
          }
        });
        return TeamDetailUI(team: state.team!);
      } else {
        return const CircularLoadingWidget();
      }
    });
  }
}
