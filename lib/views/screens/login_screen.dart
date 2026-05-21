import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:qr_device/controllers/auth_controller.dart';
import 'package:qr_device/constants/color_palette.dart';
import 'package:qr_device/views/widgets/custom_textfield.dart';
import 'package:qr_device/views/widgets/glow_blob.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> fadeIn;
  late final Animation<Offset> slideUp;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    fadeIn = CurvedAnimation(parent: controller, curve: Curves.easeOutCubic);
    slideUp = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) => Scaffold(
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color.fromARGB(255, 15, 32, 39),
                    Color.fromARGB(255, 59, 107, 128),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -40,
              left: -30,
              child: GlowBlob(
                size: 50.w,
                color: const Color(0xFF3A7BD5).withValues(alpha: 0.35),
              ),
            ),
            Positioned(
              bottom: -60,
              right: -40,
              child: GlowBlob(
                size: 60.w,
                color: const Color(0xFF00D2FF).withValues(alpha: 0.25),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 7.w),
                child: FadeTransition(
                  opacity: fadeIn,
                  child: SlideTransition(
                    position: slideUp,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.94),
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 30,
                            offset: Offset(0, 18),
                          ),
                        ],
                      ),
                      child: Form(
                        key: authProvider.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 6.w,
                                  backgroundColor: const Color(0xFF0F2027),
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    color: Colors.white,
                                    size: 6.w,
                                  ),
                                ),
                                SizedBox(width: 4.w),
                                Expanded(
                                  child: Text(
                                    'Shop Admin',
                                    style: TextStyle(
                                      color: const Color(0xFF0E1C24),
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Sign in to manage stamps and scan QR codes.',
                              style: TextStyle(
                                color: const Color(0xFF516D7B),
                                fontSize: 17.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            CustomTextfield(
                              label: 'Email',
                              hint: 'admin@example.com',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: Icons.alternate_email,
                              controller: authProvider.emailController,
                              validator: authProvider.emailValidator,
                            ),
                            SizedBox(height: 2.h),
                            CustomTextfield(
                              label: 'Password',
                              hint: 'Your password',
                              obscureText: authProvider.obscurePassword,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: GestureDetector(
                                onTap: authProvider.toggleObscurePassword,
                                child: Icon(
                                  authProvider.obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color(0xFF607D8B),
                                ),
                              ),
                              controller: authProvider.passwordController,
                              validator: authProvider.passwordValidator,
                            ),
                            SizedBox(height: 3.h),
                            ElevatedButton(
                              onPressed: authProvider.isLoading
                                  ? null
                                  : () => authProvider.login(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: ColorPalette.primary,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: authProvider.isLoading
                                  ? SizedBox(
                                      height: 7.w,
                                      width: 7.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
