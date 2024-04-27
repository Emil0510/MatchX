import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/Constants.dart';

import '../../../../network/model/Division.dart';

class DivisionUi extends StatelessWidget {
  final List<Division> divisions;

  const DivisionUi({super.key, required this.divisions});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    List<Tab> tabs = [];

    // return DefaultTabController(
    //   length: 2,
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title:  TabBar(
    //         tabs: [
    //           Expanded(
    //             child: Tab(
    //               icon: Image.network(divisions[0].divisionImage,),
    //             ),
    //           ),
    //           Expanded(
    //             child: Tab(
    //               icon: Image.network(divisions[1].divisionImage,),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //     body: Container(),
    //   ),
    // );

    return const Center(
      child: Text("Tezliklə...", style: TextStyle(color: Color(goldColor), fontWeight: FontWeight.bold, fontSize: 30),),
    );
  }
}
