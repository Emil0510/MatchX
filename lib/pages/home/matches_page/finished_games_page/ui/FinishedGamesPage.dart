import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/cubit/finished_games_logic.dart';
import 'package:flutter_app/widgets/container.dart';

import '../../../../../Constants.dart';

class FinishedGamesPage extends StatelessWidget {
  const FinishedGamesPage({super.key});

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
          "Oyunlarım",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: const CustomContainer(
        color: Colors.black,
        child: FinishedGamesLogics(),
      ),
    );
  }
}
