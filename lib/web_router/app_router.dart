import 'package:edittable_grid_flutter/pages/ai_assistant.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../pages/dashboard.dart';
import '../pages/page_not_found.dart';

import 'routingForURL/platforms_routing_helper.dart'
    if (dart.library.html) './routingForURL/web_routing.dart'
    if (dart.library.io) './routingForURL/other_routing.dart';

void configureWebURL() {
  // to deal with web diffrenetly from other platforms regarding URLS
  configureWebURL_();
}

final Map<String, List<Map<String, dynamic>>> gridItems = {
  "Kitchen": [
    {
      "name": "Lamp 1",
      "color": Colors.red,
      "icon": Icons.lightbulb,
      "value": true
    },
    {
      "name": "Spotlight 1",
      "color": Colors.orange,
      "icon": Icons.light,
      "value": 0.86
    },
    {
      "name": "AC 2",
      "color": Colors.purple,
      "icon": Icons.ac_unit,
      "value": true
    },
    {
      "name": "Door Lock",
      "color": Colors.teal,
      "icon": Icons.lock_outlined,
      "value": true
    },
  ],
  "Living Room": [
    {
      "name": "Heater",
      "color": Colors.pink,
      "icon": Icons.air_rounded,
      "value": true
    },
    {
      "name": "Lamp 2",
      "color": Colors.green,
      "icon": Icons.lightbulb,
      "value": true
    },
    {
      "name": "Lamp 3",
      "color": Colors.blue,
      "icon": Icons.lightbulb,
      "value": true
    },
  ],
};

final Map<String, List<Map<String, dynamic>>> gridItems2 = {
  "Kitchen2": [
    {
      "name": "Lamp 1",
      "color": Colors.red,
      "icon": Icons.lightbulb,
      "value": true
    },
    {
      "name": "Spotlight 1",
      "color": Colors.orange,
      "icon": Icons.light,
      "value": 0.86
    },
    {
      "name": "AC 2",
      "color": Colors.purple,
      "icon": Icons.ac_unit,
      "value": true
    },
    {
      "name": "Door Lock",
      "color": Colors.teal,
      "icon": Icons.lock_outlined,
      "value": true
    },
  ],
  "Living Room2": [
    {
      "name": "Heater",
      "color": Colors.pink,
      "icon": Icons.air_rounded,
      "value": true
    },
    {
      "name": "Lamp 2",
      "color": Colors.green,
      "icon": Icons.lightbulb,
      "value": true
    },
    {
      "name": "Lamp 3",
      "color": Colors.blue,
      "icon": Icons.lightbulb,
      "value": true
    },
  ],
};

final List<String> gridItemsIndexes = ["Kitchen", "Living Room"];
final List<String> gridItemsIndexes2 = ["Kitchen2", "Living Room2"];

class AppRouter extends RouterDelegate<AppState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppState> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  AppState _currentState = AppState('/');

  AppRouter() : navigatorKey = GlobalKey<NavigatorState>();

  @override
  AppState get currentConfiguration => _currentState;

  @override
  // ignore: avoid_renaming_method_parameters
  Future<void> setNewRoutePath(AppState state) async {
    _currentState = state;
    //print(_currentState.toString());
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(
            child:
                Dashboard(gridItems: gridItems, gridItemsIndexes: gridItemsIndexes),
            key: const ValueKey('HomePage')),
         if(_currentState.path == "AIAssitant")
            const MaterialPage(
              child: AIAssistantPage(), key: ValueKey('AIAssistantPage')),
        if (!['/', '/page2', '/page3'].contains(_currentState.path))
          const MaterialPage(
              child: NotFoundPage(), key: ValueKey('NotFoundPage')),
      ],
      // ignore: deprecated_member_use
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        // Handle back navigation
        _currentState = AppState('/');
        notifyListeners();
        return true;
      },
    ));
  }

  static AppRouter of(BuildContext context) {
    return Router.of(context).routerDelegate as AppRouter;
  }
}

class AppRouteInformationParser extends RouteInformationParser<AppState> {
  @override
  Future<AppState> parseRouteInformation(RouteInformation routeInformation) {
    // ignore: deprecated_member_use
    final uri = Uri.parse(
        // ignore: deprecated_member_use
        routeInformation.location /* ?? '/' //can't be null so commented it*/);
    return SynchronousFuture(AppState(uri.path));
  }

  @override
  // ignore: avoid_renaming_method_parameters
  RouteInformation? restoreRouteInformation(AppState state) {
    // ignore: deprecated_member_use
    return RouteInformation(location: state.path);
  }
}

class AppState {
  final String path;

  AppState(this.path);
}
