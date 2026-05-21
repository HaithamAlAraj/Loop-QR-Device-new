import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_device/constants/color_palette.dart';
import 'package:qr_device/controllers/auth_controller.dart';
import 'package:qr_device/views/screens/stamps/stamps_page.dart';
import 'package:qr_device/views/screens/scan/scan_page.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorPalette.primary,
          foregroundColor: Colors.white,
          title: const Text(
            'QR Device',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Confirm Logout'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Logout',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  if (!context.mounted) return;
                  context.read<AuthProvider>().logout();
                }
              },
              tooltip: 'Logout',
            ),
          ],
          bottom: const TabBar(
            labelStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color.fromARGB(255, 175, 175, 175),
            ),
            indicatorColor: ColorPalette.quaternary,
            tabs: [
              Tab(text: 'Stamps'),
              Tab(text: 'Scan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            StampsPage(),
            ScanPage(),
          ],
        ),
      ),
    );
  }
}
