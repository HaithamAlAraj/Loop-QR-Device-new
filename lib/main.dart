import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'controllers/auth_controller.dart';
import 'controllers/stamps_controller.dart';
import 'views/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => StampsProvider()),
      ],
      child: Sizer(
        builder: (context, orientation, screenType) => GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'QR Device',
          home: const SplashScreen(),
          theme: Theme.of(context).copyWith(
            scaffoldBackgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
