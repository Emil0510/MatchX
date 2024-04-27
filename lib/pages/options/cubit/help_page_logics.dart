import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/cubit/options_states.dart';
import 'package:flutter_app/pages/options/ui/help_and_support/HelpPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HelpPageLogics extends StatefulWidget {
  const HelpPageLogics({super.key});

  @override
  State<HelpPageLogics> createState() => _HelpPageLogicsState();
}

class _HelpPageLogicsState extends State<HelpPageLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionsCubit, OptionsStates>(builder: (context, state) {
      if (state is OptionsLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is OptionsErrorState) {
        return const Text("Error");
      } else if (state is OptionsHelpPageState) {
        return HelpPage(questions: state.questions);
      } else {
        return const CircularLoadingWidget();
      }
    });
  }
}
