import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../Constants.dart';
import '../../../../../network/model/Game.dart';

class JoinToMatchWithLink extends StatefulWidget {
  final Function(TeamGame teamGame, BuildContext context, bool isFromLink, String guide) function;

  const JoinToMatchWithLink({super.key, required this.function});

  @override
  State<JoinToMatchWithLink> createState() => _JoinToMatchWithLinkState();
}

class _JoinToMatchWithLinkState extends State<JoinToMatchWithLink> {
  late TextEditingController controller;
  bool isLoading = false;

  void search() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);
    var text = controller.text;
    try {
      var response = await dio.get(baseUrl + getLinkGameApi,
          options: Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ),
          queryParameters: {"linkGuid": controller.text.trim()});

      setState(() {
        isLoading = false;
      });

      if(response.statusCode == 200){
        print("Status code 200");
        Navigator.pop(context);
        var teamGame = TeamGame.fromJson(response.data['data']);
        widget.function(teamGame, context, true, text);
      }else{
        setState(() {
          isLoading = false;
        });
        showToastMessage(context, "Səhv link");
      }
    } on DioException catch (e) {
      print(e.response?.data);
      setState(() {
        isLoading = false;
      });
      showToastMessage(context, "Səhv link");
    }
  }

  @override
  void initState() {
    super.initState();
    controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: height / 50,
          ),
          const Text(
            "Link ilə oyuna qoşul",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: height / 50,
          ),

          Padding(
            padding: EdgeInsets.only(top: 20.0, right: 20.0, left: 20.0, bottom: MediaQuery.of(context).viewInsets.bottom),
            child: CustomTextFieldWidget(
                controller: controller, hintText: "Linki daxil et"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, bottom: 10),
            child: ElevatedButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  if (!isLoading) {
                    search();
                  }
                  setState(() {
                    isLoading = true;
                  });

                } else {
                  showToastMessage(context, "Linki daxil edin!");
                }
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(goldColor)),
              child: isLoading
                  ? const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.black,
                      ),
                    )
                  : const Text(
                      "Axtar",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
            ),
          ),
          SizedBox(
            height: height / 40,
          ),
        ],
      ),
    );
  }
}
