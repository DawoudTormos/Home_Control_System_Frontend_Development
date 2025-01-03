import 'dart:convert';
import 'dart:ffi';
import 'package:hcs_project/stateManagment/data_update_state.dart';
import 'package:hcs_project/stateManagment/login_state.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

class ApiService {
  final String baseUrl = "http://10.0.2.2:8080";
  final _storage = const FlutterSecureStorage();
  String username = "";
  
  final dynamic mainWidgetKey;

     ApiService({required this.mainWidgetKey}) {

    _delayedCheckToken();

  }

  Future<void> _delayedCheckToken() async {
    await Future.delayed(Duration(milliseconds: 500));
     checkToken();
  }

Future<void> waitToFetchAndProcessDevices() async {
    await Future.delayed(Duration(milliseconds: 150));
    fetchAndProcessDevices();/**/
}

Future<void> fetchAndProcessDevices() async {
  await fetchAndProcessRooms();
    final url = Uri.parse("$baseUrl/secure/getDevices");
      final response = await http.get(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      }
    );

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as Map<String, dynamic>;

    // Initialize final map for gridItems
    final Map<String, List<Map<String, dynamic>>> gridItems = {};

    data.forEach((room, devices) {
      // Parse the list of devices
      final List<Map<String, dynamic>> deviceList = (devices as List<dynamic>).map((device) {
        // Convert IconCode and IconFamily to IconData

        var iconData ;
        if (device["SType"] == "switch") {
          iconData = IconData(
          device['IconCode'],
          fontFamily: device['IconFamily'],
        );
        } else if (device["SType"] == "sensor") {
          iconData = Icons.sensors;
        } else if (device["SType"] == "camera") {
          iconData = Icons.camera_outdoor;
        }
        
        if(device["Type"] == 1){
          //print(device["Value"]);
          device["Value"] = device["Value"].toDouble() / 100 ;
        }else{
          device["Value"] = (device["Value"] > 0.5) as bool ;
        }
        return {
          "ID": device["ID"],
          "Name": device["Name"],
          "Color": Color(device["Color"]),
          "Icon": iconData,
          "Type": device["Type"],
          "SType": device["SType"],
          "Value":  device["Value"],
          "Index": device["Index"],
        };
      }).toList();



      // Check for duplicates and fix indexes
      final Set<int> seenIndexs = {};
      bool duplicatesFound = false;
      int uniqueIndex = 0;

      for (var device in deviceList) {
        if (!seenIndexs.add(device["Index"])) {
          duplicatesFound = true;
          break;
         // device["Index"] = uniqueIndex++;
        } 
      }

      if(duplicatesFound){
        int index = 0;
        List<Map<String , dynamic>> requestBody= [];
        for (var device in deviceList) {
        device["Index"] = index;
        requestBody.add({
          "ID":device["ID"],
          "Type": device["SType"],
          "Index": device["Index"]
        });
        index++;
      }

        String jsonBody = jsonEncode(requestBody);
        setIndexes(jsonBody);
      }


      // Sort devices by index
      deviceList.sort((a, b) => a["Index"].compareTo(b["Index"]));
      // Add processed devices to gridItems
      gridItems[room] = deviceList;
    });

      this.gridItems =  gridItems;
      print(gridItems);
      final BuildContext context = mainWidgetKey.currentContext!;
      Provider.of<LoginState>(context, listen: false).login();
      Provider.of<LoginState>(context, listen: false).setDataLoaded(true);
      Provider.of<DataUpdateState>(context, listen: false).alertDataUpdated();

  } else {
    throw Exception('Failed to fetch devices');
  }
}



Future<void> fetchAndProcessRooms() async {
    final url = Uri.parse("$baseUrl/secure/getRooms");
      final response = await http.get(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      }
    );

  if (response.statusCode == 200) {
    final data = json.decode(response.body) as List<dynamic>;

    // Initialize final map for gridItems
    final List<Map<String, dynamic>> rooms = [];

    /**/for (var room in data) {
        rooms.add({
          "Name":room["Name"] ,
           "ID" : room["ID"],
           "Index" : room["Index"],
           });
        }


      // Check for duplicates and fix indexes
      final Set<int> seenIndexs = {};
      bool duplicatesFound = false;
      int uniqueIndex = 0;

      for (var room in rooms) {
        if (!seenIndexs.add(room["Index"])) {
          duplicatesFound = true;
          break;
        } 
      }

      if(duplicatesFound){
        int index = 0;
        List<Map<String , dynamic>> requestBody= [];
        for (var room in rooms) {
        room["Index"] = index;
        requestBody.add({
          "ID":room["ID"],
          "Type": "room",
          "Index": room["Index"]
        });
        index++;
      }

        String jsonBody = jsonEncode(requestBody);
        setIndexes(jsonBody);
      }


      // Sort rooms by index
      rooms.sort((a, b) => a["Index"].compareTo(b["Index"]));
      print(rooms);

      // Add processed devices to gridItems
      this.gridItemsIndexes = rooms;
    
      final BuildContext context = mainWidgetKey.currentContext!;
      Provider.of<DataUpdateState>(context, listen: false).alertDataUpdated();

  } else {
    throw Exception('Failed to fetch devices');
  }
}

Future<void> setIndexes(String jsonBody) async {
    final url = Uri.parse("$baseUrl/secure/setIndexes");
      final response = await http.post(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      },
      body: jsonBody,
    );

     if (response.statusCode == 200) {
      print('Data sent successfully: ${response.body}');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}');
    }

}




Future<void> setSwitchValue(String jsonBody) async {
    final url = Uri.parse("$baseUrl/secure/setSwitchValue");
      final response = await http.post(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      },
      body: jsonBody,
    );
     if (response.statusCode == 200) {
      print('Data sent successfully: ${response.body}');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}.\nError: ${response.body}');
    }

}




Future<void> addRoom(String jsonBody) async {
    final url = Uri.parse("$baseUrl/secure/addRoom");
      final response = await http.post(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      },
      body: jsonBody,
    );

     fetchAndProcessDevices();// and rooms
     if (response.statusCode == 200) {
      print('Data sent successfully: ${response.body}');
    } else {
      print('Failed to send data. Status code: ${response.statusCode}.\nError: ${response.body}');
    }

}



Future<String> checkDeviceExists(String jsonBody) async {
    final url = Uri.parse("$baseUrl/secure/checkDeviceExists");
      final response = await http.post(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      },
      body: jsonBody,
    );

     if (response.statusCode == 200) {
      return response.body;
    } else {
      return "error";
      //print('Failed to send data. Status code: ${response.statusCode}.\nError: ${response.body}');
    }

}

Future<String> sendLinkRequest(String jsonBody) async {
    final url = Uri.parse("$baseUrl/secure/deviceLinkRequest");
      final response = await http.post(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      },
      body: jsonBody,
    );

     if (response.statusCode == 200) {
      return response.body;
    } else { 
           print('Failed to send data. Status code: ${response.statusCode}.\nError: ${response.body}');
      return "error";
    }

}


Future<String> checkDeviceLinkRequestState(String jsonBody) async {
    final url = Uri.parse("$baseUrl/secure/deviceLinkRequestState");
      final response = await http.post(url,
      headers:{
        'Authorization' : await getLocalToken() ?? "",
      },
      body: jsonBody,
    );

     if (response.statusCode == 200) {
      return response.body;
    } else { 
           print('Failed to send data. Status code: ${response.statusCode}.\nError: ${response.body}');
      return "error";
    }

}
  
   
 Map<String, List<Map<String, dynamic>>> gridItems = {};


 List<Map<String, dynamic>> gridItemsIndexes = [];


  // Store token securely
  Future<void> saveLocalToken(String token) async {
    await _storage.write(key: 'jwt_token', value: token);
  }

  // Retrieve token
  Future<String?> getLocalToken() async {
    return await _storage.read(key: 'jwt_token');
  }

  // Login Method
  Future<Map<String, dynamic>> checkToken() async {
  final url = Uri.parse("$baseUrl/checkToken");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json' , 'Authorization' : await getLocalToken() ?? ""},
      //body: json.encode({"username": username, "password": password}),
    );
      final data = json.decode(response.body);

    if (response.statusCode == 200) {
      
      if (data.containsKey("new_token")) {
        await saveLocalToken(data["new_token"]);
        final BuildContext context = mainWidgetKey.currentContext!;
        Provider.of<LoginState>(context, listen: false).setTokenCheck(true);
        Provider.of<LoginState>(context, listen: false).login();
        print(data);
        username = data["username"];
        waitToFetchAndProcessDevices();
        return {"success": true};
      } else {
        return {"success": false, "error": data["error"]};
      }
    } else if (response.statusCode == 401 /*Unauthorized*/){
        final BuildContext context = mainWidgetKey.currentContext!;
        Provider.of<LoginState>(context, listen: false).setTokenCheck(true);
        return {"success": false, "error": data["error"]};
    } else {
      return {"success": false, "error": "Unexpected server error"};
    }

  }

  // Login Method
  Future<Map<String, dynamic>> login( String username, String password) async {
    final url = Uri.parse("$baseUrl/login");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({"username": username, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("token")) {
        await saveLocalToken(data["token"]);
        final BuildContext context = mainWidgetKey.currentContext!;
        Provider.of<LoginState>(context, listen: false).login();
        checkToken();
        return {"success": true};
      } else {
        return {"success": false, "error": data["error"]};
      }
    } else {
      return {"success": false, "error": "Unexpected server error"};
    }
  }

  // Sign Up Method
  Future<Map<String, dynamic>> signUp(String username, String password, String email) async {
    final url = Uri.parse("$baseUrl/signup");
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        "username": username,
        "password": password,
        "email": email,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.containsKey("token")) {
        await saveLocalToken(data["token"]);
        waitToFetchAndProcessDevices();
        return {"success": true, "message": data["message"], "token": data["token"]};
      } else {
        return {"success": false, "error": data["Error"] ?? "Unknown error"};
      }
    } else {
      return {"success": false, "error": "Unexpected server error"};
    }
  }



  
}
