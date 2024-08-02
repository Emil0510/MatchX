import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/network/model/Message.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/chat/cubit/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';
import '../../../data.dart';
import '../../../widgets/snackbar.dart';
import '../../home/divisions_page/division_cubit/division_cubit.dart';
import '../../home/home_page/cubit/home_page_cubit.dart';
import '../../home/matches_page/mathches_cubit/matches_cubit.dart';
import '../../home/more_page/more_cubit/more_page_cubit.dart';
import '../../home/team_page/team_cubit/team_cubit.dart';
import '../../sign_in_sign_up/login_signup.dart';

import 'dart:io' show Platform;

class ChatPageCubit extends Cubit<ChatPageStates> {
  ChatPageCubit() : super(ChatPageInitialState());

  late final HubConnection hubConnection;
  bool isNotificationVisible = true;
  int active = 0;
  Function(List<Message>, bool, bool) callback =
      (List<Message> list, bool test, bool test1) {};
  late BuildContext context;
  bool isLoading = true;
  List<Message> messages = [
    Message(
        message: "message",
        username: "MatchX",
        isSystemMessage: false,
        isFirst: true,
        activeCount: 0,
        tagUserName: "")
  ];
  int coursingCount = 0;
  String username = "";

  start(BuildContext context) async {
    this.context = context;
    emit(ChatPageLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    String? token = sharedPreferences.getString("token");
    username = sharedPreferences.getString(usernameKey) ?? "";

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
      hubConnection.on('ReceiveMessage', _handleReceiveMessage);
      hubConnection.on("ReciveOldMessages", _receiveOldMessages);
      hubConnection.on("UnAuth", _checkUserSingleness);
      emit(ChatPageMessagesState(messages, true, active));
    } catch (error) {
      emit(ChatPageErrorState());
    }
  }

  void _checkUserSingleness(dynamic isSucces) async {
    var sharedPreferences = locator.get<SharedPreferences>();

    if (!isSucces[0]) {
      await sharedPreferences.clear();
      await sharedPreferences.setBool(shouldShowOnboardKey, false);
      homePageCubit = HomePageCubit();
      matchesPageCubit = MatchesCubit();
      teamPageCubit = TeamCubit();
      morePageCubit = MorePageCubit();
      divisionPageCubit = DivisionCubit();
      showCustomSnackbar(
          context, "Hesabınıza başqa cihaz tərəfindən daxil olunub!");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const SignInSignUp(),
        ),
        (e) => false,
      );
    }
  }

  void _receiveOldMessages(dynamic data) {
    active = data[0]['online'];
    List<Message> oldMessages = (data[0]?['unReadMessages'] as List)
        .map((e) => Message.fromJson(e, false))
        .toList();

    if (messages.length == 1) {
      messages.addAll(oldMessages);
      isLoading = false;
      messages[messages.length - 1].activeCount = active;
      callback(messages.reversed.toList(), false, isLoading);
      emit(ChatPageMessagesState(messages, isNotificationVisible, 0));
    }
  }

  void _handleReceiveMessage(dynamic data) async {
    Message? message = Message.fromJson(data[0], false);
    active = message.activeCount ?? 0;
    messages.add(message);

    if (message.tagUserName != "" && message.tagUserName == getMyUsername()) {
      AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          actionType: ActionType.Default,
          title: '${message.username} sizi tağ etdi!',
          body: message.message,
          icon:
              Platform.isAndroid ? 'resource://drawable/ic_notification' : null,
        ),
      );
    }

    if (message.username == username) {
      if (message.isSystemMessage == true) {
        coursingCount++;
        locator.get<SharedPreferences>().setInt(countCursingKey, coursingCount);
        if (coursingCount % 5 == 0) {
          await locator.get<SharedPreferences>().setString(
              lockoutLimitForMessagingKey,
              DateTime.now().add(const Duration(hours: 1)).toString());

          emit(ChatPageMessageLockingState(messages, true, 0));
          callback(messages.reversed.toList(), true, isLoading);
        } else {
          emit(ChatPageMessagesState(messages, true, 0));
          callback(messages.reversed.toList(), false, isLoading);
        }
      } else {
        emit(ChatPageMessagesState(messages, true, 0));
        callback(messages.reversed.toList(), false, isLoading);
      }
    } else {
      emit(ChatPageMessagesState(messages, true, 0));
      callback(messages.reversed.toList(), false, isLoading);
    }
  }

  void disableNotificationVisibility() {
    isNotificationVisible = false;
    emit(ChatPageMessagesState(
        messages.reversed.toList(), isNotificationVisible, active));
  }

  void setCallback(Function(List<Message>, bool, bool) fun) {
    callback = fun;
    callback(messages.reversed.toList(), false, isLoading);
  }

  void sendMessage(String message) {
    isNotificationVisible = false;
    hubConnection.invoke('SendMessage', args: [message]);
  }

  void reportUser(String username, String reason, Function(bool) callback) async{
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);
    try {
      var response = await dio.post(baseUrl + reportUserApi,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          queryParameters: {"username": username, "reason": reason});

      if(response.statusCode == 200){
        showCustomSnackbar(context, response.data['message']);
        callback(true);
      }else{
        showCustomSnackbar(context, response.data['message']);
        callback(false);
      }
    } on DioException catch (e) {
      callback(false);
      showCustomSnackbar(context, e.response?.data['message']);
    }
  }

  void banUser(String username, String reason, Function(bool, String) callback)async{
    var dio = locator.get<Dio>();
    var sharedPreferences = locator.get<SharedPreferences>();
    var token = sharedPreferences.getString(tokenKey);
    try {
      var response = await dio.post(baseUrl + banUserApi,
          options: Options(
            headers: {"Authorization": "Bearer $token"},
          ),
          queryParameters: {"username": username, "reason": reason});

      if(response.statusCode == 200){
        callback(true,  response.data['message']);
        filterBanMessage(username);
      }else{
        callback(false,  response.data['message']);
      }
    } on DioException catch (e) {
      callback(false, e.response?.data['message']);
    }
  }

  void filterBanMessage(String username){
    var list = messages;
    messages = list.where((element) => element.username!=username).toList();
    messages[messages.length - 1].activeCount = active;
    callback(messages.reversed.toList(), false, isLoading);
  }

  void checkCoursing() {
    var sharedPreferences = locator.get<SharedPreferences>();
    coursingCount = sharedPreferences.getInt(countCursingKey) ?? 0;
    var lockOutTime =
        sharedPreferences.getString(lockoutLimitForMessagingKey) ?? "";
    bool isBefore = true;

    if (!(lockOutTime == "")) {
      var time = DateTime.parse(lockOutTime);
      isBefore = time.isBefore(DateTime.now());
    }

    if (coursingCount % 5 == 0) {
      if (!isBefore) {
        callback(messages.reversed.toList(), true, isLoading);
        emit(ChatPageMessageLockingState(messages, true, 0));
      }
    }
  }
}
