// ignore_for_file: use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:telemedicine_hub_doctor/common/button/custom_button.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/sign_in_mail.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  TextEditingController email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.sizeOf(context).height,
          decoration: BoxDecoration(
            gradient: AppColors.backgroundGradient,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(90, 32, 90, 0),
                      child: Image.asset(
                        // height: 100.h,
                        // width: 100.w,
                        AppImages.main_logo,
                        // fit: BoxFit.contain,
                      ),
                    ),
                    Text(
                      "Forget Password",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8.h,
                    ),
                    Text(
                      "Enter your email to send reset link",
                      style: TextStyle(
                        color: AppColors.grey,
                        fontSize: 16.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 24.h,
                    ),
                    CustomTextFormField(
                      controller: email,
                      title: "Enter email",
                      prefix: const Icon(
                        Iconsax.sms,
                        color: Colors.black,
                      ),
                      // prefix: const Icon(
                      //   Iconsax.call,
                      //   color: Colors.black,
                      // ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomButton(
                      name: "Send Link",
                      onPressed: () async {
                        if (email.text.isNotEmpty) {
                          var res = await authProvider.forgetPassword(
                              email: email.text.trim());
                          if (res.success) {
                            Fluttertoast.showToast(msg: " ${res.msg}");
                            Navigator.of(context).pop();
                          } else {
                            Fluttertoast.showToast(msg: "${res.msg} ");
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "Please enter your email");
                        }
                      },
                      isLoading: authProvider.isLoading,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 16.h,
                // ),
                const Spacer(flex: 3),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
