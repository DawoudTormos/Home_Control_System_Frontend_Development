// file only for testing.
/*
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppRouter _router = AppRouter();
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router,
      routeInformationParser: _routeInformationParser,
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Change to details page
            AppRouter.of(context).setNewRoutePath(AppState('/details'));
          },
          child: Text('Go to Details'),
        ),
      ),
    );
  }
}

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Details Page')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigate back to home
            AppRouter.of(context).setNewRoutePath(AppState('/'));
          },
          child: Text('Back to Home'),
        ),
      ),
    );
  }
}

class AppState {
  final String path;

  AppState(this.path);
}

class AppRouteInformationParser extends RouteInformationParser<AppState> {
  @override
  Future<AppState> parseRouteInformation(RouteInformation routeInformation) {
    final uri = Uri.parse(routeInformation.location ?? '/');
    return SynchronousFuture(AppState(uri.path));
  }

  @override
  RouteInformation? restoreRouteInformation(AppState state) {
    return RouteInformation(location: state.path);
  }
}

class AppRouter extends RouterDelegate<AppState>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<AppState> {
  final GlobalKey<NavigatorState> navigatorKey;

  AppState _currentState = AppState('/');

  AppRouter() : navigatorKey = GlobalKey<NavigatorState>();

  AppState get currentConfiguration => _currentState;

  @override
  Future<void> setNewRoutePath(AppState state) async {
    _currentState = state;
    notifyListeners();
  }

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      pages: [
        MaterialPage(child: HomePage(), key: ValueKey('HomePage')),
        if (_currentState.path == '/details')
          MaterialPage(child: DetailsPage(), key: ValueKey('DetailsPage')),
      ],
      onPopPage: (route, result) {
        if (!route.didPop(result)) {
          return false;
        }
        _currentState = AppState('/');
        notifyListeners();
        return true;
      },
    );
  }

  static AppRouter of(BuildContext context) {
    return Router.of(context).routerDelegate as AppRouter;
  }
}*/
