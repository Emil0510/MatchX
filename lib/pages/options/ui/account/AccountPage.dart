import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/change_password_logics.dart';
import 'package:flutter_app/pages/options/cubit/edit_profile_logics.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/ui/account/delete_user_bottom_sheet.dart';
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
                        create: (context) =>
                            OptionsCubit()..startChangePassword(),
                        child: const ChangePasswordLogics(),
                      ),
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    AlertDialog alert = AlertDialog(
                      title: const Text("Hesab silmə"),
                      content: const Text("Hesabınızı silməyə əminsiz?"),
                      actions: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Xeyr",
                              style: TextStyle(color: Colors.white),
                            )),
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            var cubit = context.read<OptionsCubit>();
                            showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) {
                                return  BlocProvider.value(
                                    value: cubit,
                                    child: const DeleteUserBottomSheet());
                              },
                            );
                          },
                          child: const Text(
                            "Bəli",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    );

                    // show the dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert;
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(blackColor2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.delete,
                                size: width / 15,
                                color: const Color(redColor),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Hesabı sil",
                                  style: TextStyle(
                                      color: Color(redColor),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
