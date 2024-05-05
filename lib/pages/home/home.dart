import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/chat/cubit/chat_cubit.dart';
import 'package:flutter_app/pages/chat/cubit/chat_states.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_cubit.dart';
import 'package:flutter_app/pages/notification_page/notification_cubit/notification_states.dart';
import 'package:flutter_app/pages/notification_page/notification_page.dart';
import 'package:flutter_app/pages/options/cubit/options_cubit.dart';
import 'package:flutter_app/pages/options/cubit/options_logic.dart';
import 'package:flutter_app/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../utils/NotificationController.dart';
import '../chat/ui/chat_page.dart';
import 'divisions_page/ui/divisions_page.dart';
import 'home_cubit/home_cubit.dart';
import 'home_page/ui/home_page.dart';
import 'matches_page/matches_page.dart';
import 'more_page/more_page.dart';
import 'team_page/ui/TeamPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    // Only after at least the action method is set, the notification events are delivered
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    print("Salam");
  }

  @override
  Widget build(BuildContext context) {
    print("Salam");
    return WillPopScope(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: const Text(
            "MatchX",
            style: TextStyle(color: Color(0xfff59e0b)),
          ),
          backgroundColor: Colors.black,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              color: Colors.grey,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider<OptionsCubit>(
                        create: (BuildContext context) =>
                            OptionsCubit()..start(),
                        child: const OptionsLogics()),
                  ),
                );
              },
            ),
            BlocBuilder<ChatPageCubit, ChatPageStates>(
              builder: (BuildContext context, state) {
                if (state is ChatPageMessagesState) {
                  context.read<ChatPageCubit>().isNotificationVisible = true;
                }
                return CustomMessageIconButton(
                  visible: (state is ChatPageMessagesState)
                      ? state.notificationVisibility
                      : false,
                  onPressed: () {
                    var cubit = BlocProvider.of<ChatPageCubit>(context);
                    cubit.disableNotificationVisibility();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: cubit,
                          child: const ChatPage(),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            BlocBuilder<NotificationCubit, NotificationStates>(
              builder: (context, states) {
                if (states is NotificationPageState) {
                  for (int i = 0; i < states.notifications.length; i++) {
                    if (states.notifications[i].IsRead == false) {
                      context.read<NotificationCubit>().enableNotifications();
                      break;
                    }
                  }
                }
                return CustomNotificationIconButton(
                    onPressed: () {
                      var cubit = BlocProvider.of<NotificationCubit>(context);
                      cubit.disableNotificationVisibility();
                      cubit.readMessages();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider.value(
                            value: cubit..openPage(),
                            child: const NotificationInitPage(),
                          ),
                        ),
                      );
                    },
                    visible: (states is NotificationPageState)
                        ? states.notificationVisibility
                        : false);
              },
            )
          ],
        ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: BlocBuilder<HomeCubits, BottomNavigationItem>(
            builder: (BuildContext context, state) {
              switch (state) {
                case BottomNavigationItem.home:
                  return const HomePage();
                case BottomNavigationItem.matches:
                  return const MatchesPage();
                case BottomNavigationItem.stadiums:
                  return const DivisionPage();
                case BottomNavigationItem.teams:
                  return const TeamPage();
                case BottomNavigationItem.more:
                  return const MorePage();
                default:
                  return const HomePage();
              }
            },
          ),
        ),
        bottomNavigationBar: BlocBuilder<HomeCubits, BottomNavigationItem>(
          builder: (BuildContext context, state) {
            return BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Ev',
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.soccerBall),
                  label: 'Oyunlar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.shield_sharp),
                  label: 'Diviziyalar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt_rounded),
                  label: 'Komandalar',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Profil',
                ),
              ],
              currentIndex: BottomNavigationItem.values.indexOf(state),
              unselectedItemColor: Colors.white,
              selectedItemColor: const Color(0xfff59e0b),
              onTap: (index) {
                final newItem = BottomNavigationItem.values[index];
                context.read<HomeCubits>().switchBottomNavigation(newItem);
              },
              backgroundColor: Colors.black,
              type: BottomNavigationBarType.fixed,
            );
          },
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }
}

abstract class Refreshable {
  void onBckButtonClicked();
}
