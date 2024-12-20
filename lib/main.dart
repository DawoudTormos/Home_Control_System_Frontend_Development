import 'package:edittable_grid_flutter/main_mobile.dart';
import 'package:edittable_grid_flutter/main_web.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'web_router/app_router.dart';

String currentPage = "Dashboard";
void main() {
  
  //requestMicrophonePermission() ;
  configureWebURL(); // to deal with web diffrenetly from other platforms regarding URLS
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp(
      {super.key}); // used to keep the index of keys and to be retrived from the db

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      if (kDebugMode) {
        print("I am on web");
      }
      return MainWeb();
    } else {
      return const MainMobile();
    }
  }
}
