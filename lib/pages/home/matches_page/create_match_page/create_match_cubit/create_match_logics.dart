import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/create_match_cubit/create_match_cubit.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/create_match_cubit/create_match_states.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/ui/CreateMatchWithLinkPage.dart';
import 'package:flutter_app/pages/home/matches_page/create_match_page/ui/CreateMatchesHomePage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../widgets/snackbar.dart';

class CreateMatchesLogics extends StatefulWidget {
  const CreateMatchesLogics({super.key});

  @override
  State<CreateMatchesLogics> createState() => _CreateMatchesLogicsState();
}

class _CreateMatchesLogicsState extends State<CreateMatchesLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateMatchCubit, CreateMatchStates>(
        builder: (context, state) {
      if (state is CreateMatchesPageState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.isError) {
            showCustomSnackbar(context, state.message);
            Navigator.pop(context);
          }
        });
        return  const CreateMatchesHomePage();
      } else if (state is CreateMatchLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is CreateMatchesWithLinkPageState) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!state.isSuccesfull) {
            showCustomSnackbar(context, state.message);
            Navigator.pop(context);
          }
        });
        return CreateMatchWithLink(
          guide: state.guide,
        );
      } else {
        return const CircularLoadingWidget();
      }
    });
  }
}
