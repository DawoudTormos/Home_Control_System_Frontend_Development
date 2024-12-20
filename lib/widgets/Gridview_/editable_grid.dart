import 'package:flutter/material.dart';
import 'grid_item_switch.dart';
import 'grid_item_slider.dart';

class EditableGrid extends StatefulWidget {
  final String title;
  final List<Map<String, dynamic>> data;

  const EditableGrid({super.key, required this.title, required this.data});
  @override
  // ignore: library_private_types_in_public_api
  _EditableGridState createState() => _EditableGridState();
}

class _EditableGridState extends State<EditableGrid> {
  //final Key _gridKey =  UniqueKey();
  bool editMode = false;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridWidth = screenWidth < 500 ? screenWidth : 500;

    return Container(
      color: Colors.transparent,
      width: gridWidth,
      padding: const EdgeInsets.only(bottom: 70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 500,
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.title,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        fontWeight: FontWeight.w400)),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.grey[850],
                    elevation: 0,
                    overlayColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {
                    setState(() {
                      editMode = !editMode;
                    });
                  },
                  child: Icon(editMode ? Icons.save : Icons.edit),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: gridWidth,
            child: GridView.builder(
              //key: _gridKey,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: screenWidth < 430 ? 1 : 2,
                childAspectRatio: screenWidth < 430 ? 4 : 2.5,
              ),
              itemCount: widget.data.length,
              itemBuilder: (context, index) {
                final item = widget.data[index];

                Widget gridItem = item['value'] is bool
                    ? GridItemSwitch(item: item)
                    : GridItemSlider(item: item);

                if (editMode) {
                  return Draggable<int>(
                    data: index,
                    feedback: Material(
                      elevation: 0,
                      color: Colors.transparent,
                      child: Container(
                        width:
                            screenWidth < 430 ? gridWidth - 40 : gridWidth / 2,
                        height: screenWidth < 430
                            ? (gridWidth - 40) / (1 * 4)
                            : gridWidth / (2 * 2.5),
                        color: Colors.transparent,
                        child: gridItem,
                      ),
                    ),
                    childWhenDragging: Container(color: Colors.transparent),
                    child: DragTarget<int>(
                      onAcceptWithDetails: (fromIndex) {
                        setState(() {
                          final temp = widget.data.removeAt(fromIndex.data);
                          widget.data.insert(index, temp);
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
          ),
        ],
      ),
    );
  }
}
