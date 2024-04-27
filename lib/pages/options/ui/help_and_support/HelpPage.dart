import 'package:flutter/material.dart';
import 'package:flutter_app/pages/options/widgets/question_widget.dart';

import '../../../../Constants.dart';
import '../../../../network/model/Question.dart';

class HelpPage extends StatelessWidget {
  final List<Question> questions;

  const HelpPage({super.key, required this.questions});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    var height = MediaQuery
        .of(context)
        .size
        .height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Kömək",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "Biz MatchX-də hər yerdə və hər şeydə sizə kömək etmək üçün buradayıq",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),),
              ),
              ListView.builder(
                itemCount: questions.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return QuestionWidget(question: questions[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
