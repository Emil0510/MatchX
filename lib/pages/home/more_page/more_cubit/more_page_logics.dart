import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../widgets/loading_widget.dart';
import '../ui/more_home_page.dart';
import '../ui/profile_edit_page.dart';
import 'more_page_cubit.dart';
import 'more_page_states.dart';

class MorePageLogics extends StatefulWidget {
  const MorePageLogics({super.key});

  @override
  State<MorePageLogics> createState() => _MorePageLogicsState();
}

class _MorePageLogicsState extends State<MorePageLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MorePageCubit, MorePageCubitStates>(
        builder: (context, state) {
      if (state is MorePageLoadingState) {
        return const CircularLoadingWidget();
      } else if (state is MorePageHomeState) {
        return MorePageHome(
          user: state.user,
          age: state.age,
        );
      } else if (state is MorePageErrorState) {
        return const Text("Xeta");
      } else {
        return Container();
      }
    });
  }
}
