import 'package:edittable_grid_flutter/main.dart';
import 'package:edittable_grid_flutter/pages/add_device.dart';
import 'package:edittable_grid_flutter/pages/ai_assistant.dart';
import 'package:edittable_grid_flutter/pages/dashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

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
      "color": Colors.deepOrange,
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
      "color": Colors.red,
      "icon": Icons.air_rounded,
      "value": true
    },
    {
      "name": "Lamp 2",
      "color": Colors.deepOrange,
      "icon": Icons.lightbulb,
      "value": true
    },
    {
      "name": "Lamp 3",
      "color": Colors.deepOrange,
      "icon": Icons.lightbulb,
      "value": true
    },
  ],
};

final List<String> gridItemsIndexes = ["Kitchen", "Living Room"];
final List<String> gridItemsIndexes2 = ["Kitchen2", "Living Room2"];

// ignore: must_be_immutable
class NavBar extends StatelessWidget {
  final PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);
  VoidCallback  rerenderMainMobile;

  NavBar({super.key, required this.rerenderMainMobile});

  List<Widget> screens=[];
  
  


  List<PersistentBottomNavBarItem> _navBarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard),
        title: "Dashboard",
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: Colors.grey[800],
        inactiveColorSecondary: Colors.blue,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.dashboard),
        title: "Dashboard",
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: Colors.grey[800],
        inactiveColorSecondary: Colors.blue,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.devices),
        title: "Device \nManager",
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: Colors.grey[800],
        inactiveColorSecondary: Colors.blue,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.logout),
        title: "Logout",
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: Colors.grey[800],
        inactiveColorSecondary: Colors.blue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    
    if(!kIsWeb){
   screens = [
    Dashboard(gridItems: gridItems, gridItemsIndexes: gridItemsIndexes), // Home
    const AIAssistantPage(), // Dashboard
    const DeviceLinkNavigator(), // Device Manager 
    Container()
  ];

  }
    return PersistentTabView(
      context,
      controller: _controller,
      screens: screens,
      items: _navBarItems(),
      //confineInSafeArea: true,
      backgroundColor: Colors.white,
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      navBarStyle: NavBarStyle.style1, // Style1
      onItemSelected: (index) {
        switch (index) {
          case 0:
          //print("editted");//debugging
          currentPage = "Dashboard";
          rerenderMainMobile();
            break;
          case 1:
          currentPage = "Assistant";
          rerenderMainMobile();
            break;
          case 2:
            break;
          case 3:
            break;
        }
      },
    );
  }
}
