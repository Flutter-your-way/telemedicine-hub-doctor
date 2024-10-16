import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class CustomButton extends StatelessWidget {
  final String name;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomButton({
    super.key,
    required this.name,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        width: double.infinity,
        height: 56.h, // Set a fixed height
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10000),
          color: AppColors.primaryBlue,
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  height: 24.h, // Set a fixed size for the loading indicator
                  width: 24.h,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : Text(
                  name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
        ),
      ),
    );
  }
}
