import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/ui/AboutPage.dart';
import 'package:flutter_app/pages/options/ui/PrivacyPolicyPage.dart';
import 'package:flutter_app/pages/options/ui/account/AccountPage.dart';
import 'package:flutter_app/pages/options/ui/help_and_support/HelpAndSupportPage.dart';
import 'package:flutter_app/pages/options/widgets/options_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});

  @override
  State<OptionsPage> createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Parametrlər",
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
                leadingIcon: Icons.person,
                title: "Hesab",
                onTap: () {
                  var cubit = context.read<OptionsCubit>();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BlocProvider<OptionsCubit>(
                          create: (BuildContext context) => cubit,
                          child: const AccountPage()),
                    ),
                  );
                },
              ),
              OptionsItem(
                leadingIcon: Icons.notifications,
                title: "Bildiriş parametri",
                onTap: () {
                  AppSettings.openAppSettings(
                      type: AppSettingsType.notification);
                },
              ),
              OptionsItem(
                leadingIcon: Icons.privacy_tip,
                title: "Gizlilik Siyasəti",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrivacyPolicyPage()),
                  );
                },
              ),
              OptionsItem(
                leadingIcon: Icons.headphones,
                title: "Kömək və dəstək",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HelpAndSupportPage()),
                  );
                },
              ),
              OptionsItem(
                leadingIcon: Icons.help,
                title: "Haqqımızda",
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AboutUsPage()),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    AlertDialog alert = AlertDialog(
                      title: const Text("Çıxış"),
                      content: const Text("Hesabınızdan çıxmağa əminsiz?"),
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
                            context.read<OptionsCubit>().logOut();
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
                                Icons.logout,
                                size: width / 15,
                                color: const Color(redColor),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Text(
                                  "Çıxış",
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
