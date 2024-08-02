import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../network/model/Notification.dart';
import '../../user/user_cubit/user_logics.dart';
import '../notification_cubit/notification_cubit.dart';

class NotificationItem extends StatefulWidget {
  final Notificationn notification;

  const NotificationItem({super.key, required this.notification});

  @override
  State<NotificationItem> createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(blackColor2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Icon(
                        Icons.access_time,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        getNotificationDate(widget.notification.CreatedAt),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                InkWell(
                  onTap: () {
                    if (widget.notification.From != "MatchX") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UserLogics(username: widget.notification.From)),
                      );
                    }
                  },
                  splashColor: Colors.grey,
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Kimdən: ${widget.notification.From}",
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.notification.Title,
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8, right: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  widget.notification.Description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            widget.notification.IsInformation
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  if (!isLoading) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    context
                                        .read<NotificationCubit>()
                                        .rejectJoin(
                                      widget.notification.IdForDirect ?? "",
                                      (isSuccesfull, message) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showCustomSnackbar(context, message);
                                        context
                                            .read<NotificationCubit>()
                                            .refreshNotifications();
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(redColor)),
                                child: const Text(
                                  "Rədd et",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                        isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  if (!isLoading) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    context
                                        .read<NotificationCubit>()
                                        .acceptJoin(
                                      widget.notification.IdForDirect ?? "",
                                      (isSuccesfull, message) {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        showCustomSnackbar(context, message);
                                        context
                                            .read<NotificationCubit>()
                                            .refreshNotifications();
                                      },
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(greenColor)),
                                child: const Text(
                                  "Qəbul et",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )
                      ],
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
