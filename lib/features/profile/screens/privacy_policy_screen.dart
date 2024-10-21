import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              color: Colors.black,
            ),
          ),
          title: Text(
            "Terms of Use",
            style: TextStyle(
              fontSize: 20.sp,
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            right: 24.sp,
            left: 24.sp,
            top: 16.sp,
            bottom: 16.sp + MediaQuery.paddingOf(context).bottom,
          ),
          child: Image.asset('assets/images/privacy_en.png'),
        ),
      ),
    );
  }
}
