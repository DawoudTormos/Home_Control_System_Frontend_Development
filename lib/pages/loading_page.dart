import 'package:flutter/material.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(
  color: Colors.black, // Customize the color
  strokeWidth: 4.0,  // Adjust the thickness
)
,
      ),
    );
  }
}
