import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../constants/color_palette.dart';
import '../widgets/app_styles.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String? _lastScan;

  void _onDetect(BarcodeCapture capture) {
    final value =
        capture.barcodes.isNotEmpty ? capture.barcodes.first.rawValue : null;
    if (value == null || value == _lastScan) {
      return;
    }
    setState(() {
      _lastScan = value;
    });
  }

  void _redeemScan() {
    if (_lastScan == null) {
      _showSnack('Scan a QR first.');
      return;
    }
    _showSnack('Submitted scan for $_lastScan');
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            height: 440,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: ColorPalette.ternary, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: MobileScanner(
                onDetect: _onDetect,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          SizedBox(
            width: double.infinity,
            child: BigButton(
              onPressed: _redeemScan,
              child: const Text('Submit Scan'),
            ),
          ),
        ],
      ),
    );
  }
}
