import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/mathches_cubit/matches_logics.dart';
import 'package:flutter_app/pages/home/matches_page/ui/widgets/mathes_list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MatchesCubit()..start(),
      child: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(color: Colors.black),
        child: const MatchesLogics(),
      ),
    );
  }
}
