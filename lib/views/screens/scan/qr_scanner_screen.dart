import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key, required this.onScan});

  final Future<Map<String, dynamic>> Function(String qrId) onScan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: MobileScanner(
        controller: MobileScannerController(
          detectionSpeed: DetectionSpeed.noDuplicates,
          returnImage: true,
        ),
        onDetect: (capture) async {
          final barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            final rawValue = barcode.rawValue;
            if (rawValue == null) continue;
            final result = await onScan(rawValue);
            if (context.mounted) Get.back(result: result);
            return;
          }
        },
      ),
    );
  }
}
