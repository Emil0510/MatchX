import 'package:flutter/material.dart';


class CustomErrorWidget extends StatelessWidget {
  const CustomErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text("Error", style: TextStyle(color: Colors.white,),
    ));
  }
}
