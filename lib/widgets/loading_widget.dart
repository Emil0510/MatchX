import 'package:flutter/material.dart';


class CircularLoadingWidget extends StatelessWidget {
  const CircularLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(18, 17, 17, 1),
      child: Center(
        child: Image.asset(
          "assets/cup_loading.gif",
          height: 100,
          width: 100,
        ),
      ),
    );
  }
}


class CircularProgressForButtons extends StatelessWidget {
  final Color? color;
  const CircularProgressForButtons({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          minHeight: 20,
          minWidth: 20,
          maxHeight: 30,
          maxWidth: 30),
      child:  CircularProgressIndicator(
        color: color ?? Colors.black,
      ),
    );
  }
}

