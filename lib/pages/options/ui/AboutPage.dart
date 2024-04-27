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
      await Future.delayed(Duration(seconds: 10));
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
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec et leo vitae risus sollicitudin aliquam et nec tortor. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Cras blandit neque et orci ultrices, ut viverra turpis eleifend. Sed convallis, arcu in maximus consequat, ligula diam vestibulum ex, vel aliquet libero neque non sem. Quisque sit amet sapien nisl. Nunc et sem tincidunt, volutpat eros et, tincidunt turpis. Pellentesque vestibulum augue tellus, sit amet tincidunt enim mattis id. Nulla facilisi. Praesent a rutrum risus, et mattis erat.Donec malesuada convallis augue ac gravida. Donec congue nisl et vehicula ultricies. Quisque non dolor pretium, molestie diam id, rhoncus lacus. Maecenas a venenatis mauris. Nunc convallis risus nunc, at consectetur est consequat ultrices. Nulla facilisi. Praesent porta tortor nulla, a tincidunt ante porttitor vitae. Fusce pharetra est at ipsum commodo facilisis. Vivamus feugiat erat a volutpat convallis. Etiam ac ultricies lorem. Sed rhoncus enim a enim semper, ut volutpat felis bibendum. Phasellus malesuada orci lobortis, molestie odio sed, bibendum sem. Vivamus feugiat diam est, a pharetra lacus maximus id.",
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
