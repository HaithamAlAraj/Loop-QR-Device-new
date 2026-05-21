import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qr_device/controllers/auth_controller.dart';
import 'package:qr_device/core/services/auth_storage.dart';
import 'package:qr_device/views/screens/login_screen.dart';
import 'package:qr_device/views/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkAuthStatus();
    });
  }

  void checkAuthStatus() async {
    final authProvider = context.read<AuthProvider>();
    await authProvider.checkToken();

    if (authProvider.isLoggedIn) {
      Get.offAll(() => const HomeScreen());
    } else {
      await AuthStorage.clearAccessToken();
      await AuthStorage.clearRefreshToken();
      Get.offAll(() => const LoginScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
