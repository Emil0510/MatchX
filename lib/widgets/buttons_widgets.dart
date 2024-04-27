import 'package:flutter/material.dart';

import '../Constants.dart';
import 'loading_widget.dart';

class ButtonRounded extends StatelessWidget {
  final Function onPressed;
  final String text;
  const ButtonRounded({super.key, required this.onPressed, required this.text});
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
      onPressed: onPressed(),
      child:  Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
    );
  }
}


class ButtonUnRounded extends StatelessWidget {

  final Function onPressed;
  final String text;
  const ButtonUnRounded({super.key, required this.onPressed, required this.text});

  void onPressedCallback(){
    onPressed();
  }
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(goldColor),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              0.0), // Adjust the radius as needed
        ),
      ),
      onPressed: onPressedCallback,
      child:  Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
    );
  }
}


class CustomLoadingButton extends StatelessWidget {
  final Function onPressed;
  final bool isLoading;
  final String text;
  final Color color;
  final Color textColor;
  const CustomLoadingButton({super.key, required this.onPressed, required this.isLoading, required this.text, required this.color, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
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
        child: (isLoading) ?  CircularProgressForButtons(color: textColor,) :  Text(
          text,
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
    );
  }
}

