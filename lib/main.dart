import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/pages/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_app/utils/NavigatorObserver.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'firebase_options.dart';

import 'dart:io' show Platform;

import 'Constants.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  await FirebaseMessaging.instance.setAutoInitEnabled(true);

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await AwesomeNotifications().initialize(

    Platform.isAndroid ? 'resource://drawable/ic_notification' : null,
    [
      NotificationChannel(
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          playSound: true,
          channelDescription: 'Notification channel for basic tests',
          defaultColor: const Color(goldColor),
          importance: NotificationImportance.High,
          ledColor: Colors.white)
    ],
  );

   await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const MyApp());
}

// ThemeData customTheme = ThemeData(
//   primaryColor: Colors.black, // Set the primary color
//   hintColor: Color(color), // Set the accent color
//   fontFamily: 'Roboto', // Set the default font family
// );

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MatchX",
      theme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color(goldColor),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          brightness: Brightness.light,
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Colors.white),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.grey,
        primaryColor: const Color(blackColor2),
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.grey,
          brightness: Brightness.dark,
        ),
        bottomSheetTheme:
            const BottomSheetThemeData(backgroundColor: Color(blackColor2)),
      ),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      navigatorObservers: [MyNavigatorObserver()],
      home: const Scaffold(body: SplashScreen()),
    );
  }
}
