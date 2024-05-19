import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';

class OptionsItem extends StatelessWidget {
  final IconData leadingIcon;
  final String title;
  final Function onTap;

  const OptionsItem(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: const Color(blackColor2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      leadingIcon,
                      size: width / 15,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 2),
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey,
                  size: width / 15,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OptionsCheckItem extends StatefulWidget {
  final IconData leadingIcon;
  final String title;
  final Function onChanged;
  bool initValue;

  OptionsCheckItem(
      {super.key,
      required this.leadingIcon,
      required this.title,
      required this.onChanged,
      required this.initValue});

  @override
  State<OptionsCheckItem> createState() => _OptionsCheckItemState();
}

class _OptionsCheckItemState extends State<OptionsCheckItem> {
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            color: const Color(blackColor2),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.leadingIcon,
                      size: width / 15,
                      color: Colors.grey,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        widget.title,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Switch(
                    value: widget.initValue,
                    onChanged: (b) {
                      setState(() {
                        widget.initValue = b;
                      });
                      widget.onChanged();
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
