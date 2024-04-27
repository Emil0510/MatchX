import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/loading_widget.dart';

import '../../../../Constants.dart';

class LogInButton extends StatelessWidget {
  final Function onPressed;
  final bool isLoading;
  const LogInButton({super.key, required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(goldColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10.0), // Adjust the radius as needed
        ),
      ),
      onPressed: (){
        if(!isLoading) {
          onPressed();
        }
      },
      child: Center(
        child: (isLoading) ? const CircularProgressForButtons() : const Text(
          "Daxil Ol",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}
