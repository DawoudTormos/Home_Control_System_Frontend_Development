import 'dart:async';
import 'dart:convert';

import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/devices_manager.dart';
import 'package:hcs_project/stateManagment/login_state.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:hcs_project/widgets/gridview_/editable_grid.dart";
import 'package:provider/provider.dart';

class MainGrid extends StatefulWidget {
  Map<String, List<Map<String, dynamic>>>? gridItems;
  List<Map<String, dynamic>>? gridItemsIndexes;

  MainGrid(
      {super.key, required this.gridItems, required this.gridItemsIndexes});

  @override
  State<MainGrid> createState() => MainGridState();
}

class MainGridState extends State<MainGrid> {
  final GlobalKey _gridKey = GlobalKey();

  bool editMode = false;

  @override
  void initState() {
    super.initState();
    // Start the infinite loop
    _startInfiniteLoop();
  }

  void _startInfiniteLoop() {
    Timer.periodic(const Duration(milliseconds: 2500), (timer) async {
      await api!.fetchAndProcessDevices();
      setState(() {
        widget.gridItemsIndexes = api!.gridItemsIndexes;
        widget.gridItems = api!.gridItems;
      });
    });
  }

  void updateEditMode() {
    setState(() {
      editMode = !editMode;
    });
  }

  bool getEditMode() {
    return editMode;
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double innerGridWidth = screenWidth < 570 ? screenWidth : 570;
    final columnsCount =
        getGridColumnsCount(screenWidth, widget.gridItems!.length);

    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        const SizedBox(height: 30),

        //padding: EdgeInsets.symmetric(horizontal:(screenWidth+4 - columnsCount * 500)/2),
        Container(
          width: columnsCount * innerGridWidth,
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Hi ${api!.username.capitalize()}!",
                style: TextStyle(
                    fontSize: screenWidth < 430 ? 20 : 24,
                    fontWeight: FontWeight.bold),
              ),
              //SizedBox(width: columnsCount * 500 - 330),

              if (kIsWeb)
                FloatingActionButton.extended(
                  onPressed: () {
                    setState(() {
                      editMode = !editMode;
                    });
                  },
                  icon: Icon(editMode ? Icons.save : Icons.edit,
                      color: Colors.grey[900]!),
                  label: Text(
                    editMode ? "Save" : "Edit",
                    style: TextStyle(
                      color: Colors.grey[900]!,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  backgroundColor: Colors.white,
                  elevation: 0,
                  // Button shadow
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
            ],
          ),
        ),

        SizedBox(height: screenWidth < 430 ? 60 : 110),
        SizedBox(
          width: columnsCount * innerGridWidth,
          child: listOrGrid(screenWidth, innerGridWidth, columnsCount),
        ),
      ],
    );
  }

  int getGridColumnsCount(double screenWidth, int len) {
    int count = (screenWidth / 570).toInt(); // 500 + 50   50 for padding
    //if (count > 2 ){count = (screenWidth / 570).toInt();} //when 3 columns , make padding 70
    if (count == 0) {
      return 1;
    }

    if (count > len) {
      return len;
    }
    return count;
  }

  Widget listOrGrid(
      double screenWidth, double innerGridWidth, int columnsCount) {
    if (screenWidth > 430) {
      return GridView.builder(
        key: _gridKey,
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columnsCount,
          mainAxisSpacing: 10,
        ),
        itemCount: widget.gridItems!.length,
        itemBuilder: (context, index) {
          final item =
              widget.gridItems![widget.gridItemsIndexes![index]["Name"]]!;

          if (item.length == 0) {
            return Container();
          }
          Widget gridItem = EditableGrid(
              title: widget.gridItemsIndexes![index]["Name"], data: item);

          if (editMode) {
            return Draggable<int>(
              data: index,
              feedback: Material(
                elevation: 0,
                color: Colors.transparent,
                child: Container(
                  width: innerGridWidth,
                  color: Colors.transparent,
                  child: gridItem,
                ),
              ),
              childWhenDragging: Container(color: Colors.transparent),
              child: DragTarget<int>(
                onAcceptWithDetails: (fromIndex) {
                  setState(() {
                    List<Map<String, dynamic>> requestBody = [];
                    requestBody.add(
                      {
                        "ID": widget.gridItemsIndexes![index]["ID"],
                        "Type": "room",
                        "Index": widget.gridItemsIndexes![fromIndex.data]
                            ["Index"]
                      },
                    );
                    requestBody.add(
                      {
                        "ID": widget.gridItemsIndexes![fromIndex.data]["ID"],
                        "Type": "room",
                        "Index": widget.gridItemsIndexes![index]["Index"]
                      },
                    );
                    final jsonBody = jsonEncode(requestBody);
                    api?.setIndexes(jsonBody);
                    final temp =
                        widget.gridItemsIndexes!.removeAt(fromIndex.data);
                    widget.gridItemsIndexes!.insert(index, temp);
                  });
                },
                builder: (context, candidateData, rejectedData) {
                  return gridItem;
                },
              ),
            );
          }

          return gridItem;
        },
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView.builder(
          key: _gridKey,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.gridItems!.length,
          itemBuilder: (context, index) {
            final item =
                widget.gridItems![widget.gridItemsIndexes![index]["Name"]]!;

            if (item.length == 0) {
              return Container();
            }

            Widget gridItem = EditableGrid(
                title: widget.gridItemsIndexes![index]["Name"], data: item);
            if (editMode) {
              return Draggable<int>(
                data: index,
                feedback: Material(
                  elevation: 0,
                  color: Colors.transparent,
                  child: Container(
                    width: screenWidth - 40,
                    color: Colors.transparent,
                    child: gridItem,
                  ),
                ),
                childWhenDragging: Container(
                    color: Colors.transparent, height: item.length * 90),
                child: DragTarget<int>(
                  onAcceptWithDetails: (fromIndex) {
                    setState(() {
                      List<Map<String, dynamic>> requestBody = [];
                      requestBody.add(
                        {
                          "ID": widget.gridItemsIndexes![index]["ID"],
                          "Type": "room",
                          "Index": widget.gridItemsIndexes![fromIndex.data]
                              ["Index"]
                        },
                      );
                      requestBody.add(
                        {
                          "ID": widget.gridItemsIndexes![fromIndex.data]["ID"],
                          "Type": "room",
                          "Index": widget.gridItemsIndexes![index]["Index"]
                        },
                      );
                      final jsonBody = jsonEncode(requestBody);
                      api?.setIndexes(jsonBody);
                      print(jsonBody);
                      final temp =
                          widget.gridItemsIndexes!.removeAt(fromIndex.data);
                      widget.gridItemsIndexes!.insert(index, temp);
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    return gridItem;
                  },
                ),
              );
            }

            return gridItem;
          },
        ),
      );
    }
  }
}
