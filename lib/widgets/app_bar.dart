import 'package:flutter/material.dart';

class CustomAppBarWidget extends StatelessWidget {
  final String titleText;

  const CustomAppBarWidget({super.key, required this.titleText});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      elevation: 0,
      title: Text(
        titleText,
        style: TextStyle(color: Theme.of(context).primaryColor),
      ),
    );
  }
}

class CustomMessageIconButton extends StatelessWidget {
  final Function onPressed;
  final bool visible;

  const CustomMessageIconButton({super.key, required this.onPressed, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      IconButton(
        icon: const Icon(Icons.message),
        color: Colors.grey,
        onPressed: () {
          onPressed();
        },
      ),

      Visibility(
        visible: visible,
        child: Positioned(
          top: 10,
          right: 10,
          child: Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          ),
        ),
      )
    ]);
  }
}


class CustomNotificationIconButton extends StatelessWidget {
  final Function() onPressed;
  final bool visible;
  const CustomNotificationIconButton({super.key, required this.onPressed, required this.visible});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: const Icon(Icons.notifications),
          color: Colors.grey,
          onPressed: () {
            onPressed();
          },
        ),

        Visibility(
          visible: visible,
          child: Positioned(
            top: 10,
            right: 10,
            child: Container(
              width: 10,
              height: 10,
              decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            ),
          ),
        )
      ],
    );
  }
}

