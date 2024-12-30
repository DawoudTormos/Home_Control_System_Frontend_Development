import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hcs_project/main.dart';
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
      int updateCount = context.watch<DataUpdateState>().updateCount;
      String addRoomTextFieldValue = "";

    // Access the grid items from the API
    final List<Map<String, dynamic>> gridItemsIndexes = api!.gridItemsIndexes;

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      body: Column(
        children: [
          // Centered Title
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 40.0),
            child: Text(
              'Rooms',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // GridView for displaying rooms
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                childAspectRatio: 1.2, // Aspect ratio for each item (smaller rooms)
              ),
              itemCount: gridItemsIndexes.length,
              itemBuilder: (context, index) {
                final room = gridItemsIndexes[index];

                return GestureDetector(
                  onTap: () {
                    // Navigate to another page and pass the selected room
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AnotherPage(room: room),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 2, // Slight elevation for the card
                    margin: const EdgeInsets.all(12), // Slightly larger margin for spacing
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 2), // Black border for the rooms
                      borderRadius: BorderRadius.circular(8), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        room['Name'],
                        style: const TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Add Room Button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ElevatedButton(
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
                foregroundColor: Colors.white, backgroundColor: Colors.black, // White text
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: const Text('Add Room'),
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
