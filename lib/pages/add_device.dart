import 'package:hcs_project/pages/add_devices_sub_pages/components/icons.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/QRcode_scanner_controller.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/explain_QRCode_scanner.dart';
import 'package:flutter/material.dart';


class NewDevicePage extends StatefulWidget {
  const NewDevicePage({super.key});

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

  final List<String> subTypes = [
    "sensor-power",
    "sensor-temp",
    "sensor-motion",
    "switch-onoff",
    "switch-dimmer",
    "camera"
    // Sub-type can be nullable
  ];


   void navigateToNextPage() {
    final String name = deviceName.trim();
    print(name);
    print(selectedIcon);
    print(selectedColor);
    if (name.isEmpty || selectedIcon == null || selectedColor == null ) {
      // Show an error if any field is empty or not selected
      ScaffoldMessenger.of(context).showSnackBar(
        
        const SnackBar(
          content: Text('Please fill all fields and make a selection!'),
          behavior: SnackBarBehavior.floating, // Makes the SnackBar float
          margin: EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 100, // Adjust this to leave space above the bottom navbar
        ),
      ),);
      return;
    }


  Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const ScanQrInfoPage(),
              ),
            );
    // Navigate to the next page with the data
    /*Navigator.pushNamed(
      context,
      '/QRScannerPage',
      arguments: {
        'deviceName': name,
        //'room': dropdownValue,
        'icon': selectedIcon,
        'color': selectedColor,
      },
    );*/


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
      backgroundColor: Colors.white,
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
                    decoration: const InputDecoration(
                      labelText: "Device Name",
                      border: OutlineInputBorder(),
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
                    
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  ),
                  const SizedBox(height: 20),
              
                  
              
                  // Sub-type Dropdown
                  const Text("Choose Device Type:"),
                  DropdownButton<String?>(
                    value: selectedSubType,
                    hint: const Text("Select Device Type"),
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
                      navigateToNextPage();
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
