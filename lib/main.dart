import 'package:flutter/material.dart';
import 'package:qr_device/initialize.dart';

import 'constants/color_palette.dart';
import 'pages/scan_page.dart';
import 'pages/stamps_page.dart';

void main() async {
  await initialize();
  runApp(const MyApp());
}

const String currentUserId = 'user_001';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QR Device',
      theme: ThemeData(
        primaryColor: ColorPalette.primary,
        scaffoldBackgroundColor: ColorPalette.quaternary,
        dividerColor: ColorPalette.ternary,
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 14),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.primary,
          foregroundColor: Colors.white,
          toolbarHeight: 0,
          bottom: const TabBar(
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
            unselectedLabelStyle:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 175, 175, 175)),
            indicatorColor: ColorPalette.quaternary,
            tabs: [
              Tab(text: 'Stamps'),
              Tab(text: 'Scan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StampsPage(currentUserId: currentUserId),
            ScanPage(),
          ],
        ),
      ),
    );
  }
}
