import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_states.dart';
import 'package:flutter_app/pages/home/matches_page/ui/MatchesPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/loading_widget.dart';

class MatchesLogics extends StatefulWidget {
  const MatchesLogics({super.key});

  @override
  State<MatchesLogics> createState() => _MatchesLogicsState();
}

class _MatchesLogicsState extends State<MatchesLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchesCubit, MatchesStates>(
      builder: (context, state) {
        if (state is MatchesLoadingState) {
          return const CircularLoadingWidget();
        } else if (state is MatchesPageState) {
          return  AllMatchesPage(games: state.games, selectedId: state.selectedId,);
        } else {
          return const CircularLoadingWidget();
        }
      },
    );
  }
}
