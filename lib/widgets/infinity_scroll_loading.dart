import 'package:flutter/material.dart';

class InfinityScrollLoading extends StatelessWidget {
  const InfinityScrollLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Center(child: CircularProgressIndicator()),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
