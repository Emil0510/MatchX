import 'package:flutter/material.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_cubit.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_states.dart';
import 'package:flutter_app/pages/notification_page/widgets/notification_items.dart';
import 'package:flutter_app/widgets/container.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Constants.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        title: const Text(
          "Bildirimlər",
          style: TextStyle(color: Color(goldColor)),
        ),
      ),
      body: CustomContainer(
          color: Colors.black,
          child: BlocBuilder<NotificationCubit, NotificationStates>(
            builder: (context, state) {
              if (state is NotificationPageState) {
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<NotificationCubit>().refreshNotifications();
                    await Future.delayed(const Duration(seconds: 1));
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: state.notifications.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return NotificationItem(
                          notification: state.notifications[index],
                        );
                      },
                    ),
                  ),
                );
              } else {
                return const SizedBox();
              }
            },
          )

          // ElevatedButton(
          //   onPressed: () {
          //     AwesomeNotifications().createNotification(
          //         content: NotificationContent(
          //           id: 10,
          //           channelKey: 'basic_channel',
          //           actionType: ActionType.Default,
          //           title: 'Hello World!',
          //           body: 'This is my first notification!',
          //         )
          //     );
          //   }, child: Text("Click"),
          // ),
          ),
    );
  }
}
