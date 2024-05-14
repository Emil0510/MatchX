import 'package:flutter/material.dart';
import '../../../Constants.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {

  double _position = 1.0;

  bool check = false;
  int seconds = 10;

  @override
  void initState() {
    super.initState();
    start();
  }

  void start() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        _position = 0.0; // Move the text to the top
      });
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        seconds = 30;
        _position = -3.0; // Move the text to the top
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Haqqımızda",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: Duration(seconds: seconds), // Duration of the animation
              curve: Curves.linear, // Animation curve
              top: height * _position,
              child: SizedBox(
                width: width,
                child: const Text(
                  "MatchX, idman həvəskarlarını bir araya gətirən yenilikçi bir platformadır. Öz komandanızı yaradın, rəqiblər tapın və oyuna başlayın. MatchX, idman təcrübəsini tamamilə dəyişir və hər oyunçuya öz meydanında ulduz olmaq imkanı verir. Siz də MatchX-in dinamik dünyasına qoşularaq əsl rəqabət hissini təcrübə edin!",
                  style: TextStyle(fontSize: 24.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
