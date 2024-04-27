import 'package:flutter/material.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_cubit.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_logics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationInitPage extends StatelessWidget {
  const NotificationInitPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const NotificationLogics();
  }
}
