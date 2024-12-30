import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/devices_manager.dart';
import 'package:hcs_project/stateManagment/data_update_state.dart';
import 'package:provider/provider.dart'; // Import your API object

class DeviceManager extends StatefulWidget {
  const DeviceManager({super.key});

  @override
  State<DeviceManager> createState() => _DeviceManagerState();
}

class _DeviceManagerState extends State<DeviceManager> {

  @override
  Widget build(BuildContext context) {
      final double screenWidth = MediaQuery.of(context).size.width;
      int updateCount = context.watch<DataUpdateState>().updateCount;
      String addRoomTextFieldValue = "";

    // Access the grid items from the API
    final List<Map<String, dynamic>> gridItemsIndexes = api!.gridItemsIndexes;

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Column(
        children: [
          // Centered Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25.0),
                  child: Text(
                    'Rooms',
                    style: TextStyle(
                    fontSize: screenWidth < 430 ? 20 : 24,
                    fontWeight: FontWeight.bold),
                  ),
                ),
            // Add Room Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5.0),
              child: IconButton(
                onPressed: () {
                  // Open the modal to add a new room
             showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(
                          'Enter Room Name',
                          style: TextStyle(color: Colors.black), // Black title text
                        ),
                        surfaceTintColor: Colors.white, // Remove tint
                        backgroundColor: Colors.white, // White background for the dialog
            
                        content: TextField(
                          autofocus: true,
                          decoration: const InputDecoration(
                            hintText: 'Room Name',
                            hintStyle: TextStyle(color: Colors.grey), // Grey hint text for visibility
                            border: UnderlineInputBorder(),
                            enabledBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black), // Black underline when enabled
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black), // Black underline when focused
                          ), 
                          ),
                          style: const TextStyle(
                            color: Colors.black, // Black text color
                          ),
                          onChanged: (value) {
                            addRoomTextFieldValue = value;
                            //Navigator.pop(context);
                          },
                          
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the modal
                            },
                            child: const Text(
                              'Cancel',
                              style: TextStyle(color: Colors.black), // Black text for Cancel button
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                            //print(addRoomTextFieldValue);
                            Map<String,String> requestBody = {};
                            requestBody["Name"] = addRoomTextFieldValue;
                            String jsonBody = jsonEncode(requestBody);
                            api?.addRoom(jsonBody);
                              Navigator.pop(context); // Close the modal
                            },
                            child: const Text(
                              'Add',
                              style: TextStyle(color: Colors.black), // Black text for Add button
                            ),
                          ),
                        ],
                      );
                    },
                  );
            
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black, backgroundColor: Colors.transparent, // White text
                    elevation:0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide.none,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: -10, vertical: 3),
                  
                ),
                icon:  const Icon(Icons.add, size: 28,color: Colors.black,),

              ),
            )
            
            
              ],
            ),
          ),
          // GridView for displaying rooms
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.5,
                ),
                itemCount: gridItemsIndexes.length,
                itemBuilder: (context, index) {
                  final room = gridItemsIndexes[index];
                  //print(room);
                  return GestureDetector(
                    onTap: () {
                      
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => DevicesRoom(room: room),
                        ),
                      );
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 2, 
                      margin: const EdgeInsets.all(12), // Slightly larger margin for spacing
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: 2), // Black border for the rooms
                        borderRadius: BorderRadius.circular(8), // Rounded corners
                      ),
                      child: Center(
                        child: Text(
                          capitalize(room['Name']),
                          style: TextStyle(fontSize: screenWidth < 430 ? 17 : 21, color: Colors.black),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

        ],
      ),
    );
  }
}

class AnotherPage extends StatelessWidget {
  final Map<String, dynamic> room;

  const AnotherPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Center(
        child: Text(
          'Details for ${room['Name']} (ID: ${room['ID']})',
          style: const TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}




