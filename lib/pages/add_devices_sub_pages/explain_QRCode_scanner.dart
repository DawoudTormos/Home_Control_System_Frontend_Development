import 'package:hcs_project/pages/add_devices_sub_pages/QRcode_scanner_controller.dart';
import 'package:flutter/material.dart';

class ScanQrInfoPage extends StatelessWidget {
  final Map<String,dynamic> deviceData;
  const ScanQrInfoPage({super.key, required this.deviceData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Scan the QR Code',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'On the next page, you will be prompted to scan the QR code on your IoT device. This is required to link the device to your account.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>  const QRScannerWithController(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Go to Scan QR Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
