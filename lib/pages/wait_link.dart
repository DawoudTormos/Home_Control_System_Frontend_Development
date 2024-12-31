import 'dart:convert';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8080/secure/ws?purpose=device_linking'),
    );

    // Send deviceData as JSON in the first message
    channel.sink.add(jsonEncode(widget.deviceData));
    print(jsonEncode(widget.deviceData));
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
