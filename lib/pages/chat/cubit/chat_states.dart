import 'package:equatable/equatable.dart';

import '../../../network/model/Message.dart';

abstract class ChatPageStates {}

class ChatPageInitialState extends ChatPageStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}
class ChatPageLoadingState extends ChatPageStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}


class ChatPageErrorState extends ChatPageStates{
  @override
  List<Object?> get props => throw UnimplementedError();

}

class ChatPageMessagesState extends ChatPageStates{

  final List<Message>? newMessages;
  final bool notificationVisibility;
  final int onlineCount;
  ChatPageMessagesState(this.newMessages, this.notificationVisibility, this.onlineCount);

  @override
  List<Object?> get props => [newMessages, notificationVisibility];
}

class ChatPageMessageLockingState extends ChatPageStates{

  final List<Message>? newMessages;
  final bool notificationVisibility;
  final int onlineCount;
  ChatPageMessageLockingState(this.newMessages, this.notificationVisibility, this.onlineCount);

  @override
  List<Object?> get props => [newMessages, notificationVisibility];
}


