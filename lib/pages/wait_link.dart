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
  late int reqID;
  bool loopState = true;

  @override
  void initState() {
    super.initState();
  }

  void reqStatusCheckLoop(BuildContext context) async {
    if (reqSuccess) {
      while (loopState) {
        Map<String, dynamic> requestData = {
          'reqID': reqID,
        };
        String jsonBody = jsonEncode(requestData);

        api!.checkDeviceLinkRequestState(jsonBody).then((value) {
          if (value != "error") {
            print("response json: " + value);
            var response = jsonDecode(value);

            if (response["error"] == "Request not found.") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Request timed out on server.'),
                  backgroundColor: Colors.red,
                  behavior:
                      SnackBarBehavior.floating, // Makes the SnackBar float
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom:
                        100, // Adjust this to leave space above the bottom navbar
                  ),
                ),
              );

              Future.delayed(Duration(seconds: 1), () {
                Navigator.pop(context);
              });
              loopState = false;
            } else if (response["status"] == "success") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Linking Request Successful.'),
                  backgroundColor: Colors.green,
                  behavior:
                      SnackBarBehavior.floating, // Makes the SnackBar float
                  margin: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    bottom:
                        100, // Adjust this to leave space above the bottom navbar
                  ),
                ),
              );

              Future.delayed(Duration(seconds: 1), () {
                int count = 0;
                Navigator.popUntil(context, (route) {
                  return count++ >= 5;
                });
              });

              loopState = false;
              api!.fetchAndProcessDevices();
            } else if (response["status"] == "pending") {
            } else {}
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Server Error or internet failed.'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating, // Makes the SnackBar float
                margin: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  bottom:
                      100, // Adjust this to leave space above the bottom navbar
                ),
              ),
            );
            loopState = false;
            Navigator.pop(context);
          }
        });

        await Future.delayed(Duration(seconds: 3));
      }
    }
  }

  void initAfterBuild(BuildContext context) async {
    widget.deviceData.remove('type');
    String jsonBody = jsonEncode(widget.deviceData);
    print(jsonBody);

    api!.sendLinkRequest(jsonBody).then((value) {
      if (value != "error") {
        print("response json: " + value);
        var response = jsonDecode(value);
        reqID = response["ReqID"];
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
        reqSuccess = true;
        reqStatusCheckLoop(context);
      } else {
        Future.delayed(Duration(seconds: 1), () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Linking Request Failed.'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating, // Makes the SnackBar float
              margin: EdgeInsets.only(
                left: 16,
                right: 16,
                bottom:
                    100, // Adjust this to leave space above the bottom navbar
              ),
            ),
          );
          Navigator.pop(context);
        });
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
