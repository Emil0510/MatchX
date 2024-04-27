import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';

class ProfileGridItemWidget extends StatelessWidget {
  final Function onPressed;
  final Icon icon;
  final String label;

  const ProfileGridItemWidget({super.key,
    required this.onPressed,
    required this.icon,
    required this.label});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: (){
        onPressed();
      },
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFF2C2C2C)),
          iconColor:MaterialStateProperty.all(const Color(goldColor))
      ),
      icon: icon,
      label: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
