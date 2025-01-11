import 'dart:convert';

import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/components/icons.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/QRcode_scanner_controller.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/explain_QRCode_scanner.dart';
import 'package:flutter/material.dart';

class NewDevicePage extends StatefulWidget {
  Map<String, dynamic> room;
  NewDevicePage({super.key, required this.room});

  @override
  // ignore: library_private_types_in_public_api
  _NewDevicePageState createState() => _NewDevicePageState();
}

class _NewDevicePageState extends State<NewDevicePage> {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.brown,
    Colors.grey,
    Colors.amber,
    Colors.tealAccent,
    Colors.indigoAccent,
    Colors.yellowAccent,
  ];

  void navigateToNextPage() {
    final String name = deviceName.trim();
    print(name);
    print(selectedIcon);
    print(selectedColor);
    if (name.isEmpty ||
        selectedColor == null ||
        selectedSubType == null ||
        ((selectedSubType == "Dimmer Switch" ||
                selectedSubType == "ON/OFF Switch") &&
            selectedIcon == null)) {
      // Show an error if any field is empty or not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields and selections!'),
          behavior: SnackBarBehavior.floating, // Makes the SnackBar float
          margin: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 100, // Adjust this to leave space above the bottom navbar
          ),
        ),
      );
      return;
    }

    // Create a map with the collected data
    Map<String, dynamic> deviceData = {
      'deviceName': name,
      // ignore: deprecated_member_use
      'color': selectedColor?.value, // Get the value of the color

      'roomId': widget.room['ID'],
    };

    if (selectedSubType == "Dimmer Switch" ||
        selectedSubType == "ON/OFF Switch") {
      deviceData['icon_code'] = selectedIcon!.codePoint;
      deviceData['icon_family'] = selectedIcon!.fontFamily;
    }

    switch (selectedSubType) {
      case "Dimmer Switch":
        deviceData['type'] = 1;
        break;
      case "ON/OFF Switch":
        deviceData['type'] = 0;

        break;
      case "Power Sensor":
        deviceData['type'] = 0;

        break;
      case "Temperature Sensor":
        deviceData['type'] = 1;

        break;
      case "Motion Sensor":
        deviceData['type'] = 2;

        break;
    }
    ;

    String json = jsonEncode(deviceData);
    print(json);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ScanQrInfoPage(deviceData: deviceData),
      ),
    );
  }

  Color? selectedColor;
  IconData? selectedIcon;
  String? selectedSubType;
  String deviceName = "";

  String iconSearchQuery = "";

  @override
  Widget build(BuildContext context) {
    //final double screenWidth = MediaQuery.of(context).size.height;

    if (icons.length != iconsNames.length) {
      //print(icons.length);
      //print(iconsNames.length);
      throw Exception(
          'This is an error message beacuase icons.length != iconsNames.length');
    }
    int index = -1, resultCount = 0;
    final filteredIcons = icons.where((icon) {
      index++;
      if (iconsNames[index]
          .toString()
          .toLowerCase()
          .contains(iconSearchQuery.toLowerCase())) resultCount++;
      //print(resultCount);
      return (iconSearchQuery.isEmpty ||
          iconsNames[index]
                  .toString()
                  .toLowerCase()
                  .contains(iconSearchQuery.toLowerCase()) &&
              resultCount < 100);
    }).toList();

    //print(filteredIcons.length);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(
            vertical: 24.0, horizontal: 16.0), // Increased vertical padding
        child: Center(
          child: SingleChildScrollView(
            child: SizedBox(
              height: (selectedSubType == "Dimmer Switch" ||
                      selectedSubType == "ON/OFF Switch")
                  ? 1000
                  : 600,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Page title as text

                  const Text(
                    "Enter new Device Details",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Device Name
                  const Text("Enter Device Name:"),
                  TextField(
                    cursorColor: Colors.black,
                    decoration: const InputDecoration(
                      labelText: "Device Name",
                      labelStyle: TextStyle(color: Colors.black),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (value) => setState(() => deviceName = value),
                  ),
                  const SizedBox(height: 20),

                  // Color Picker
                  const Text("Choose a Color:"),
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: colors.map((color) {
                      return GestureDetector(
                        onTap: () => setState(() => selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selectedColor == color
                                  ? Colors.black
                                  : Colors.transparent,
                              width: 2.0,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Sub-type Dropdown
                  const Text("Choose Device Type:"),
                  DropdownButton<String?>(
                    value: selectedSubType,
                    hint: const Text("Select Device Type"),
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    items: subTypes.map((subType) {
                      return DropdownMenuItem(
                        value: subType,
                        child: Text(subType),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => selectedSubType = value),
                  ),
                  const SizedBox(height: 20),

                  // Icon Picker with Search (conditionally displayed)
                  if (selectedSubType == "Dimmer Switch" ||
                      selectedSubType == "ON/OFF Switch") ...[
                    const Text("Choose an Icon:"),
                    TextField(
                      cursorColor: Colors.black,
                      decoration: const InputDecoration(
                        labelText: "Search Icon",
                        labelStyle: TextStyle(color: Colors.black),
                        border: OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusColor: Colors.black,
                        iconColor: Colors.black,
                        fillColor: Colors.black,
                      ),
                      onChanged: (value) {
                        setState(() => iconSearchQuery = value);
                      },
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 180,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                          ),
                          itemCount: filteredIcons.length,
                          itemBuilder: (context, index) {
                            final icon = filteredIcons[index];
                            return GestureDetector(
                              onTap: () => setState(() => selectedIcon = icon),
                              child: Icon(
                                icon,
                                color: selectedIcon == icon
                                    ? Colors.blue
                                    : Colors.black,
                                size: 32.0,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Submit Button
                  SizedBox(
                    width: 130,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white, // White background
                        foregroundColor: Colors.black, // Black text
                        side: const BorderSide(
                            color: Colors.black, width: 2), // Black border
                      ),
                      onPressed: () {
                        navigateToNextPage();
                      },
                      child: const Text("Link Device"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
