import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';

class ConfirmRow extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final String? image;
  final bool isReadOnly;

  const ConfirmRow(
      {super.key, required this.text, required this.controller, this.image, required this.isReadOnly});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
          color: const Color(blackColor2),
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          image == null
              ? const SizedBox()
              : Padding(
                  padding: EdgeInsets.only(left: width / 10, top: 8, bottom: 8),
                  child: ClipOval(
                    child: Image.network(
                      image!,
                      width: width / 8,
                      height: width / 8,
                    ),
                  ),
                ),
          Text(text),
          Padding(
            padding: EdgeInsets.only(right: width / 15),
            child: SizedBox(
              width: width / 6,
              height: height / 10,

              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  readOnly: isReadOnly,
                  controller: controller,
                  style: TextStyle(color: Color(goldColor)),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  // Set keyboard type to accept numbers only
                  decoration: InputDecoration(
                    filled: true,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
