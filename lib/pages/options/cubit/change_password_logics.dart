import "package:flutter/material.dart";
import "package:flutter_app/pages/options/ui/account/ChangePasswordPage.dart";
import "package:flutter_app/pages/options/cubit/options_states.dart";
import "package:flutter_app/widgets/loading_widget.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "options_cubit.dart";

class ChangePasswordLogics extends StatefulWidget {
  const ChangePasswordLogics({super.key});

  @override
  State<ChangePasswordLogics> createState() => _EditProfileLogicsState();
}

class _EditProfileLogicsState extends State<ChangePasswordLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionsCubit, OptionsStates>(builder: (context, state){
      if(state is OptionsLoadingState){
        return const CircularLoadingWidget();
      }else if(state is OptionsErrorState){
        return Text("Error");
      }else if(state is OptionsChangePasswordState){
        return ChangePasswordPage(user: state.user);
      }else{
        return const CircularLoadingWidget();
      }
    });
  }
}
