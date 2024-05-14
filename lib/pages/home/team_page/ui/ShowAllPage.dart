import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Game.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/team_detail_latest_match.dart';

class ShowAllPage extends StatefulWidget {
  final String id;

  const ShowAllPage({super.key, required this.id});

  @override
  State<ShowAllPage> createState() => _ShowAllPageState();
}

class _ShowAllPageState extends State<ShowAllPage> {
  bool isLoading = true;
  List<TeamGame> list = [];

  @override
  void initState() {
    super.initState();
    getAllGames();
  }

  void getAllGames() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.get(baseUrl + seeMoreApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
          queryParameters: {"id": widget.id});

      if (response.statusCode == 200) {
        setState(() {
          list = (response.data['data']['games'] as List)
              .map((e) => TeamGame.fromJson(e))
              .toList();
          isLoading = false;
        });
      }
    } on DioException catch (e) {}
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
          "Oyunlar",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: Container(
        width: width,
        height: height,
        color: Colors.black,
        child: Container(
            width: width,
            height: height,
            color: Colors.black,
            child: isLoading
                ? const Center(
                    child: CircularLoadingWidget(),
                  )
                : TeamDetailMatchesList(teamGame: list, id: widget.id,),
          ),
      ),
    );
  }
}
