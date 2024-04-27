import 'dart:io';
import 'package:flutter/material.dart';

class RectImageWidget extends StatelessWidget {
  final File? image;
  final IconData imageIcon;
  const RectImageWidget({super.key, required this.image, required this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: image == null
          ? Icon(
              imageIcon,
              size: 100,
              color: Colors.grey,
            )
          : ClipRect(
              child: Image.file(
                image!,
                height: 150,
                width: 150,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

