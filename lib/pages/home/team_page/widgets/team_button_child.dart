import 'package:flutter/material.dart';

import '../../../../widgets/text.dart';

class TeamButtonContainer extends StatelessWidget {
  final String text;

  const TeamButtonContainer({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      width: width / 2 - 12,
      height: height / 18,
      color: Colors.black,
      child: Center(
        child: GoldColorText(text: text),
      ),
    );
  }
}
