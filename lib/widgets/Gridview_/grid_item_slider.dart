import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:hcs_project/main.dart';
import 'package:flutter/material.dart';

class GridItemSlider extends StatefulWidget {
  final Map<String, dynamic> item;

  const GridItemSlider({super.key, required this.item});

  @override
  State<GridItemSlider> createState() => _GridItemSlider();
}

class _GridItemSlider extends State<GridItemSlider> {
  _GridItemSlider();
  double prevSliderValue = 0;

  @override
  void initState() {
    super.initState();
    prevSliderValue = widget.item["Value"];
    // Start the infinite loop
    _startInfiniteLoop();
  }

  void _startInfiniteLoop() {
    Timer.periodic(const Duration(milliseconds: 600), (timer) {
      if (widget.item["Value"] != prevSliderValue) {
        prevSliderValue = widget.item["Value"];
        Map<String, dynamic> requestBody = {};

        requestBody["ID"] = widget.item["ID"];
        requestBody["Value"] = (widget.item["Value"] * 100).toInt();

        final jsonBody = jsonEncode(requestBody);
        api?.setSwitchValue(jsonBody);
      }
      /*setState(() {      });*/
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    double factor = screenWidth < 550 ? 0.74 : 0.83;

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: widget.item["Value"] > 0
              ? widget.item["Color"]
              : Colors.grey[700]!,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: screenWidth > 550
            ? EdgeInsets.symmetric(
                horizontal: 25 * factor, vertical: 20 * factor - 4)
            : EdgeInsets.symmetric(horizontal: 25 * factor, vertical: 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      widget.item["Icon"],
                      color: widget.item["Value"] > 0
                          ? widget.item["Color"]
                          : Colors.grey[700]!,
                      size: (screenWidth < 600 ? 36 : 38) * factor,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.item["Name"],
                      style: TextStyle(
                        color: widget.item["Value"] > 0
                            ? widget.item["Color"]
                            : Colors.grey[700]!,
                        fontWeight: FontWeight.bold,
                        fontSize: 16 * factor,
                      ),
                    ),
                  ],
                ),
                Text(
                  "Value: ${(widget.item['Value'] * 100).toInt()}%",
                  style: TextStyle(
                    color: Colors.grey[700]!,
                    fontSize: screenWidth < 430 ? 15 * factor : 14 * factor,
                  ),
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 5 * factor,
                thumbShape:
                    RoundSliderThumbShape(enabledThumbRadius: 8 * factor),
                overlayShape:
                    RoundSliderOverlayShape(overlayRadius: 25 * factor * 0.81),
              ),
              child: Slider(
                value: (widget.item['Value'] as double),
                min: 0,
                max: 1,
                divisions: 100,
                onChanged: (newValue) {
                  widget.item['Value'] = newValue;
                  setState(() {});
                },
                activeColor: widget.item["Value"] > 0
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
