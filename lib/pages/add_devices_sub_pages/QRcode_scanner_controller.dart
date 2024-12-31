import 'dart:async';
import 'package:hcs_project/main.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/components/scanner_button_widgets.dart';
import 'package:hcs_project/pages/add_devices_sub_pages/components/scanner_error_widget.dart';
import 'package:flutter/material.dart';
import 'package:hcs_project/pages/wait_link.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'dart:convert';

final List<String> types = [
    "Power_Sensor",
    "Temperature_Sensor",
    "Motion_Sensor",
    "ON/OFF_Switch",
    "Dimmer_Switch",
    "Camera"
    // Sub-type can be nullable
  ];

class QRScannerWithController extends StatefulWidget {
  final dynamic deviceData;

  const QRScannerWithController({super.key, required this.deviceData});

  @override
  State<QRScannerWithController> createState() =>
      _QRScannerWithControllerState();
}

class _QRScannerWithControllerState extends State<QRScannerWithController> with WidgetsBindingObserver {
  
  final MobileScannerController controller = MobileScannerController(
    autoStart: false,
    torchEnabled: false,
    useNewCameraSelector: false,
  );

  Barcode? _barcode;
  StreamSubscription<Object?>? _subscription;

  Widget _buildBarcode(Barcode? value) {
    if (value == null) {
      return const Text(
        'Scan something!',
        overflow: TextOverflow.fade,
        style: TextStyle(color: Colors.white),
      );
    }

    return Text(
      value.displayValue ?? 'No display value.',
      overflow: TextOverflow.fade,
      style: const TextStyle(color: Colors.white),
    );
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    setState(() {
      _barcode = barcodes.barcodes.firstOrNull;
      String? serial = _barcode?.displayValue ?? "";

      // Check if the barcode matches the specified format
      if (serial != null && serial.contains('-')) {
        List<String> parts = serial.split('-');
        if (parts.length == 2 && types.contains(parts[0])) {
          int? deviceID = int.tryParse(parts[1]);
          if (deviceID != null) {
            Map<String, dynamic> jsonObject = {
              "ID": deviceID,
            };

            String jsonBody = jsonEncode(jsonObject);
            //print(json);
            api!.checkDeviceExists(jsonBody).then((value) {
              if (value != "error") {
                print("-------\n\n\n\n");
                print(value);
                print("\n\n\n\n-------");

                  final Map<String, dynamic> data = jsonDecode(value);
                  widget.deviceData["ID"] = data["ID"];
                  widget.deviceData["SType"] = data["DeviceType"];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>   WaitLink(deviceData: widget.deviceData),
                    ),
                  );


              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Device not found!'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            });
          }
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen(_handleBarcode);
    

    unawaited(controller.start());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.stop());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: const Text('With controller')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 100,
              color: Colors.black.withOpacity(0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: controller),
                  StartStopMobileScannerButton(controller: controller),
                  Expanded(child: Center(child: _buildBarcode(_barcode))),
                  SwitchCameraButton(controller: controller),
                  AnalyzeImageFromGalleryButton(controller: controller, handleBarcode: _handleBarcode,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await controller.dispose();
  }
}

