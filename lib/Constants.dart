import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

const int goldColor = 0xfff59e0b;
const int blackColor = 0xff1B2430;
const int blackColor2 = 0xff101010;
const int darkGray = 0xFF0C0A09;
const int greenColor = 0xFF23BE5C;
const int brownColor = 0xFF834B10;
const int openBrownColor = 0xFFEE8F3B;
const int redColor = 0xFFA73332;
const int grayColor2 = 0xFF292525;
const int darkGray2 = 0xFF0D0C0A;
const int darkGray3 = 0xff000b11;
const int blackColor3 = 0xFF232323;
final locator = GetIt.instance;

const String isLoggedInKey = "isLoggedIn";
const String tokenKey = "token";
const String usernameKey = "username";
const String myTeamIdKey = "myTeamId";
const String rolesKey = "roles";
const String tokenExpireDayKey = "tokenExpireDay";
const String shouldShowOnboardKey = "shouldShowOnboard";
const String countCursingKey = "countCursing";
const String lockoutLimitForMessagingKey = "lockoutLimitForMessaging";
const String localNotificationsKey = "localNotifications";
const String phoneNumberKey = "phoneNumberKey";

const List<String> regionsConstants = [
  "Abşeron",
  "Ağcabədi",
  "Ağdam",
  "Ağdaş",
  "Ağstafa",
  "Ağsu",
  "Astara",
  "Bakı",
  "Balakən",
  "Bərdə",
  "Beyləqan",
  "Biləsuvar",
  "Cəbrayıl",
  "Cəlilabad",
  "Daşkəsən",
  "Füzuli",
  "Gəncə",
  "Gədəbbəy",
  "Göyçay",
  "Göygöl",
  "Görəle",
  "Hacıqabul",
  "Xaçmaz",
  "Xankəndi",
  "Xızı",
  "Xocalı",
  "Xocavənd",
  "İmişli",
  "İsmayıllı",
  "Kəlbəcər",
  "Kürdəmir",
  "Qax",
  "Qazax",
  "Qəbələ",
  "Qobustan",
  "Quba",
  "Qubadlı",
  "Qusar",
  "Laçın",
  "Lənkəran",
  "Lerik",
  "Masallı",
  "Mingəçevir",
  "Naftalan",
  "Naxçıvan",
  "Neftçala",
  "Oğuz",
  "Qabala",
  "Qakh",
  "Qaradağ",
  "Qazakh",
  "Saatlı",
  "Sabirabad",
  "Şabran",
  "Şahbuz",
  "Şəki",
  "Şəmkir",
  "Şirvan",
  "Siazan",
  "Sumqayıt",
  "Tərtər",
  "Tovuz",
  "Ucar",
  "Yardımlı",
  "Yevlakh",
  "Zəngilan",
  "Zaqatala",
  "Zərdab"
];

var globalKey = GlobalKey();

void setupLocator() async {
  locator.registerLazySingleton<Dio>(() => Dio());
  locator.registerLazySingletonAsync<SharedPreferences>(() async {
    return await SharedPreferences.getInstance();
  });
  await locator.isReady<SharedPreferences>();
}



const String createTeamRoute = "CreateTeam";
const String myTeamRoute = "MyTeam";

//Codes

// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => BlocProvider(
// create: (context) =>
// TeamDetailCubit()..startTeamDetail(widget.team.id!),
// child: TeamDetailPage(teamName: widget.team.name ?? ""),
// ),
// ),
// );

// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => UserLogics(username: state.newMessages?[index].username ?? "")),
// );

// FocusScope.of(context).requestFocus(FocusNode());

//bottom: MediaQuery.of(context).viewInsets.bottom

// constraints: BoxConstraints(maxHeight: height/10, minHeight: height/15)