import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home/team_page/team_detail_cubit/team_detail_logics.dart';

import '../../../../Constants.dart';

class TeamDetailPage extends StatefulWidget {
  final String teamName;

  const TeamDetailPage({super.key, required this.teamName});

  @override
  State<TeamDetailPage> createState() => _TeamDetailPageState();
}

class _TeamDetailPageState extends State<TeamDetailPage> {
  bool isPrivate = false;
  File? _image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: Text(
          widget.teamName,
          style: const TextStyle(color: Color(goldColor)),
        ),
      ),
      backgroundColor: const Color(blackColor2),
      body: const TeamDetailLogics(),
    );
  }
}
