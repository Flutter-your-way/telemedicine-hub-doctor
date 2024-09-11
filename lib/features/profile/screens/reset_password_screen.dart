import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Notification Settings",
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.h),
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            const CustomTextFormField(
              title: "New Password",
              prefix: Icon(Iconsax.lock),
              suffix: Icon(Iconsax.eye),
            ),
            SizedBox(
              height: 20.h,
            ),
            const CustomTextFormField(
              title: "Confirm Password",
              prefix: Icon(Iconsax.lock),
              suffix: Icon(Iconsax.eye),
            ),
            SizedBox(
              height: 20.h,
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  // Handle sort action
                  Navigator.pop(context);
                },
                child: Text("Set Password",
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.bold),
                    )),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("To create a secure password:",
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 18.sp, fontWeight: FontWeight.w600),
                      )),
                  SizedBox(
                    height: 10.h,
                  ),
                  Text(' • Use at least 8 characters',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w400),
                      )),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                      ''' • Use a mix of letters, numbers, and special characters (e.g.:     #)''',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w400),
                      )),
                  SizedBox(
                    height: 6.h,
                  ),
                  Text(
                      ' • Try combining words and symbols into a unique phrase',
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w400),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.title,
    this.controller,
    this.prefix,
    this.suffix,
    this.validator,
    this.obscureText = false,
    this.inputFormatters,
    this.keyboardType,
    this.onTap,
    this.isEnabled,
    this.onChanged,
  });

  final String? title;
  final TextEditingController? controller;
  final Widget? prefix;
  final Widget? suffix;

  final String? Function(String? value)? validator;
  final bool obscureText;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final VoidCallback? onTap;
  final bool? isEnabled;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.h),
      child: TextFormField(
        obscureText: obscureText,
        // scrollPadding: EdgeInsets.all(12),
        controller: controller,
        validator: validator,
        style: TextStyle(
          color: AppColors.black, // Set text color to black
        ),

        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          focusColor: AppColors.primaryBlue,
          // contentPadding: const EdgeInsets.all(24),
          hintText: title,
          hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.grey),
          prefixIcon: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 15, 0),
            child: prefix,
          ),
          // prefixIconConstraints: BoxConstraints(
          //   minWidth: 0,
          //   minHeight: 0,
          // ),
          fillColor: Colors.white,

          suffixIconColor: AppColors.black,
          suffixIcon: suffix,

          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.h),
            borderSide: BorderSide(
              color: AppColors.greyOutline, // Color of the border
              width: 1.0, // Thickness of the border
            ),
          ),
        ),
      ),
    );
  }
}
