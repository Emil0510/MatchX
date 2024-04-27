import 'package:flutter/material.dart';

import '../Constants.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Icon? prefixIcon;
  final TextInputType? textInputType;

  const CustomTextFieldWidget(
      {super.key,
      required this.controller,
      required this.hintText,
      this.prefixIcon, this.textInputType});

  @override
  Widget build(BuildContext context) {

    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      keyboardType: textInputType,
      decoration: InputDecoration(
        filled: true,
        prefixIconColor: const Color(goldColor),
        fillColor: Color(blackColor),
        labelText: hintText,
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        prefixIcon: prefixIcon,
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF888888))),
      ),
    );
  }
}

class CustomPasswordTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final bool passwordInvisible;
  final String labelText;
  final Function onSuffixPressed;

  const CustomPasswordTextFieldWidget(
      {super.key,
      required this.controller,
      required this.passwordInvisible,
      required this.labelText,
      required this.onSuffixPressed});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: passwordInvisible,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(blackColor),
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.grey),
        // Here is key idea
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF888888))),
        suffixIcon: IconButton(
          icon: Icon(
            // Based on passwordVisible state choose the icon
            !passwordInvisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            onSuffixPressed();
          },
        ),
      ),
    );
  }
}

class CustomReadOnlyText extends StatelessWidget {
  final TextEditingController controller;
  const CustomReadOnlyText({super.key, required this.controller, });

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return TextField(
      textAlign: TextAlign.center,
      controller: controller,
      readOnly: true,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        prefixIconColor: const Color(goldColor),
        fillColor: Color(blackColor),
        hintStyle: const TextStyle(color: Color(0xFF888888)),
        labelStyle: const TextStyle(color: Colors.grey),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Color(0xFF888888))),
      ),
    );
  }
}
