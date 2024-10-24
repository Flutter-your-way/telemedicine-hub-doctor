// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/common/button/custom_button.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/sign_in_mail.dart';

import '../../../gradient_theme.dart';

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
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          // automaticallyImplyLeading: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Iconsax.arrow_left_2,
              color: Colors.black,
            ),
          ),
          // title: Text(
          //   "widget.title",
          //   style: GoogleFonts.openSans(
          //       textStyle:
          //           TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          // ),
          // centerTitle: false,
        ),
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
                        AppLocalizations.of(context)!.forgotPassword,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 32.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Text(
                        AppLocalizations.of(context)!
                            .enterYourEmailToSendResetLink,
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
                        title: AppLocalizations.of(context)!.enterEmail,
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
                        name: AppLocalizations.of(context)!.sendLink,
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
      ),
    );
  }
}
