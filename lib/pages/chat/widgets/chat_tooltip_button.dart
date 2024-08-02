import 'package:flutter/material.dart';

class ChatTooltipButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const ChatTooltipButton({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xB8B98638),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.black, fontSize: 12),
      ),
    );
  }
}
