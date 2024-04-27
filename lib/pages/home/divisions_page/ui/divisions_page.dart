import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/division_cubit.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/division_logics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DivisionPage extends StatelessWidget {
  const DivisionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DivisionCubit>(
      create: (context) => DivisionCubit()..start(),
      child: const DivisionLogics(),
    );
  }
}
