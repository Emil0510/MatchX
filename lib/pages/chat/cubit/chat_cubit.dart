import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/network/model/Message.dart';
import 'package:flutter_app/network/network.dart';
import 'package:flutter_app/pages/chat/cubit/chat_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

class ChatPageCubit extends Cubit<ChatPageStates> {
  ChatPageCubit() : super(ChatPageInitialState());

  late final HubConnection hubConnection;
  bool isNotificationVisible = true;
  int active  = 0;
  final List<Message> messages = [
    Message(
        message: "message",
        username: "MatchX",
        isSystemMessage: false,
        isFirst: true,
        activeCount: 0)
  ];
  int coursingCount = 0;
  String username = "";

  start() async {
    emit(ChatPageLoadingState());
    var sharedPreferences = locator.get<SharedPreferences>();
    String? token = sharedPreferences.getString("token");
    String serverUrl = "http://matchxxx23-001-site1.htempurl.com/api/chatHub";
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
      emit(ChatPageMessagesState(null, false, active));

      print('SignalR Connection Established');
    } catch (error) {
      print('Error establishing SignalR connection: $error');
      emit(ChatPageErrorState());
    }
  }

  void _receiveOldMessages(dynamic data) {
    print(data);
    List<Message> oldMessages = (data[0]?['unReadMessages'] as List)
        .map((e) => Message.fromJson(e, false))
        .toList();
    var online = data[0]['online'];
    active = online;

    if (messages.length == 1) {
      messages.addAll(oldMessages);
      emit(ChatPageMessagesState(messages, isNotificationVisible, online));
    }

  }

  void _handleReceiveMessage(dynamic data) async {
    Message? message = Message.fromJson(data[0], false);
    active = message.activeCount??0;


    messages.add(message);
    print(data);

    print("Active: ${message.activeCount}");

    if (message.username == username) {
      if (message.isSystemMessage == true) {
        coursingCount++;
        locator.get<SharedPreferences>().setInt(countCursingKey, coursingCount);
        if (coursingCount % 5 == 0) {
          await locator.get<SharedPreferences>().setString(
              lockoutLimitForMessagingKey,
              DateTime.now().add(const Duration(hours: 1)).toString());
          emit(ChatPageMessageLockingState(
              messages.reversed.toList(), isNotificationVisible, active));
        } else {
          if (!isClosed) {
            emit(ChatPageMessagesState(
                messages.reversed.toList(), isNotificationVisible, active));
          }
        }
      } else {
        if (!isClosed) {
          emit(ChatPageMessagesState(
              messages.reversed.toList(), isNotificationVisible, message.activeCount??0));
        }
      }
    } else {
      if (!isClosed) {
        emit(ChatPageMessagesState(
            messages.reversed.toList(), isNotificationVisible, message.activeCount??0));
      }
    }
  }

  void disableNotificationVisibility() {
    isNotificationVisible = false;
    emit(ChatPageMessagesState(
        messages.reversed.toList(), isNotificationVisible, active));
  }

  void sendMessage(String message) {
    isNotificationVisible = false;
    hubConnection.invoke('SendMessage', args: [message]);
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
    print(lockOutTime);
    if (coursingCount % 5 == 0) {
      if (!isBefore) {
        emit(ChatPageMessageLockingState(
            messages.reversed.toList(), isNotificationVisible, active));
      }
    }
  }
}
