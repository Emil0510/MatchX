import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_states.dart';
import 'package:flutter_app/pages/notification_page/ui/NotificationPage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import '../../../Constants.dart';
import '../../../network/model/Notification.dart';
import '../../../network/network.dart';

class NotificationCubit extends Cubit<NotificationStates> {
  NotificationCubit() : super(NotificationInitialState());

  late final HubConnection hubConnection;

  bool isNotificationVisible = false;

  List<Notificationn> notifications = [];

  start() async {
    emit(
      NotificationPageState(
          notificationVisibility: false, notifications: notifications),
    );

    var sharedPreferences = locator.get<SharedPreferences>();
    String? token = sharedPreferences.getString("token");

    hubConnection = HubConnectionBuilder()
        .withUrl(
          "${baseUrl}nam/chatHub",
          options: HttpConnectionOptions(
            accessTokenFactory: () async =>
                token!, // Replace with your JWT token logic
          ),
        )
        .build();

    try {
      await hubConnection.start();
      hubConnection.on('ReciveNotification', _handleNotification);
      hubConnection.on("UpNotify", replaceNotification);
      print('SignalR Connection Establishedddddddd');
    } catch (error) {
      print('Error establishing SignalR connection: $error');
    }
  }

  void enableNotifications() {
    isNotificationVisible = true;
    emit(
      NotificationPageState(
          notificationVisibility: isNotificationVisible,
          notifications: notifications),
    );
  }

  void replaceNotification(dynamic notification){

  }

  void disableNotificationVisibility() {
    isNotificationVisible = false;
    List<Notificationn> newNotifications = [];
    for (var i in notifications) {
      i.IsRead = true;
      newNotifications.add(i);
    }
    notifications = newNotifications;
    emit(
      NotificationPageState(
          notificationVisibility: isNotificationVisible,
          notifications: notifications),
    );
  }

  void openPage() {
    emit(
      NotificationPageState(
          notificationVisibility: isNotificationVisible,
          notifications: notifications),
    );
  }

  readMessages() async {
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + readNotifyApi,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      print(e.response?.data);
    }
  }

  bool checkCreatedData(String data) {
    DateTime time = DateTime.parse(data);
    DateTime timeBefore = DateTime.now().subtract(const Duration(days: 15));
    return !time.isBefore(timeBefore);
  }

  String convertToJson(List<Notificationn> words) {
    List<Map<String, dynamic>> jsonData =
        words.map((word) => word.toJson()).toList();
    return jsonEncode(jsonData);
  }

  List<Notificationn> fromJSon(String json) {
    List<dynamic> jsonData = jsonDecode(json);
    return jsonData.map((map) => Notificationn.fromJson(map)).toList();
  }

  void _handleNotification(dynamic data) {
    notifications =
        (data[0] as List).map((e) => Notificationn.fromJson(e)).toList();

    print(notifications);

    emit(
      NotificationPageState(
          notificationVisibility: isNotificationVisible,
          notifications: notifications),
    );
  }

  void acceptJoin(String redirectId, Function(bool, String) fun) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + acceptJoinApi + redirectId,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      print(response.data);

      if (response.statusCode == 200) {
        fun(response.data['success'], response.data['message']);
      } else {
        fun(false, "Xəta baş verdi");
      }
    } on DioException catch (e) {
      print(e.response?.data);
      fun(false, "Xəta baş verdi");
    }
  }

  void rejectJoin(String redirectId, Function(bool, String) fun) async {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dio = locator.get<Dio>();
    var token = sharedPreferences.getString(tokenKey);

    try {
      var response = await dio.post(
        baseUrl + rejectJoinApi + redirectId,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        fun(true, "Oyunçu isdəyi qəbul edildi");
      } else {
        fun(false, "Xəta baş verdi");
      }
    } on DioException catch (e) {
      print(e.response?.data);
      fun(false, "Xəta baş verdi");
    }
  }
}
