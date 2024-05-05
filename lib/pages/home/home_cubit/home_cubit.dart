import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_netcore/http_connection_options.dart';
import 'package:signalr_netcore/hub_connection.dart';
import 'package:signalr_netcore/hub_connection_builder.dart';

import '../../../Constants.dart';
import '../../../network/network.dart';

enum BottomNavigationItem { home, matches, stadiums, teams, more }

class HomeCubits extends Cubit<BottomNavigationItem> {
  HomeCubits() : super(BottomNavigationItem.values[0]);

  late final HubConnection hubConnection;

  switchBottomNavigation(BottomNavigationItem item) {
    emit(item);
  }

  start() async {
    var sharedPreferences = locator.get<SharedPreferences>();
    String? token = sharedPreferences.getString("token");
  }

}
