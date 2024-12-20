import 'package:edittable_grid_flutter/web_router/app_router.dart';
import 'package:flutter/material.dart';

class MainWeb extends StatelessWidget {
  MainWeb({super.key});

  final AppRouter _router = AppRouter();
  final AppRouteInformationParser _routeInformationParser =
      AppRouteInformationParser();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: MaterialApp.router(
        routerDelegate: _router,
        routeInformationParser: _routeInformationParser,
      ),
    );
  }
}
