import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/User.dart';
import 'package:flutter_app/pages/sign_in_sign_up/log_in/log_in_cubit/log_in_cubit_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../network/network.dart';
import '../../../chat/cubit/chat_cubit.dart';
import '../../../home/home.dart';
import '../../../home/home_cubit/home_cubit.dart';
import '../../../notification_page/notification_cubit/notification_cubit.dart';

class LogInCubit extends Cubit<LogInCubitStates> {
  LogInCubit() : super(LogInInitialState());


  void check(BuildContext context) {
    var sharedPreferences = locator.get<SharedPreferences>();
    var isLogged = sharedPreferences.getBool(isLoggedInKey) ?? false;
    print(isLogged.toString());
    if (isLogged) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) =>  MultiBlocProvider(
              providers: [
                BlocProvider(
                  lazy: false,
                  create: (BuildContext context) => HomeCubits(),
                ),
                BlocProvider(
                  lazy: false,
                  create: (BuildContext context) => ChatPageCubit()..start(context),
                ),
                BlocProvider(
                  lazy: false,
                  create: (BuildContext context) =>
                  NotificationCubit()..start(context),
                ),
              ],

          child: const Home())),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  void logIn(String email, String password) async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    await messaging.getAPNSToken();
    String? deviceToken;

    if (Platform.isIOS) {
      deviceToken = await messaging.getAPNSToken();
    } else {
      deviceToken = await messaging.getToken();
    }
    const String url = baseUrl + loginApi;
    print("Device Token $deviceToken");
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
      'deviceToken' : deviceToken??""
    };
    String jsonData = jsonEncode(data);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON.
      },
      body: jsonData,
    );

    print("RESPONSE ${response.statusCode}");
    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = json.decode(response.body);
      ResponseJvt responseJvt = ResponseJvt.fromJson(jsonData);

      var expireDate = DateTime.now().add(const Duration(days: 15));


      await sharedPreferences.setString(tokenKey, responseJvt.token);
      await sharedPreferences.setString(usernameKey, responseJvt.userName);
      await sharedPreferences.setBool(isLoggedInKey, true);
      await sharedPreferences.setInt(tokenExpireDayKey, expireDate.day);

      print("Logged In");
      profileRequest(responseJvt.token);
    } else {
      print("Not Logged In");
      emit(LogInUsernamePasswordWrongState());
    }
  }

  void profileRequest(String token) async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();

    BaseOptions options = BaseOptions(
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
        // You may need to adjust the content type based on your API requirements
      },
    );

    print("TOKEN $token");

    dio.options = options;

    var response = await dio.get(
      "$baseUrl$profileApi",
    );

    if (response.statusCode == 200) {
      String? myTeamIdd = response.data['myTeamId'];
      List<String>? roless =
          (response.data['roles'] as List).map((e) => e.toString()).toList();

      print(roless);

      var username = sharedPreferences.getString("username") ?? "";
      var responseUser = await dio.get(baseUrl + usersApi + username);
      Map<String, dynamic> jsonData = responseUser.data;
      var user = User.fromJson(jsonData);
      await sharedPreferences.setString(phoneNumberKey, user.phoneNumber??"");
      await sharedPreferences.setInt(countCursingKey,user.countCursing??0);
      await sharedPreferences.setString(lockoutLimitForMessagingKey, user.lockoutLimitForMessaging ?? "");
      await sharedPreferences.setString(myTeamIdKey, myTeamIdd ?? "" );
      await sharedPreferences.setStringList(rolesKey, roless);
      var expireDay = DateTime.now().add(const Duration(days: 10));
      await sharedPreferences.setString(tokenExpireDayKey, expireDay.toString());

      emit(LogInLoggedInState());

    } else {
      emit(LogInErrorState());
    }
  }
}
