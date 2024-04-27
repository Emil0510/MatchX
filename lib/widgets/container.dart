import 'package:flutter/material.dart';

import '../Constants.dart';

class CustomContainer extends StatelessWidget {
  final Widget? child;
  final Color? color;

  const CustomContainer({super.key, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      height: double.maxFinite,
      width: double.maxFinite,
      child: child,
    );
  }
}

class CustomShadowContainer extends StatelessWidget {
  final Widget? child;

  const CustomShadowContainer({super.key, this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(blackColor),
        // Background color of the container
        borderRadius: BorderRadius.all(Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black38, // Shadow color
            offset: Offset(0, 4), // Offset of the shadow (x, y)
            blurRadius: 6, // Spread of the shadow
            spreadRadius: 0, // Expansion of the shadow
          ),
        ],
      ),
      child: child,
    );
  }
}
