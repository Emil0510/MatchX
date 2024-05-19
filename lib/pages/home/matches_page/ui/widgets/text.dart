import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';


class MatchesText extends StatelessWidget {
  final String text;
  const MatchesText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(goldColor)
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FittedBox(fit: BoxFit.contain, child: Text(text, style: const TextStyle(color: Colors.black, fontSize:12),)),
      ),
    );
  }
}
