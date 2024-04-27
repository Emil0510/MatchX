import 'package:equatable/equatable.dart';

import '../../../network/model/Notification.dart';

abstract class NotificationStates extends Equatable{}

class NotificationInitialState extends NotificationStates{
  @override
  List<Object?> get props => [];

}

class NotificationLoadingState extends NotificationStates{
  @override
  List<Object?> get props => [];

}

class NotificationErrorState extends NotificationStates{
  @override
  List<Object?> get props => [];

}

class NotificationPageState extends NotificationStates{
  List<Notificationn> notifications;
  final bool notificationVisibility;

  NotificationPageState({required this.notificationVisibility, required this.notifications});

  @override
  List<Object?> get props => [notifications, notificationVisibility];

}