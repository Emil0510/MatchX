import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/DivisionStates.dart';
import 'package:flutter_app/pages/home/divisions_page/division_cubit/division_cubit.dart';
import 'package:flutter_app/pages/home/divisions_page/ui/DivisionUi.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DivisionLogics extends StatefulWidget {
  const DivisionLogics({super.key});

  @override
  State<DivisionLogics> createState() => _DivisionLogicsState();
}

class _DivisionLogicsState extends State<DivisionLogics> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.black),
      child: BlocBuilder<DivisionCubit, DivisionStates>(builder: (context, state) {

        if (state is DivisionLoadingState) {
          return const CircularLoadingWidget();
        } else if (state is DivisionErrorState) {
          return const Text("Error");
        } else if (state is DivisionPageState) {
          return DivisionUi(divisions: state.divisions,);
        } else {
          return const CircularLoadingWidget();
        }

      }),
    );
  }
}
