import 'package:flutter/material.dart';
import "../widgets/Grid_of_Gridviews/main_grid.dart";


GlobalKey<MainGridState> mainGridKey = GlobalKey();
      
class Dashboard extends StatelessWidget {
  final List<String>? gridItemsIndexes;
  final Map<String, List<Map<String, dynamic>>>? gridItems;

  const Dashboard({
    super.key,
    required this.gridItems,
    required this.gridItemsIndexes,
  });
  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
       

    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SingleChildScrollView(
        //physics: BouncingScrollPhysics(),
        child: SizedBox(
          width: screenWidth,
          child: MainGrid( key:mainGridKey,
              gridItems: gridItems, gridItemsIndexes: gridItemsIndexes),
        ),
      ),
    );
  }
}
