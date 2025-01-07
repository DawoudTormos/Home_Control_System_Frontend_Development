import 'dart:async';
import 'dart:convert';

import 'package:hcs_project/main.dart';
import 'package:flutter/material.dart';

class GridItemSensor extends StatefulWidget {
  final Map<String, dynamic> item;

  const GridItemSensor({super.key, required this.item});

  @override
  State<GridItemSensor> createState() {
    return _GridItemSensorState();
  }
}

class _GridItemSensorState extends State<GridItemSensor> {
  _GridItemSensorState();



  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double factor = screenWidth < 550 ? 0.74 : 0.83;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color:widget.item["Color"],
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
                  color: widget.item["Color"]
                      ,
                  size: (screenWidth < 600 ? 36 : 38) * factor,
                ),
                const SizedBox(width: 12),
                Text(
                  widget.item["Name"],
                  style: TextStyle(
                    color: widget.item["Color"],
                    fontWeight: FontWeight.bold,
                    fontSize: 16 * factor,
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
              child: Text(
                widget.item["Value"].toString() ,
                style: TextStyle(
                  color: widget.item["Color"] ,
                  fontWeight: FontWeight.bold,
                  fontSize: 18 * factor,
                ),
              ),
            ),


          ],
        ),
      ),
    );
  }
  
}
