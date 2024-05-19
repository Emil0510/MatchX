import 'package:flutter/material.dart';
import 'package:flutter_app/data.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_logics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchesCubit()
        ..set(matchesPageCubit.selectedId, matchesPageCubit.games,
            matchesPageCubit.isLoaded, matchesPageCubit.page)
        ..start(),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(color: Colors.black),
        child: const MatchesLogics(),
      ),
    );
  }
}
