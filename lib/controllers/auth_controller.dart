import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:qr_device/core/network/api_service.dart';
import 'package:qr_device/core/services/auth_storage.dart';
import 'package:qr_device/views/screens/login_screen.dart';
import 'package:qr_device/views/screens/home_screen.dart';

class AuthProvider extends ChangeNotifier {
  String? token;
  bool isLoading = false;
  bool isLoggedIn = false;
  bool obscurePassword = true;
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final apiService = ApiService(client: Client());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    apiService.dispose();
    super.dispose();
  }

  void resetAllVariables() {
    obscurePassword = true;
    emailController.clear();
    passwordController.clear();
  }

  void toggleObscurePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    if (!value.trim().contains('@')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  Future<void> checkToken() async {
    token = await AuthStorage.getAccessToken();
    if (token != null) {
      isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;
    isLoading = true;
    notifyListeners();
    try {
      final response = await apiService.shopAdminLogin(
        emailController.text.trim(),
        passwordController.text,
      );
      if (response["success"]) {
        final data = response["data"] as Map<String, dynamic>;
        await AuthStorage.setAccessToken(data["accessToken"]);
        await AuthStorage.setRefreshToken(data["refreshToken"]);
        token = data["accessToken"];
        isLoggedIn = true;
        isLoading = false;
        notifyListeners();
        Get.offAll(() => const HomeScreen());
        return;
      }
      final error = response["error"];
      final message =
          error is Map ? (error["error"] ?? 'Login failed') : 'Login failed';
      Get.closeAllSnackbars();
      Get.snackbar('Error', message.toString());
    } catch (e) {
      Get.closeAllSnackbars();
      Get.snackbar('Error', 'Connection failed. Please try again.');
    }
    isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    try {
      await apiService.logout();
    } catch (_) {}
    await AuthStorage.clearAccessToken();
    await AuthStorage.clearRefreshToken();
    token = null;
    isLoggedIn = false;
    resetAllVariables();
    notifyListeners();
    Get.offAll(() => const LoginScreen());
  }
}
