import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qr_device/core/network/api_service.dart';
import 'package:qr_device/models/stamp_model.dart';

class StampsProvider extends ChangeNotifier {
  List<StampModel> _stamps = [];
  bool isLoading = false;
  String? error;
  final apiService = ApiService(client: Client());

  List<StampModel> get stamps => _stamps;

  @override
  void dispose() {
    apiService.dispose();
    super.dispose();
  }

  Future<void> fetchActiveStamps() async {
    isLoading = true;
    error = null;
    notifyListeners();
    try {
      final response = await apiService.getActiveShopStamps();
      if (response["success"]) {
        if (response["data"] is List) {
          _stamps = (response["data"] as List)
              .map(
                (e) => StampModel.fromJson(e as Map<String, dynamic>),
              )
              .toList();
        }
      } else {
        error = response["error"].toString();
      }
    } catch (e) {
      error = e.toString();
    }
    isLoading = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> generateCollectQr(
    String stampId,
    int stampsCount,
  ) async {
    try {
      final response =
          await apiService.generateCollectQr(stampId, stampsCount);
      if (response["success"]) {
        return response["data"] as Map<String, dynamic>;
      }
      final err = response["error"];
      final message =
          err is Map ? (err["error"] ?? 'Failed to generate QR') : 'Failed to generate QR';
      Get.closeAllSnackbars();
      Get.snackbar('Error', message.toString());
    } catch (e) {
      Get.closeAllSnackbars();
      Get.snackbar('Error', 'Connection failed. Please try again.');
    }
    return null;
  }
}
