import 'dart:async';
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/pages/chat/cubit/chat_cubit.dart';
import 'package:flutter_app/pages/chat/cubit/chat_states.dart';
import 'package:flutter_app/pages/chat/widgets/chat_top_widget.dart';
import 'package:flutter_app/pages/user/user_cubit/user_logics.dart';
import 'package:flutter_app/widgets/container.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../network/model/Message.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController textEditingController;
  late ScrollController scrollController;
  late String username;
  late SuperTooltipController superToolTipController;
  late List<Message>? messages;
  bool inputLocked = false;
  late Timer? timer;
  int secondsDuration = 0;
  int hoursDuration = 0;
  int minutesDuration = 0;

  bool isLoading = true;

  bool messageLocked = false;
  String string = "Banın açılma müddəti: ";

  int onlineUser = 0;

  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    var sharedPreferences = locator.get<SharedPreferences>();
    username = sharedPreferences.getString("username") ?? "";
    superToolTipController = SuperTooltipController();
    context.read<ChatPageCubit>().checkCoursing();
  }

  void viewProfile() {}

  void invite() {}

  void viewTeam() {

  }

  void startTimer() {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dateString = sharedPreferences.getString(lockoutLimitForMessagingKey);
    DateTime lockOutTime = DateTime.parse(dateString!);
    var difference = lockOutTime.difference(DateTime.now());
    var duration = lockOutTime.subtract(difference);
    print(difference);

    hoursDuration = difference.inHours;
    minutesDuration = difference.inMinutes.remainder(60);
    secondsDuration = difference.inSeconds.remainder(60);

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (secondsDuration > 0) {
          secondsDuration--;
        } else {
          if (minutesDuration > 0) {
            secondsDuration = 59;
            minutesDuration--;
          } else {
            if (hoursDuration > 0) {
              minutesDuration = 59;
              secondsDuration = 59;
            } else {
              timer.cancel();
              inputLocked = false;
              messageLocked = false;
              // context.read<ChatPageCubit>().disableNotificationVisibility();
            }
          }
        }
        textEditingController.text =
            "$string$hoursDuration:${minutesDuration > 9 ? minutesDuration : "0$minutesDuration"}:${secondsDuration > 9 ? secondsDuration : "0$secondsDuration"}";
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    textEditingController.dispose();
    scrollController.dispose();
    superToolTipController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return BlocBuilder<ChatPageCubit, ChatPageStates>(
      builder: (BuildContext context, ChatPageStates state) {
        if(state is ChatPageMessagesState){
          print("Chat");
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(state.onlineCount>0) {
              setState(() {
                isLoading = false;
              });
            }
          });
        }
        if (state is ChatPageMessageLockingState) {
          print("Lock  Chat");
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if(state.onlineCount>0) {
              setState(() {
                isLoading = false;
              });
            }
          });
          if (!messageLocked) {
            SchedulerBinding.instance.addPostFrameCallback((_) {
              inputLocked = true;
              messageLocked = true;
              textEditingController.text = "${string}00:00:00";
              startTimer();
            });
          }
        }
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
            elevation: 0,
            title: Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Söhbət",
                      style: TextStyle(color: Color(goldColor)),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Online: ${(state is ChatPageMessagesState) ? state.onlineCount : "0"}",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: CustomContainer(
              color: const Color(blackColor2),
              child: isLoading? const Center(child: CircularLoadingWidget()) : Column(
                children: [
                  Expanded(
                    child:
                        // context.read<ChatPageCubit>().isNotificationVisible = false;
                        Padding(
                        padding: const EdgeInsets.all(8.0),
                         child: Builder(
                          builder: (BuildContext context) {
                          if (state is ChatPageMessagesState) {
                            if (state.newMessages == null) {
                              return const SizedBox();
                            } else {
                              return ListView.builder(
                                controller: scrollController,
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                reverse: true,
                                itemCount: state.newMessages?.length,
                                itemBuilder: (context, index) {
                                  return Align(
                                    alignment: (!state
                                            .newMessages![index].isFirst)
                                        ? (state.newMessages?[index].username ==
                                                username)
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft
                                        : Alignment.topCenter,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: (state.newMessages![index].isFirst)
                                          ? const ChatTopMessage()
                                          : Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                (index !=
                                                            state.newMessages!
                                                                    .length -
                                                                1 &&
                                                        state
                                                                .newMessages![
                                                                    index]
                                                                .username ==
                                                            state
                                                                .newMessages![
                                                                    index + 1]
                                                                .username)
                                                    ? const SizedBox()
                                                    : Text(
                                                        state
                                                            .newMessages![index]
                                                            .username,
                                                        style: const TextStyle(
                                                            color:
                                                                Colors.white),
                                                      ),
                                                AbsorbPointer(
                                                  absorbing: state
                                                          .newMessages?[index]
                                                          .username ==
                                                      username,
                                                  child: SuperTooltip(
                                                    showBarrier: true,
                                                    content: SizedBox(
                                                      width: width / 4,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(state
                                                              .newMessages![
                                                                  index]
                                                              .username),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(builder: (context) => UserLogics(username: state.newMessages?[index].username ?? "")),
                                                              );
                                                            },
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xB8B98638),
                                                            ),
                                                            child: const Text(
                                                              "Profile",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {},
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xB8B98638),
                                                            ),
                                                            child: state.newMessages?[index].myTeamId != null
                                                                ? const Text(
                                                                    "Team",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  )
                                                                : const Text(
                                                                    "Invite",
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .black),
                                                                  ),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                    popupDirection:
                                                        TooltipDirection.right,
                                                    child: Container(
                                                      constraints:
                                                          BoxConstraints(
                                                              maxWidth: width *
                                                                  3 /
                                                                  4),
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                        color: state
                                                                    .newMessages?[
                                                                        index]
                                                                    .username ==
                                                                username
                                                            ? const Color(
                                                                0xB8B98638)
                                                            : const Color(
                                                                0xFF282828),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          state
                                                              .newMessages![
                                                                  index]
                                                              .message,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 16),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  );
                                },
                              );
                            }
                          } else if (state is ChatPageMessageLockingState) {
                            return ListView.builder(
                              controller: scrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              reverse: true,
                              itemCount: state.newMessages?.length,
                              itemBuilder: (context, index) {
                                return Align(
                                  alignment: (!state
                                          .newMessages![index].isFirst)
                                      ? (state.newMessages?[index].username ==
                                              username)
                                          ? Alignment.centerRight
                                          : Alignment.centerLeft
                                      : Alignment.topCenter,
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: (state.newMessages![index].isFirst)
                                        ? const ChatTopMessage()
                                        : Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              (index !=
                                                          state.newMessages!
                                                                  .length -
                                                              1 &&
                                                      state.newMessages![index]
                                                              .username ==
                                                          state
                                                              .newMessages![
                                                                  index + 1]
                                                              .username)
                                                  ? const SizedBox()
                                                  : Text(
                                                      state.newMessages![index]
                                                          .username,
                                                      style: const TextStyle(
                                                          color: Colors.white),
                                                    ),
                                              AbsorbPointer(
                                                absorbing: state
                                                        .newMessages?[index]
                                                        .username ==
                                                    username,
                                                child: SuperTooltip(
                                                  showBarrier: true,
                                                  content: SizedBox(
                                                    width: width / 4,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(state
                                                            .newMessages![index]
                                                            .username),
                                                        ElevatedButton(
                                                          onPressed: () {
                                                            Navigator.push(
                                                              context,
                                                              MaterialPageRoute(builder: (context) => UserLogics(username: state.newMessages?[index].username ?? "")),
                                                            );
                                                          },
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xB8B98638),
                                                          ),
                                                          child: const Text(
                                                            "Profile",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                        ElevatedButton(
                                                          onPressed: () {},
                                                          style: ElevatedButton
                                                              .styleFrom(
                                                            backgroundColor:
                                                                const Color(
                                                                    0xB8B98638),
                                                          ),
                                                          child: state
                                                                      .newMessages?[
                                                                          index]
                                                                      .myTeamId !=
                                                                  null
                                                              ? const Text(
                                                                  "Team",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              : const Text(
                                                                  "Invite",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  popupDirection:
                                                      TooltipDirection.right,
                                                  child: Container(
                                                    constraints: BoxConstraints(
                                                        maxWidth:
                                                            width * 3 / 4),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      color: state
                                                                  .newMessages?[
                                                                      index]
                                                                  .username ==
                                                              username
                                                          ? const Color(
                                                              0xB8B98638)
                                                          : const Color(
                                                              0xFF282828),
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        state
                                                            .newMessages![index]
                                                            .message,
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 16),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                  ),
                                );
                              },
                            );
                          } else if (state is ChatPageErrorState) {
                            return const Center(
                              child: Text("Error"),
                            );
                          } else if (state is ChatPageLoadingState) {
                            return const CircularLoadingWidget();
                          } else {
                            return const CircularLoadingWidget();
                          }
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        left: 8, right: 8, top: 8, bottom: height / 25),
                    child: TextFormField(
                      readOnly: inputLocked,
                      controller: textEditingController,
                      onChanged: (valur) {},
                      style: TextStyle(
                          color: inputLocked ? Colors.grey : Colors.white,
                          fontSize: width / 30),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.black,
                        hintText: inputLocked ? "" : "Mesaj yaz...",
                        hintStyle:
                            TextStyle(color: Colors.grey, fontSize: width / 30),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none),
                        suffixIcon: IconButton(
                          color: Colors.grey,
                          onPressed: () {
                            if (!inputLocked) {
                              String text =
                                  textEditingController.text.toString().trim();
                              textEditingController.clear();
                              if (text != "") {
                                context.read<ChatPageCubit>().sendMessage(text);
                                scrollController.animateTo(
                                    scrollController.position.minScrollExtent,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeIn);
                              }
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ),
                    ),
                  ),
                ],
              )),
        );
      },
    );
  }
}
