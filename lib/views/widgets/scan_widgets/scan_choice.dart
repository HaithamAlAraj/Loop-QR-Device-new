import 'package:flutter/material.dart';
import 'package:qr_device/constants/color_palette.dart';
import 'package:sizer/sizer.dart';

class ScanChoice extends StatelessWidget {
  const ScanChoice({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  final IconData icon;
  final String text;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: ColorPalette.quaternary,
            borderRadius: BorderRadius.circular(10),
          ),
          width: 100.w,
          height: 34.h,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 24.w),
                SizedBox(height: 1.h),
                Text(text, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
