import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Question.dart';

class QuestionWidget extends StatefulWidget {
  final Question question;

  const QuestionWidget({super.key, required this.question});

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
            color: const Color(blackColor3),
            borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              if (mounted) {
                setState(() {
                  isOpen = !isOpen;
                });
              }
            },
            child: ExpansionPanelList(
              children: [
                ExpansionPanel(
                  backgroundColor: const Color(blackColor3),
                  isExpanded: isOpen,
                  headerBuilder: (context, isOpen) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.question.header,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                  body: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.question.description),
                  ),
                )
              ],
              expansionCallback: (i, isOpen) {
                if (mounted) {
                  setState(() {
                    this.isOpen = isOpen;
                  });
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
