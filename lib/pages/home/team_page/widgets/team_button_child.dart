import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';

import '../../../../widgets/text.dart';

class TeamButtonContainer extends StatelessWidget {
  final String text;

  const TeamButtonContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width / 2 - 18,
      height: height / 18,
      decoration: BoxDecoration(
        color: const Color(blackColor2),
        borderRadius: BorderRadius.circular(10)
      ),
      child: Center(
        child: GoldColorText(text: text),
      ),
    );
  }
}
