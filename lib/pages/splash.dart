import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_cubit.dart';
import 'package:flutter_app/pages/sign_in_sign_up/login_signup.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants.dart';
import '../network/network.dart';
import '../onboarding/OnboardingPage.dart';
import 'chat/cubit/chat_cubit.dart';
import 'home/home.dart';
import 'home/home_cubit/home_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), callback);
  }

  void callback() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var shouldShowOnboard =
        sharedPreferences.getBool(shouldShowOnboardKey) ?? true;
    if (shouldShowOnboard) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const OnboardPage(),
        ),
        (e) => false,
      );
    } else {
      check(context);
    }
  }

  void check(BuildContext context) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var isLogged = sharedPreferences.getBool(isLoggedInKey) ?? false;

    var expireTime = sharedPreferences.getString(tokenExpireDayKey) ?? "";

    if (expireTime != "" && isLogged) {
      var expireDateTime = DateTime.parse(expireTime ?? "");

      if (expireDateTime.isBefore(DateTime.now())) {
        await sharedPreferences.setBool(isLoggedInKey, false);
        isLogged = false;
        showCustomSnackbar(context, "Daxil olma vaxtı doldu.");
      }
    }

    if (isLogged) {
      var sharedPreferences = locator.get<SharedPreferences>();
      var token = sharedPreferences.getString(tokenKey);
      print("Token $token");

      BaseOptions options = BaseOptions(
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      var username = sharedPreferences.getString(usernameKey);
      var dio = locator.get<Dio>();
      dio.options = options;
      var response = await dio.get(
        "$baseUrl$usersApi$username",
      );

      if (response.statusCode == 200) {
        var phoneNumber = response.data['phoneNumber'];

        var countCoursing = response.data['limitForCursing'];
        var locoutTime = response.data['lockOutForMessaging'];
        List<String>? roless =
            (response.data['roles'] as List).map((e) => e.toString()).toList();

        await sharedPreferences.setInt(countCursingKey, countCoursing ?? 0);
        await sharedPreferences.setString(
            lockoutLimitForMessagingKey, locoutTime ?? "");

        await sharedPreferences.setStringList(rolesKey, roless);
        await sharedPreferences.setString(phoneNumberKey, phoneNumber ?? "");

        var response2 = await dio.get(
          baseUrl + profileApi,
          options: Options(headers: {"Authorization": "Bearer $token"}),
        );
        if (response2.statusCode == 200) {
          var myTeamId = response2.data['myTeamId'];
          await sharedPreferences.setString(myTeamIdKey, myTeamId ?? "");
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MultiBlocProvider(providers: [
                    BlocProvider(
                      lazy: false,
                      create: (BuildContext context) => HomeCubits()..start(),
                    ),
                    BlocProvider(
                      lazy: false,
                      create: (BuildContext context) =>
                          ChatPageCubit()..start(context),
                    ),
                    BlocProvider(
                      lazy: false,
                      create: (BuildContext context) =>
                          NotificationCubit()..start(context),
                    ),
                  ], child: const Home())),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInSignUp(),
        ),
        (e) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.black,
      height: double.maxFinite,
      width: double.maxFinite,
      child: Align(
          alignment: Alignment.center,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/logo.png",
                width: height / 5,
              ),
              Text(
                "MatchX",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: width / 15,
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
