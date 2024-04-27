import 'package:flutter/material.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';

import '../../../network/model/Notification.dart';

class NotificationItem extends StatelessWidget {
  final Function acceptJoin;
  final Function rejectJoin;
  final Notificationn notification;

  const NotificationItem(
      {super.key,
      required this.notification,
      required this.acceptJoin,
      required this.rejectJoin});

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
                        getNotificationDate(notification.CreatedAt),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    )
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      textAlign: TextAlign.end,
                      "Kimdən: ${notification.From}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  notification.Title,
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
                  notification.Description,
                  textAlign: TextAlign.start,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            notification.IsInformation
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              rejectJoin();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color(redColor)),
                            child: const Text("Rədd et",
                                style: TextStyle(color: Colors.white))),
                        ElevatedButton(
                          onPressed: () {
                            acceptJoin();
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
