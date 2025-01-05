import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/add_device.dart';
import 'package:hcs_project/pages/ai_assistant.dart';
import 'package:hcs_project/pages/dashboard.dart';
import 'package:hcs_project/pages/profile_page.dart';
import 'package:hcs_project/pages/rooms_manager.dart';
import 'package:hcs_project/stateManagment/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';


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
        icon: const Icon(Icons.memory ),
        title: "Assistant",
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
        icon: const Icon(Icons.person),
        title: "Profile",
        activeColorPrimary: Colors.white,
        activeColorSecondary: Colors.black,
        inactiveColorPrimary: Colors.grey[800],
        inactiveColorSecondary: Colors.blue,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
        //final someValue = context.watch<LoginState>().isLoggedIn;

    
    if(!kIsWeb){
   screens = [
    Dashboard(gridItems: api!.gridItems, gridItemsIndexes: api!.gridItemsIndexes), // Home
    const AIAssistantPage(), // Dashboard
     DeviceManager(), // Device Manager 
    ProfilePage()
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
          currentPage = "addDevice";
          rerenderMainMobile();
            break;
          case 3:
          currentPage = "profile";
          rerenderMainMobile();
            break;
        }
      },
    );
  }
}
