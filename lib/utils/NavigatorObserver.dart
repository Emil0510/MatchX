import 'package:flutter/cupertino.dart';

class MyNavigatorObserver extends NavigatorObserver {

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    // This method is called when a route is popped
    print(route);
    print(previousRoute);
    print('Route popped: ${route.settings.name}');




  }



}