import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/cubit/options_states.dart';
import 'package:flutter_app/pages/options/ui/help_and_support/SuggestionAndCommentPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuggestionsLogics extends StatefulWidget {
  const SuggestionsLogics({super.key});

  @override
  State<SuggestionsLogics> createState() => _SuggestionsLogicsState();
}

class _SuggestionsLogicsState extends State<SuggestionsLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionsCubit, OptionsStates>(builder: (context, state) {
      if (state is OptionsLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is OptionsSuggestionPageState) {
        return const SuggestionAndCommentPage();
      } else if (state is OptionsSuggestionSuccesfullPageState) {
        //Snackbar show
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showCustomSnackbar(context, "Təsviriniz göndərildi");
          Navigator.of(context).pop();
        });
        return const CircularLoadingWidget();
      } else if (state is OptionsErrorState) {
        return Text("Error");
      } else {
        return const CircularLoadingWidget();
      }
    });
  }
}
