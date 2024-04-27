import 'package:flutter/material.dart';

import '../Constants.dart';

class TextGrayColorWidget extends StatelessWidget {
  final String text;

  const TextGrayColorWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 16),
    );
  }
}

class TextWhiteColorWidget extends StatelessWidget {
  final String text;

  const TextWhiteColorWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
    );
  }
}

class GoldColorText extends StatelessWidget {
  final String text;
  const GoldColorText({super.key, required this.text});
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Color(goldColor)),
    );
  }
}



