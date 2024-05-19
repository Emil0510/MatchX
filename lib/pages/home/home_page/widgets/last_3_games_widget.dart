import 'package:flutter/material.dart';

import '../../../../Constants.dart';

class Last3GamesWidget extends StatelessWidget {
  final String game;

  const Last3GamesWidget({super.key, required this.game});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    IconData? icon;
    Color? color;
    Color? backColor;
    if (game == "d") {
      color = Colors.grey;
      icon = Icons.remove_circle;
      backColor = Colors.transparent;
    } else if (game == "v") {
      color = const Color(greenColor);
      icon = Icons.check_circle;
      backColor = Colors.transparent;
    } else if (game == "f") {
      color = Colors.black;
      backColor = const Color(redColor);
      icon = Icons.close;
    }
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Container(
        decoration: BoxDecoration(shape: BoxShape.circle, color: backColor),
        child: Icon(
          icon,
          color: color,
          size: width / 20,
        ),
      ),
    );
  }
}
