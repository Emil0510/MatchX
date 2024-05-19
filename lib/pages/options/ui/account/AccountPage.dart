import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/change_password_logics.dart';
import 'package:flutter_app/pages/options/cubit/edit_profile_logics.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/widgets/options_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../Constants.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Hesab",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        decoration: const BoxDecoration(color: Colors.black),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: height / 20,
              ),

              OptionsItem(
                leadingIcon: Icons.edit,
                title: "Düzəliş et",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OptionsCubit()..startEditProfile(),
                        child: const EditProfileLogics(),
                      ),
                    ),
                  );
                },
              ),

              OptionsItem(
                leadingIcon: Icons.lock,
                title: "Parolu dəyiş",
                onTap: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider(
                        create: (context) => OptionsCubit()..startChangePassword(),
                        child: const ChangePasswordLogics(),
                      ),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}
