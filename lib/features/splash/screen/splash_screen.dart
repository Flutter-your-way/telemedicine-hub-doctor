// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/common/managers/local_manager.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/sign_in_mail.dart';
import 'package:telemedicine_hub_doctor/features/navigation/bottom_nav_bar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  getData() async {
    String? token = await LocalDataManager.getToken();
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      if (token == null || token.isEmpty) {
        bool flag = await LocalDataManager.appOpened();
        if (flag) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInEmail(),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const SignInEmail(),
              ));
        }
      } else {
        Provider.of<AuthProvider>(context, listen: false).authToken = token;

        await Provider.of<AuthProvider>(context, listen: false).getUser();
        if (!mounted) return; // Add this check

        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavBar(),
            ));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              height: 250.h,
              width: 250.w,
              AppImages.main_logo,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(
            height: 32,
          ),
          // Text(
          //   'Te',
          //   style: GoogleFonts.urbanist(
          //     fontSize: 40,
          //     color: AppColors.white,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
