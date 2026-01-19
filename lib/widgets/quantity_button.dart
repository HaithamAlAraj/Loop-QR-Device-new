import 'package:flutter/material.dart';
import 'package:qr_device/constants/color_palette.dart';

class QuantityButton extends StatelessWidget {
  const QuantityButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: ColorPalette.primary, width: 2),
            ),
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 22,
                color: ColorPalette.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
