import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Constants.dart';
import 'package:flutter_app/Utils.dart';
import 'package:flutter_app/pages/chat/cubit/chat_cubit.dart';
import 'package:flutter_app/pages/chat/ui/ban_bottom_sheet.dart';
import 'package:flutter_app/pages/chat/ui/report_bottom_sheet.dart';
import 'package:flutter_app/pages/chat/widgets/chat_tooltip_button.dart';
import 'package:flutter_app/pages/chat/widgets/chat_top_widget.dart';
import 'package:flutter_app/pages/user/user_cubit/user_logics.dart';
import 'package:flutter_app/widgets/buttons_widgets.dart';
import 'package:flutter_app/widgets/container.dart';
import 'package:flutter_app/widgets/input_text_widgets.dart';
import 'package:flutter_app/widgets/loading_widget.dart';
import 'package:flutter_app/widgets/snackbar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';

import '../../../network/model/Message.dart';
import '../../home/team_page/team_detail_cubit/team_detail_cubit.dart';
import '../../home/team_page/ui/TeamDetailPage.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late TextEditingController textEditingController;
  late ScrollController scrollController;
  late String username;
  bool inputLocked = false;
  late Timer? timer;
  int secondsDuration = 0;
  int hoursDuration = 0;
  int minutesDuration = 0;
  bool isLoading = true;
  bool messageLocked = false;

  String string = "Banın açılma müddəti: ";
  int onlineUser = 0;

  List<Message> messages = [];
  List<SuperTooltipController> controllers = [];

  @override
  void initState() {
    super.initState();
    var sharedPreferences = locator.get<SharedPreferences>();
    username = sharedPreferences.getString("username") ?? "";
    textEditingController = TextEditingController();
    scrollController = ScrollController();
    controllers = [];

    timer = Timer(const Duration(seconds: 1), () {});

    context.read<ChatPageCubit>().setCallback((message, isBlock, isLoadingg) {
      //make tool tip controller
      controllers.clear();
      for (int i = 0; i < message.length; i++) {
        controllers.add(SuperTooltipController());
      }
      setState(() {
        messages = message;
        isLoading = isLoadingg;
        if (!messageLocked && isBlock) {
          inputLocked = true;
          messageLocked = true;
          textEditingController.text = "${string}00:00:00";
          startTimer();
        }
      });
    });

    context.read<ChatPageCubit>().checkCoursing();
  }

  void startTimer() {
    var sharedPreferences = locator.get<SharedPreferences>();
    var dateString = sharedPreferences.getString(lockoutLimitForMessagingKey);
    DateTime lockOutTime = DateTime.parse(dateString!);
    var difference = lockOutTime.difference(DateTime.now());

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

  Future<bool> _willPopCallback(
      SuperTooltipController superTooltipController) async {
    // If the tooltip is open we don't pop the page on a backbutton press
    // but close the ToolTip
    if (superTooltipController.isVisible) {
      await superTooltipController.hideTooltip();
      return false;
    }
    return true;
  }

  void onBanClicked(BuildContext context, String username) {
    var cubit = context.read<ChatPageCubit>();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(
            value: cubit, child: BanBottomSheet(username: username,));
      },
    );
  }

  void onReportClicked(BuildContext context, String username) {
    var cubit = context.read<ChatPageCubit>();
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return BlocProvider.value(
            value: cubit, child: ReportBottomSheet(username: username,));
      },
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    textEditingController.dispose();
    scrollController.dispose();
    for (var i in controllers) {
      i.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
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
                  "Online: ${messages[0].activeCount}",
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: CustomContainer(
          color: const Color(blackColor2),
          child: isLoading
              ? const Center(child: CircularLoadingWidget())
              : Column(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView.builder(
                          controller: scrollController,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return Align(
                              alignment: (messages[index].isFirst)
                                  ? (messages[index].username == username)
                                      ? Alignment.centerRight
                                      : Alignment.centerLeft
                                  : Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: (messages[index].isFirst)
                                    ? const ChatTopMessage()
                                    : Align(
                                        alignment: (messages[index].username ==
                                                username)
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            (index != messages.length - 1 &&
                                                    messages[index].username ==
                                                        messages[index + 1]
                                                            .username)
                                                ? const SizedBox()
                                                : SuperTooltip(
                                                    showBarrier: true,
                                                    controller:
                                                        controllers[index],
                                                    content: SizedBox(
                                                      width: width / 4,
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(messages[index]
                                                              .username),
                                                          messages[index]
                                                                      .username ==
                                                                  getMyUsername()
                                                              ? const SizedBox()
                                                              : ChatTooltipButton(
                                                                  onPressed:
                                                                      () {
                                                                    _willPopCallback(
                                                                        controllers[
                                                                            index]);
                                                                    Navigator
                                                                        .push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                UserLogics(username: messages[index].username),
                                                                      ),
                                                                    );
                                                                  },
                                                                  text:
                                                                      "Profile",
                                                                ),
                                                          messages[index]
                                                                      .username ==
                                                                  getMyUsername()
                                                              ? const SizedBox()
                                                              : messages[index]
                                                                          .myTeamId ==
                                                                      null
                                                                  ? const SizedBox()
                                                                  : ChatTooltipButton(
                                                                      onPressed:
                                                                          () {
                                                                        if (messages[index].myTeamId !=
                                                                            null) {
                                                                          _willPopCallback(
                                                                              controllers[index]);
                                                                          Navigator
                                                                              .push(
                                                                            context,
                                                                            MaterialPageRoute(
                                                                              builder: (context) => BlocProvider(
                                                                                create: (context) => TeamDetailCubit()..startTeamDetail(messages[index].myTeamId ?? ""),
                                                                                child: const TeamDetailPage(teamName: "Komanda"),
                                                                              ),
                                                                            ),
                                                                          );
                                                                        } else {
                                                                          //Invite to Team
                                                                          // showToastMessage(
                                                                          //     context,
                                                                          //     "Invite Team");
                                                                        }
                                                                      },
                                                                      text:
                                                                          "Komanda",
                                                                    ),
                                                          ChatTooltipButton(
                                                              onPressed: () {
                                                                _willPopCallback(
                                                                    controllers[
                                                                        index]);
                                                                Clipboard.setData(
                                                                    ClipboardData(
                                                                        text: messages[index]
                                                                            .message));
                                                                showCustomSnackbar(
                                                                    context,
                                                                    "Mesaj kopyalandı");
                                                              },
                                                              text:
                                                                  "Mesajı kopyala"),
                                                          messages[index]
                                                                      .username ==
                                                                  getMyUsername()
                                                              ? const SizedBox()
                                                              : ChatTooltipButton(
                                                                  onPressed:
                                                                      () {
                                                                    _willPopCallback(
                                                                        controllers[
                                                                            index]);
                                                                    onReportClicked(
                                                                        context, messages[index].username);
                                                                  },
                                                                  text:
                                                                      "Şikayət et"),
                                                          messages[index]
                                                                      .username ==
                                                                  getMyUsername()
                                                              ? const SizedBox()
                                                              : ChatTooltipButton(
                                                                  onPressed:
                                                                      () {
                                                                    _willPopCallback(
                                                                        controllers[
                                                                            index]);
                                                                    onBanClicked(
                                                                        context, messages[index].username);
                                                                  },
                                                                  text:
                                                                      "Banla"),
                                                        ],
                                                      ),
                                                    ),
                                                    popupDirection: messages[
                                                                    index]
                                                                .username ==
                                                            getMyUsername()
                                                        ? TooltipDirection.left
                                                        : TooltipDirection
                                                            .right,
                                                    child: GestureDetector(
                                                      onLongPress: () {
                                                        if (messages[index]
                                                                .username !=
                                                            getMyUsername()) {
                                                          controllers[index]
                                                              .showTooltip();
                                                        }
                                                      },
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            messages[index]
                                                                .username,
                                                            style:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .white),
                                                          ),
                                                          Container(
                                                            constraints:
                                                                BoxConstraints(
                                                                    maxWidth:
                                                                        width *
                                                                            3 /
                                                                            4),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          8),
                                                              color: messages[index]
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
                                                              child:
                                                                  IgnorePointer(
                                                                child:
                                                                    SelectableText(
                                                                  messages[
                                                                          index]
                                                                      .message,
                                                                  style: const TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),
                              ),
                            );
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
                          hintStyle: TextStyle(
                              color: Colors.grey, fontSize: width / 30),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none),
                          suffixIcon: IconButton(
                            color: Colors.grey,
                            onPressed: () {
                              if (!inputLocked) {
                                String text = textEditingController.text
                                    .toString()
                                    .trim();
                                textEditingController.clear();
                                if (text != "") {
                                  context
                                      .read<ChatPageCubit>()
                                      .sendMessage(text);
                                  scrollController.animateTo(
                                      scrollController.position.minScrollExtent,
                                      duration:
                                          const Duration(milliseconds: 200),
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
                ),
        ),
      ),
    );
  }
}
