import 'package:flutter/material.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_tawkto/flutter_tawk.dart';

import '../../../../Constants.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

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
          "Dəstək",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),

      body: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: Tawk(
          directChatLink:
              'https://tawk.to/chat/64de280dcc26a871b02fd1ad/1hqmr5h7p',
          visitor: TawkVisitor(
            name: getMyUsername(),
            email: '',
          ),
          onLoad: () {
          },
          onLinkTap: (String url) {
          },
          placeholder: const Center(
            child: Text('Loading...'),
          ),
        ),
      ),
    );
  }
}
