import "package:flutter/material.dart";
import "package:flutter_app/pages/options/ui/account/EditProfilePage.dart";
import "package:flutter_app/pages/options/cubit/options_states.dart";
import "package:flutter_app/widgets/loading_widget.dart";
import "package:flutter_bloc/flutter_bloc.dart";

import "options_cubit.dart";

class EditProfileLogics extends StatefulWidget {
  const EditProfileLogics({super.key});

  @override
  State<EditProfileLogics> createState() => _EditProfileLogicsState();
}

class _EditProfileLogicsState extends State<EditProfileLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionsCubit, OptionsStates>(builder: (context, state){
      if(state is OptionsLoadingState){
        return const CircularLoadingWidget();
      }else if(state is OptionsErrorState){
        return Text("Error");
      }else if(state is OptionsEditProfileState){
        return EditProfilePage(user: state.user);
      }else{
        return const CircularLoadingWidget();
      }
    });
  }
}
