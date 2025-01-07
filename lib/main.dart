import 'package:hcs_project/api/api_service.dart';
import 'package:hcs_project/main_mobile.dart';
import 'package:hcs_project/main_web.dart';
import 'package:hcs_project/pages/loading_page.dart';
import 'package:hcs_project/pages/login.dart';
import 'package:hcs_project/stateManagment/data_update_state.dart';
import 'package:hcs_project/stateManagment/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'web_router/app_router.dart';


  final List<String> subTypes = [
    "Power Sensor",
    "Temperature Sensor",
    "Motion Sensor",
    "ON/OFF Switch",
    "Dimmer Switch",
    "Camera"
    // Sub-type can be nullable
  ];
  

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
        ChangeNotifierProvider(create: (context) => DataUpdateState()),
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
    //api!.checkToken();
    
  //print("building at main");
   return  MaterialApp(
    
    home: isTokenChecked(loginState!.isTokenChecked, loginState!.isLoggedIn, loginState!.isDataLoaded),
    );
    

  }


  
  
   Widget isTokenChecked(bool isTokenChecked, bool isLoggedIn, bool isDataLoaded ){

    if(isTokenChecked!){
      return isloggedIn(isLoggedIn,isDataLoaded );
      }else{
      return const LoadingPage();

      }
   }  
   Widget isloggedIn(bool? isLoggedIn, bool isdataLoaded){

    if(isLoggedIn!){
      return isDataLoaded(isdataLoaded);
      }else{
      return LoginPage();

      }
   }
      Widget isDataLoaded(bool? isDataLoaded){
      if(isDataLoaded!){
      return goToMainPage();
      }else{
      return const LoadingPage();

      }
      }

  
  Widget goToMainPage(){

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




  String capitalize(str) {
    return "${str[0].toUpperCase()}${str.substring(1)}";
  }
