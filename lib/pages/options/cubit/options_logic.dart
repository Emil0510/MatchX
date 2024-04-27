import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/cubit/options_states.dart';
import 'package:flutter_app/pages/options/ui/OptionsPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../widgets/snackbar.dart';
import '../../sign_in_sign_up/login_signup.dart';


class OptionsLogics extends StatefulWidget {
  const OptionsLogics({super.key});

  @override
  State<OptionsLogics> createState() => _OptionsLogicsState();
}

class _OptionsLogicsState extends State<OptionsLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OptionsCubit, OptionsStates>(builder: (cotext, state){
      if(state is OptionsLoadingState){
        return const CircularLoadingWidget();
      }else if (state is OptionsErrorState){
        return const Text("Error");
      }else if(state is OptionsHomePageState){
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (state.isLogOut) {
            showCustomSnackbar(context, "Hesabınızdan çıxdınız");
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) =>
                const SignInSignUp(),
              ),
                  (e) => false,
            );
          }
        });
        return const OptionsPage();
      }else{
        return const CircularLoadingWidget();
      }
    });
  }
}
