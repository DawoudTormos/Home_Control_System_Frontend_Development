import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/devices_manager.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WaitLink extends StatefulWidget {
  final Map<String, dynamic> deviceData;

  const WaitLink({super.key, required this.deviceData});

  @override
  _WaitLinkState createState() => _WaitLinkState();
}

class _WaitLinkState extends State<WaitLink> {
  late WebSocketChannel channel;
  bool reqSuccess = true;
  @override
  void initState() {
    super.initState();


  }


   void initAfterBuild(BuildContext context)async{

    widget.deviceData.remove('type');
    String jsonBody = jsonEncode(widget.deviceData);
    print(jsonBody);

    api!.sendLinkRequest(jsonBody).then((value) {
      if(value != "error"){
        ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Linking Request Successful and Pending.'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating, // Makes the SnackBar float
                    margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 100, // Adjust this to leave space above the bottom navbar
                  ),
                  ),
                );

      }else{

        Future.delayed(Duration(seconds: 1), () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                    content: Text('Linking Request Failed.'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating, // Makes the SnackBar float
                    margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom: 100, // Adjust this to leave space above the bottom navbar
                  ),
                  ),
                );
          Navigator.pop(context);
        });

        reqSuccess = false;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    initAfterBuild(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${widget.deviceData["SType"]}'.capitalize(),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 62),
              const Text(
                'Configure the connection of the device as in the manual by pressing the button for 5 seconds.\n\n',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 21,
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                ' 10 minutes left before request is canceled.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,

                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),

            ],
          ),
        ),
      ),
    );
  }
}
