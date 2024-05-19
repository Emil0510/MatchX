import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/cubit/help_page_logics.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/cubit/suggesetion_logics.dart';
import 'package:flutter_app/pages/options/ui/help_and_support/SupportPage.dart';
import 'package:flutter_app/pages/options/widgets/options_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../Constants.dart';

class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({super.key});

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
          "Kömək və Dəstək",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        height: height,
        width: width,
        color: Colors.black,
        child: Column(
          children: [
            SizedBox(
              height: height / 20,
            ),
            OptionsItem(
              leadingIcon: Icons.headphones,
              title: "Ən çox verilən suallar",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<OptionsCubit>(
                      create: (context) => OptionsCubit()..startHelpPage(),
                      child: const HelpPageLogics(),
                    ),
                  ),
                );
              },
            ),
            OptionsItem(
              leadingIcon: Icons.contact_support,
              title: "Dəstək",
              onTap: () {
                //Tawk IO
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SupportPage()),
                );
              },
            ),
            OptionsItem(
              leadingIcon: Icons.comment,
              title: "Təklif və İradlarınız",
              onTap: () {
                //Tawk IO
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlocProvider<OptionsCubit>(
                            create: (context) =>
                                OptionsCubit()..startSuggestionPage(),
                            child: const SuggestionsLogics(),
                          )),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
