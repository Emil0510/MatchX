import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';

class ChatTopMessage extends StatelessWidget {
  const ChatTopMessage({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Söhbət qaydaları",
              style: TextStyle(
                  color: const Color(greenColor), fontSize: width / 25),
            ),
          ),
          const Divider(
            color: Color(0xff545454),
          ),
           Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text("-Digər MatchX istifadəçilərinə hörmət edin!", style: TextStyle(color: Colors.white, fontSize: width/35),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "-Şəxsi məlumatlarınızı həmişə məxfi saxlamağı unutmayın.", style: TextStyle(color: Colors.white, fontSize: width/35)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                  "-Söyüşdən istifadə etməyin, əks halda banlanacaqsınız!", style: TextStyle(color: Colors.white, fontSize: width/35)),
            ),
          ),
          const Divider(
            color: Color(0xff545454),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Align(
              alignment: Alignment.center,
              child: Text(
                "Soyüş söydüyünüz təqdirdə hesabınız 1 saatlıq banlanacaq!!!",
                style: TextStyle(color: Colors.red, fontSize: width/30),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
