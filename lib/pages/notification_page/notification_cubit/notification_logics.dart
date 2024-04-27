import 'package:flutter/material.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_cubit.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_states.dart';
import 'package:flutter_app/pages/notification_page/ui/NotificationPage.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationLogics extends StatefulWidget {
  const NotificationLogics({super.key});

  @override
  State<NotificationLogics> createState() => _NotificationLogicsState();
}

class _NotificationLogicsState extends State<NotificationLogics> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, NotificationStates>(
        builder: (context, state) {
          if(state is NotificationLoadingState){
            return const CircularLoadingWidget();
          }else if(state is NotificationPageState){
            return const NotificationPage();
          }else{
            return const CircularLoadingWidget();
          }
        });
  }
}
