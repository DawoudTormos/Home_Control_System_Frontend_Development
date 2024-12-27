import 'package:flutter/material.dart';

class GridItemSwitch extends StatefulWidget {
  final Map<String, dynamic> item;

  const GridItemSwitch({super.key, required this.item});

  @override
  State<GridItemSwitch> createState() {
    return _GridItemSwitchState();
  }
}

class _GridItemSwitchState extends State<GridItemSwitch> {
  _GridItemSwitchState();

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double factor = screenWidth < 550 ? 0.74 : 0.83;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: widget.item["Value"] == true
              ? widget.item["Color"]
              : Colors.grey[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: screenWidth > 600
            ? EdgeInsets.all(25 * factor)
            : EdgeInsets.all(20 * factor),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  widget.item["Icon"],
                  color: widget.item["Value"] == true
                      ? widget.item["Color"]
                      : Colors.grey[700]!,
                  size: (screenWidth < 600 ? 36 : 38) * factor,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.item["Name"],
                  style: TextStyle(
                    color: widget.item["Value"] == true
                        ? widget.item["Color"]
                        : Colors.grey[700]!,
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * factor,
                  ),
                ),
              ],
            ),
            Transform.scale(
              scale: factor,
              child: Switch(
                value: widget.item['Value'],
                onChanged: (newValue) {
                  widget.item['Value'] = newValue;
                  setState(() {});
                },
                activeColor: widget.item["Value"] == true
                    ? widget.item["Color"]
                    : Colors.grey[700]!,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
