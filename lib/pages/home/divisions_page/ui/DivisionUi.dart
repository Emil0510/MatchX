import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/pages/home/divisions_page/widget/DivisionNavigationBar.dart';

import '../../../../network/model/Division.dart';

class DivisionUi extends StatelessWidget {
  final List<Division> divisions;

  const DivisionUi({super.key, required this.divisions});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return DivisionNavigationBar(divisions: divisions);
  }
}
