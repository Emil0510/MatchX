import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signalr_netcore/hub_connection.dart';

enum BottomNavigationItem { home, matches, stadiums, teams, more }

class HomeCubits extends Cubit<BottomNavigationItem> {
  HomeCubits() : super(BottomNavigationItem.values[0]);

  late final HubConnection hubConnection;

  switchBottomNavigation(BottomNavigationItem item) {
    emit(item);
  }

  start(){
  }

}
