import 'package:edittable_grid_flutter/api/api_service.dart';
import 'package:edittable_grid_flutter/main_mobile.dart';
import 'package:edittable_grid_flutter/main_web.dart';
import 'package:edittable_grid_flutter/pages/login.dart';
import 'package:edittable_grid_flutter/stateManagment/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'web_router/app_router.dart';


String currentPage = "Dashboard";
ApiService? api;

// ignore: library_private_types_in_public_api
GlobalKey<_MyAppState>? mainKey;

void main() {
//requestMicrophonePermission() ;
 configureWebURL(); // to deal with web diffrenetly from other platforms regarding URLS
 mainKey = GlobalKey<_MyAppState>();// key to access the MyApp widget ( main.dart) from where needed

//api object to talk with the backend through a rest api and store needed data
  api = ApiService(mainWidgetKey: mainKey);
  
  runApp(
    MultiProvider(
      providers: [
        //ChangeNotifierProvider(create: (context) => ThemeManager()),
        ChangeNotifierProvider(create: (context) => LoginState()),
      ],
      child: MyApp(key: mainKey),
    ),
  );

}

class MyApp extends StatefulWidget {
  const MyApp(
      {super.key}); 
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LoginState? loginState ;
 // used to keep the index of keys and to be retrived from the db
  @override
  Widget build(BuildContext context) {
    loginState = Provider.of<LoginState>(context);

   return  MaterialApp(
    home: isloggedIn(loginState!.isLoggedIn),
    );
    

  }
  
   Widget isloggedIn(bool isLoggedIn){
    if(isLoggedIn){
      return mainPage();
      }else{
      return LoginPage();

      }
   }
  
  Widget mainPage(){

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
