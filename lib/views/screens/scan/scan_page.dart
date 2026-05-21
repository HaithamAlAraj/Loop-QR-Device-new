import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qr_device/core/network/api_service.dart';
import 'package:qr_device/constants/color_palette.dart';
import 'package:qr_device/views/widgets/scan_widgets/scan_choice.dart';
import 'package:qr_device/views/screens/scan/qr_scanner_screen.dart';
import 'package:sizer/sizer.dart';

class ScanPage extends StatelessWidget {
  const ScanPage({super.key});

  void _showScanResult(
    Map<String, dynamic> result, {
    required String successMsg,
    required String errorMsg,
  }) {
    if (result["success"]) {
      Get.closeAllSnackbars();
      Get.snackbar(
        'Success',
        successMsg,
        backgroundColor: ColorPalette.success,
        colorText: Colors.white,
      );
    } else {
      final err = result["error"];
      final msg = err is Map
          ? (err["error"] ?? errorMsg)
          : errorMsg;
      Get.closeAllSnackbars();
      Get.snackbar(
        'Error',
        msg.toString(),
        backgroundColor: ColorPalette.error,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 2.h, left: 10.w, right: 10.w),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScanChoice(
              icon: Icons.qr_code_2_rounded,
              text: "Scan Stamp QR",
              onTap: () async {
                final result = await Get.to<Map<String, dynamic>>(
                  () => QrScannerScreen(
                    onScan: (qrId) async {
                      final apiService = ApiService(client: Client());
                      return apiService.confirmRedemptionQr(qrId);
                    },
                  ),
                );
                if (result == null) return;
                _showScanResult(
                  result,
                  successMsg: 'Stamp redeemed!',
                  errorMsg: 'Redemption failed',
                );
              },
            ),
            SizedBox(height: 2.h),
            ScanChoice(
              icon: Icons.monetization_on,
              text: "Scan Points QR",
              onTap: () async {
                final result = await Get.to<Map<String, dynamic>>(
                  () => QrScannerScreen(
                    onScan: (qrId) async {
                      final apiService = ApiService(client: Client());
                      return apiService.confirmPointsRedemptionQr(qrId);
                    },
                  ),
                );
                if (result == null) return;
                _showScanResult(
                  result,
                  successMsg: 'Points redeemed!',
                  errorMsg: 'Points redemption failed',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
