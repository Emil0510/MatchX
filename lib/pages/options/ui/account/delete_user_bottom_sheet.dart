import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../data.dart';
import '../../../home/divisions_page/division_cubit/division_cubit.dart';
import '../../../home/home_page/cubit/home_page_cubit.dart';
import '../../../home/matches_page/mathches_cubit/matches_cubit.dart';
import '../../../home/more_page/more_cubit/more_page_cubit.dart';
import '../../../home/team_page/team_cubit/team_cubit.dart';
import '../../../sign_in_sign_up/login_signup.dart';

class DeleteUserBottomSheet extends StatefulWidget {
  const DeleteUserBottomSheet({super.key});

  @override
  State<DeleteUserBottomSheet> createState() => _DeleteUserBottomSheetState();
}

class _DeleteUserBottomSheetState extends State<DeleteUserBottomSheet> {
  late TextEditingController controller;
  String text = "Hesabı silmək üçün öz parolunuzu daxil edin";
  bool loading = false;
  bool passwordInvisible = true;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(
          height: 64,
        ),
        Text(text),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CustomPasswordTextFieldWidget(
              controller: controller,
              passwordInvisible: passwordInvisible,
              labelText: 'Parol',
              onSuffixPressed: () {
                setState(() {
                  passwordInvisible = !passwordInvisible;
                });
              },
            ),
          ),
        ),
        const SizedBox(
          height: 64,
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CustomLoadingButton(
              onPressed: () {
                if (!loading) {
                  setState(() {
                    loading = true;
                  });
                  context.read<OptionsCubit>().deleteUser(
                      controller.text.trim(), (succesfull, message) async {
                    showToastMessage(context, message);
                    setState(() {
                      loading = false;
                    });
                    if (succesfull) {
                      Navigator.pop(context);
                      var sharedPreferences = locator.get<SharedPreferences>();
                      await sharedPreferences.clear();
                      await sharedPreferences.setBool(
                          shouldShowOnboardKey, false);
                      homePageCubit = HomePageCubit();
                      matchesPageCubit = MatchesCubit();
                      teamPageCubit = TeamCubit();
                      morePageCubit = MorePageCubit();
                      divisionPageCubit = DivisionCubit();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignInSignUp(),
                        ),
                        (e) => false,
                      );
                    }
                  });
                }
              },
              isLoading: loading,
              text: "Təsdiqlə",
              color: const Color(goldColor),
              textColor: Colors.black),
        ),
        const SizedBox(
          height: 64,
        ),
      ],
    );
  }
}
