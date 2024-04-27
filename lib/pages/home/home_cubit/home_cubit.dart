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


    hubConnection = HubConnectionBuilder()
        .withUrl(
          "${baseUrl}api/notifyHub",
          options: HttpConnectionOptions(
            accessTokenFactory: () async =>
                token!, // Replace with your JWT token logic
          ),
        )
        .build();

    try {
      await hubConnection.start();
      hubConnection.on('ReceiveGameNotification', _handleReceiveMessage);
      print('SignalR Connection Established');
    } catch (error) {
      print('Error establishing SignalR connection: $error');
      ;
    }
  }

  void _handleReceiveMessage(List<dynamic>? data) {
    print("DATA");
    print(data?[0]);

  }
}
