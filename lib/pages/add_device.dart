import 'package:edittable_grid_flutter/pages/add_devices_sub_pages/components/icons.dart';
import 'package:flutter/material.dart';

class DeviceLinkNavigator extends StatelessWidget {
  const DeviceLinkNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Remove the debug flag
      home: const DeviceLinkPage(),
      routes: {
        '/linkDevice': (context) => const DeviceLinkPage(),
        // Add more routes as you create other pages
      },
    );
  }
}

class DeviceLinkPage extends StatefulWidget {
  const DeviceLinkPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DeviceLinkPageState createState() => _DeviceLinkPageState();
}

class _DeviceLinkPageState extends State<DeviceLinkPage> {
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

  final List<String> subTypes = [
    "sensor-power",
    "sensor-temp",
    "sensor-motion",
    "switch-onoff",
    "switch-dimmer",
    "camera"
    // Sub-type can be nullable
  ];

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
      throw Exception('This is an error message beacuase icons.length != iconsNames.length');
    }
    int index = -1, resultCount = 0;
    final filteredIcons = icons.where((icon) {
      index++;
       if(iconsNames[index].toString().toLowerCase().contains(iconSearchQuery.toLowerCase())) resultCount ++ ;
      //print(resultCount);
      return (iconSearchQuery.isEmpty  
            || iconsNames[index].toString().toLowerCase().contains(iconSearchQuery.toLowerCase())
            && resultCount< 100
          );
    }).toList();

    //print(filteredIcons.length);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0), // Increased vertical padding
        child: Center(
          child: SingleChildScrollView(

            child: SizedBox(
              height: 1000,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Page title as text
                  const Text(
                    "Link a Device",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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
              
                  // Icon Picker with Search
                  const Text("Choose an Icon:"),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Search Icon",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => iconSearchQuery = value);
                    },
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 180,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                  const SizedBox(height: 20),
              
                  // Device Name
                  const Text("Enter Device Name:"),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Device Name",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => deviceName = value),
                  ),
                  const SizedBox(height: 20),
              
                  // Sub-type Dropdown
                  const Text("Choose Sub-Type:"),
                  DropdownButton<String?>(
                    value: selectedSubType,
                    hint: const Text("Select Sub-Type"),
                    isExpanded: true,
                    items: subTypes.map((subType) {
                      return DropdownMenuItem(
                        value: subType,
                        child: Text(subType),
                      );
                    }).toList(),
                    onChanged: (value) => setState(() => selectedSubType = value),
                  ),
                  const SizedBox(height: 20),
              
                  // Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.grey[850],
                      elevation: 0,
                      overlayColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {
                      if (selectedColor == null ||
                          selectedIcon == null ||
                          deviceName.isEmpty ||
                          selectedSubType == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please complete all fields"),
                          ),
                        );
                        return;
                      }
              
                      // Handle device linking logic here
              
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Device $deviceName linked successfully!"),
                        ),
                      );
                    },
                    child: const Text("Link Device"),
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
