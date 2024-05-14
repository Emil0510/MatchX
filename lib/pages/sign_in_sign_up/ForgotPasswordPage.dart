import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/home/matches_page/finished_games_page/widgets/FinishedGamesItem.dart';
import 'package:flutter_app/widgets/container.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  late TextEditingController mailController;
  bool isLoading = false;

  void forgetPass() async {
    var dio = locator.get<Dio>();

    try {
      var response = await dio.post(
        baseUrl + forgetPassApi,
        queryParameters: {"email": mailController.text},
      );
      setState(() {
        isLoading = false;
      });
      showCustomSnackbar(context, response.data['message']);
    } on DioException catch (e) {
      print(e.response?.data);
      setState(() {
        isLoading = false;
      });
      showCustomSnackbar(context, e.response?.data['message']);
    }
  }

  @override
  void initState() {
    super.initState();
    mailController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Şifrəni yenilə",
          style: TextStyle(color: Color(0xfff59e0b)),
        ),
        backgroundColor: Colors.black,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Container(
          width: width,
          height: height,
          decoration: const BoxDecoration(color: Color(blackColor2)),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Şifrənizi yeniləmək üçün mailinizi daxil edin",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomTextFieldWidget(
                      controller: mailController, hintText: "Mail"),
                ),
                SizedBox(
                  height: height / 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(goldColor)),
                    onPressed: () {
                      if (!isLoading) {
                        if(mailController.text.trim().isNotEmpty) {
                          setState(() {
                            isLoading = true;
                            forgetPass();
                          });
                        }else{
                          showCustomSnackbar(context, "Mailinizi daxil edin");
                        }
                      }
                    },
                    child: isLoading
                        ? Transform.scale(
                            scale: 0.8,
                            child: const CircularProgressIndicator(
                              color: Colors.black,
                            ),
                          )
                        : const Text(
                            "Təsdiqlə",
                            style: TextStyle(color: Colors.black),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
