
# Flutter Editable Grid 🚀

Welcome to **Flutter Editable Grid**, a dynamic Flutter application serving as the frontend for a **Home Automation Project (Home Control System - HCS )**. This app demonstrates a sleek, user-friendly **editable grid** that allows seamless interaction with smart home devices. <br><br>
It is mainly a library for a grid of grids interactive responsive and draggable for reordering UI.

---
## Screenshots

<br>
<img src="https://raw.githubusercontent.com/DawoudTormos/Flutter_Edittable_Grid/refs/heads/master/Screenshots/Screenshot1.png" alt="Screenshot1"  height="500">
<span > &emsp;&emsp;&emsp; </span>
<img src="https://raw.githubusercontent.com/DawoudTormos/Flutter_Edittable_Grid/refs/heads/master/Screenshots/Screenshot2.jpg" alt="Screenshot2"  height="500">
<span > &emsp;&emsp;&emsp; </span>
<img src="https://raw.githubusercontent.com/DawoudTormos/Flutter_Edittable_Grid/refs/heads/master/Screenshots/Screenshot3.jpg" alt="Screenshot3"  height="500">

<br><br>

## ✨ Features

### 🖱️ Editable Grid  
- **Drag-and-Drop Reordering:** Rearrange devices on the grid effortlessly.  
- **Interactive Controls:** Use switches and sliders to toggle or adjust devices.  
- **Dynamic Feedback:** Color-coded icons indicate device states.  

### 📱 Responsive Design  
- Automatically adjusts to various screen sizes.  
- Smooth scrolling for an enhanced user experience.  

### 🛠️ Easy Customization  
- Modular codebase for scalability and maintainability.  
- Designed for seamless integration into larger projects.

---
<br><br><br>

## 🛠️ Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/your-username/Flutter_Edittable_Grid.git

2. Navigate to the project directory:
   ```bash
   cd Flutter_Edittable_Grid
  
3. Get the dependencies:
   ```bash
   flutter pub get
   
4. Run the app:
	```bash
	flutter run


<br><br><br>

## 📋 Integration and Usage

You need to copy the directories : 
`widgets/Gridview_` 
`widgets/Grid_of_Gridviews`

with their files to /lib.

Then use MainGrid widget wrapped with a SingleChildScrollView  where u need it.
Note: 
- You may need to edit the imports in the files.
- You need to pass the data in the below data structure to the widget.
<br><br><br>

### 🗂️ Data Structure for `MainGrid`

The `MainGrid` widget requires a `Map<String, List<Map<String, dynamic>>>`  and a `final  List<String>` data structure to populate its grids. Here's an example format:

```
final Map<String, List<Map<String, dynamic>>> gridItems = {
  "Kitchen": [
    {"name": "Lamp 1", "color": Colors.red, "icon": Icons.lightbulb, "value": true},
    {"name": "Spotlight 1", "color": Colors.orange, "icon": Icons.light, "value": 0.86},
    {"name": "AC 2", "color": Colors.purple, "icon": Icons.ac_unit, "value": true},
    {"name": "Door Lock", "color": Colors.teal, "icon": Icons.lock_outlined, "value": true},
  ],
  "Living Room": [
    {"name": "Heater", "color": Colors.pink, "icon": Icons.air_rounded, "value": true},
    {"name": "Lamp 2", "color": Colors.green, "icon": Icons.lightbulb, "value": true},
    {"name": "Lamp 3", "color": Colors.blue, "icon": Icons.lightbulb, "value": true},
  ],
};

final  List<String> gridItemsIndexes = ["Kitchen" , "Living Room"];
// used to keep the index of keys and to be retrived from the db

```

Each `List<Map<String, dynamic>>` represents the items in a specific room or category:

-   **Key:** A string representing the room(in my use case) or a group name.
-   **Value:** A list of maps, where each map contains:
    -   `name` (String): The device's name.
    -   `icon` (IconData): The icon representing the device.
    -   `state` (bool): The device's initial state (e.g., on/off).

Pass this `gridItems` map to `MainGrid` as follows:


```
MainGrid(gridItems: gridItems)
```
<br><br><br>

### 💾 Saving changing of order.
The order of the grids and the elements of the grids **is** the indexes  of `List<String> dataKeysIndexs` 
and `List<Map<String, dynamic>>` in `Map<String, List<Map<String, dynamic>>>` respectively.

So applying changing to the backend/Database as these indexes of the elements in Lists changes, will allow u to save order for the next time the app starts and retrives the data. 

To handle ( and save order) what happens as the code is re-rendered after the order of grid or of elements in grids changes, go to:
files :`lib/widgets/Grid_of_GridViews/mainGrid.dart` for Gridviews' order 
and `lib/widgets/GridView_/editable_grid.dart` for elements in gridviews order

then: `build`  -->  `GridView.builder`  --> `itemBuilder` --> `return  Draggable<int>` -->`child:  DragTarget<int>()` --> `onAcceptWithDetails: (fromIndex){}`

The function passed to onAcceptWithDetails is what deals with what happens after you drop an elemnet into its new place. For e.g. you will find in my code:
```
setState(() {

final temp = dataKeysIndexs.removeAt(fromIndex.data);

dataKeysIndexs.insert(index, temp);

});
```

You can see here the setState() that re-renders the widget after editing the gridItemsIndexes to change the order of the gridview in memory (RAM) So here u can handle sending the change to the Backend.

<br><br><br>

### Compatible tested flutter version

Flutter 3.24.3 • channel stable • https://github.com/flutter/flutter.git <br>
Framework • revision 2663184aa7 (3 months ago) • 2024-09-11 16:27:48 -0500 <br>
Engine • revision 36335019a8 <br>
Tools • Dart 3.5.3 • DevTools 2.37.3 <br>
