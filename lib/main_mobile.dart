import 'package:edittable_grid_flutter/main.dart';
import 'package:edittable_grid_flutter/pages/dashboard.dart';
import 'package:edittable_grid_flutter/widgets/navbar.dart';
import 'package:flutter/material.dart';

class MainMobile extends StatefulWidget {
  const MainMobile({super.key});

  @override
  State<MainMobile> createState() => _MainMobileState();
}

class _MainMobileState extends State<MainMobile> {

  void rerenderMainMobile(){
    setState(() {
      
    });
    
  }
  @override
  Widget build(BuildContext context) {
    //print("current page: $currentPage"); // debugging
     bool? gridEditMode = mainGridKey.currentState?.getEditMode();
    gridEditMode ??= false;
    return MaterialApp(
      //textDirection:  TextDirection.ltr,
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Home Control",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w500), 

              ),
           if( currentPage == "Dashboard")   ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    maximumSize: const Size(5, 100) ,
                    fixedSize: const Size(5, 100) ,
                    minimumSize : const Size(5, 100) ,
                    padding:const EdgeInsets.all(0),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.grey[850],
                    elevation: 0,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                  mainGridKey.currentState?.updateEditMode();
                  setState(() {
                  });
                },
                  child: Icon(gridEditMode ? Icons.save : Icons.edit),
                ),
            ],
          ),
          backgroundColor:
              Colors.grey[100], 
          elevation: 0, 
        ),

        body: NavBar(rerenderMainMobile: rerenderMainMobile),
        //bottomNavigationBar: ,
      ),
    );
  }
}

