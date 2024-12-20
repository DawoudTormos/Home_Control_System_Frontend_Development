import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import "package:edittable_grid_flutter/widgets/gridview_/editable_grid.dart";




class MainGrid extends StatefulWidget {
  final Map<String, List<Map<String, dynamic>>>? gridItems;
  final List<String>? gridItemsIndexes;


  const MainGrid(
      {super.key, required this.gridItems, required this.gridItemsIndexes});

  @override
  State<MainGrid> createState() => MainGridState();
}

class MainGridState extends State<MainGrid> {
  final GlobalKey _gridKey = GlobalKey();

  bool editMode = false;

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
                "Hi admin!",
                style: TextStyle(
                    fontSize: screenWidth < 430 ? 20 : 24,
                    fontWeight: FontWeight.bold),
              ),
              //SizedBox(width: columnsCount * 500 - 330),

             if(kIsWeb) FloatingActionButton.extended(
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
          final item = widget.gridItems![widget.gridItemsIndexes![index]]!;

          Widget gridItem =
              EditableGrid(title: widget.gridItemsIndexes![index], data: item);

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
            final item = widget.gridItems![widget.gridItemsIndexes![index]]!;

            Widget gridItem = EditableGrid(
                title: widget.gridItemsIndexes![index], data: item);

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
