import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextfield extends StatelessWidget {
  const CustomTextfield({
    super.key,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.validator,
  });

  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF3A5462),
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            letterSpacing: 0.4,
          ),
        ),
        SizedBox(height: 0.5.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: const Color(0xFFF3F6F8),
            prefixIcon: prefixIcon == null
                ? null
                : Icon(prefixIcon, color: const Color(0xFF607D8B)),
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.h,
              vertical: 4.w,
            ),
            hintStyle: TextStyle(fontSize: 17.sp),
            errorMaxLines: 2,
          ),
        ),
      ],
    );
  }
}
