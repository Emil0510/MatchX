import 'package:flutter/material.dart';

import '../../../../../Constants.dart';

class MorePageTextField extends StatelessWidget {
  final TextEditingController controller;
  final String text;
  final passwordVisible;
  final Function onSufficsTap;
  final bool iconVisibility;

  const MorePageTextField(
      {super.key,
      required this.controller,
      required this.onSufficsTap,
      required this.passwordVisible,
      required this.iconVisibility,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      obscureText: !passwordVisible,
      decoration: InputDecoration(
        filled: true,
        prefixIconColor: const Color(goldColor),
        fillColor: Color(blackColor3),
        labelText: text,
        suffixIcon: iconVisibility ? IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            passwordVisible ? Icons.visibility : Icons.visibility_off,
            color: Color(0xff888888),
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            onSufficsTap();
          },
        ) : null,
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF888888))),
      ),
    );
  }
}
