// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';

// class CustomFractionalButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final bool isLoading;

//   const CustomFractionalButton({
//     super.key,
//     required this.text,
//     required this.onPressed,
//     this.isLoading = false,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return FractionallySizedBox(
//       // widthFactor: 1.h,
//       child: FilledButton(
//         style: FilledButton.styleFrom(
//           padding:
//               EdgeInsets.symmetric(vertical: 12.h), // Fixed vertical padding
//           backgroundColor: const Color(0xFF015988), // Fixed background color
//           foregroundColor: Colors.white, // Fixed foreground color
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.h), // Fixed border radius
//           ),
//           minimumSize: Size(double.infinity, 48.h),
//         ),
//         onPressed: isLoading ? null : onPressed,
//         child: isLoading
//             ? SizedBox(
//                 height: 24.h,
//                 width: 24.h,
//                 child: const CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   valueColor: AlwaysStoppedAnimation<Color>(
//                       Colors.white), // Fixed color for loading spinner
//                 ),
//               )
//             : Text(
//                 text,
//                 style: TextStyle(
//                   fontSize: 16.sp,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomFractionalButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool secondary; // Added 'secondary' parameter
  final Color? color;

  const CustomFractionalButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.secondary = false,
    this.color, // Default value is 'false'
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      child: FilledButton(
        style: FilledButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          backgroundColor: color ??
              (secondary
                  ? const Color(0xFFEDEDF4) // Secondary background color
                  : const Color(0xFF015988)), // Default background color
          foregroundColor: color ??
              (secondary
                  ? Colors.black // Secondary text color
                  : Colors.white), // Default text color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.h),
          ),
          minimumSize: Size(double.infinity, 48.h),
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.h,
                child: const CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Colors.white), // Fixed color for loading spinner
                ),
              )
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: secondary
                      ? Colors.black
                      : Colors.white, // Text color change based on 'secondary'
                ),
              ),
      ),
    );
  }
}
