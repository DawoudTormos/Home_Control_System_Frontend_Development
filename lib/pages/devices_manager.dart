import 'package:flutter/material.dart';
import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/add_device.dart';

class DevicesRoom extends StatelessWidget {
  final Map<String, dynamic> room;

  const DevicesRoom({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    // Accessing devices from the API
    List<Map<String, dynamic>> devices = api!.gridItems[room['Name']] ?? [];

    // Grouping devices by SType
    Map<String, List<Map<String, dynamic>>> groupedDevices = {};
    for (var device in devices) {
      String sType = device['SType'];
      if (!groupedDevices.containsKey(sType)) {
        groupedDevices[sType] = [];
      }
      groupedDevices[sType]!.add(device);
    }

    return Scaffold(
      backgroundColor: Colors.white, // Set background color to black
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title and Add Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  room['Name'],
                  style: TextStyle(fontSize: screenWidth < 430 ? 20 : 24 ,fontWeight: FontWeight.bold, color: Colors.black), // White text
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Displaying tables for each SType
            Expanded(
              child: ListView.builder(
                itemCount: groupedDevices.keys.length,
                itemBuilder: (context, index) {
                  String sType = groupedDevices.keys.elementAt(index);
                  List<Map<String, dynamic>> deviceList = groupedDevices[sType]!;

                  return DeviceTable(sType: sType, devices: deviceList);
                },
              ),
            ),
                      ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // White background
                        foregroundColor: Colors.black, // Black text
                        side: const BorderSide(color: Colors.black, width: 2), // Black border
                      ),
                      child: const Text("Add Device"), 
                      onPressed: () {
                        // Navigate to add device page (to be implemented)
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NewDevicePage(room: room), // Replace with your actual page
                        ));
                      },
                ),
          ],
        ),
      ),
    );
  }
}

class DeviceTable extends StatelessWidget {
  final String sType;
  final List<Map<String, dynamic>> devices;
  final List<String> sensorTypes = ["Power", "Temperature","Motion"];

   DeviceTable({super.key, required this.sType, required this.devices});

  @override
  Widget build(BuildContext context) {
    final tableNames={
      "switch":"Switches",
      "camera":"Camera",
      "sensor":"Sensors"
    };
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.4, // Fixed height of 40% of screen height
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 10),
        color: Colors.white, // White background for the table
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero,side: BorderSide(color: Colors.grey)), // No border radius
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  tableNames[sType.toLowerCase()]!, // Capitalize the SType for better presentation
                  style: TextStyle(
                      fontSize: screenWidth < 430 ? 20 : 24,
                      fontWeight: FontWeight.bold), // Black text for title
                ),
              ),
              const SizedBox(height: 10),
              Expanded( // Make the DataTable take available space
                child: SingleChildScrollView( // Make table scrollable
                  child: DataTable(
                    //border: TableBorder(top: BorderSide(),bottom: BorderSide(),left: BorderSide(),right: BorderSide()),

                    columns: const [
                      DataColumn(label: Text('Icon', style: TextStyle(color: Colors.black))), // Black text for headers
                      DataColumn(label: Text('Name', style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('Type', style: TextStyle(color: Colors.black))),
                      DataColumn(label: Text('Color', style: TextStyle(color: Colors.black))),
                    ],
                    rows: devices.map((device) {
                      var type = "";
                      if(device['SType'] == "switch"){
                        type = (device['Type']==0 ? "ON/OFF" : "Dimmer") + "\n Switch";
                      }else if(device['SType'] == "camera"){
                        type = "Camera";
                      }else if(device['SType'] == "sensor"){
                        type = sensorTypes[device['Type']] + "\n Sensor";
                      }
                      return DataRow(cells: [
                        DataCell(Icon(device['Icon'], color: Colors.black, size: 23,)), // Black icon
                        DataCell(Text(device['Name'], style: TextStyle(color: Colors.black,fontSize: screenWidth < 430 ? 13 : 17))), 
                        DataCell(Text(type, style: TextStyle(color: Colors.black,fontSize: screenWidth < 430 ? 12 : 16))),
                        DataCell(Container(
                          width: 15,
                          height: 15,
                          color: device['Color'],
                        )),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}






// Extension to capitalize the first letter of a string
extension StringCasingExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
