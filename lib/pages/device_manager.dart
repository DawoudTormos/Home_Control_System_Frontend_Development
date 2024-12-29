import 'package:flutter/material.dart';
import 'package:hcs_project/main.dart'; // Import your API object

class DeviceManager extends StatefulWidget {
  const DeviceManager({super.key});

  @override
  State<DeviceManager> createState() => _DeviceManagerState();
}

class _DeviceManagerState extends State<DeviceManager> {
  @override
  Widget build(BuildContext context) {
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
                      title: const Text('Enter Room Name'),
                      content: TextField(
                        autofocus: true,
                        decoration: const InputDecoration(hintText: 'Room Name'),
                        onSubmitted: (value) {
                          // Handle adding the room (you can customize this part)
                          Navigator.pop(context);
                        },
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the modal
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Call your method to add the room here
                            Navigator.pop(context); // Close the modal
                          },
                          child: const Text('Add'),
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
