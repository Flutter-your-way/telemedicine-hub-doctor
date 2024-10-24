import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/common/button/custom_button.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/forget_password.dart';
import 'package:telemedicine_hub_doctor/features/navigation/bottom_nav_bar.dart';

class SignInEmail extends StatefulWidget {
  const SignInEmail({super.key});

  @override
  State<SignInEmail> createState() => _SignInEmailState();
}

class _SignInEmailState extends State<SignInEmail> {
  final ValueNotifier<bool> _hidePass = ValueNotifier<bool>(true);

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
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
                      AppLocalizations.of(context)!.signIn,
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
                          .enterYourDetailsToProceedFurther,
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
                      title: AppLocalizations.of(context)!.email,
                      // prefix: SvgPicture.asset(
                      //   'assets/icons/email_icon.svg',
                      //   height: 16.h,
                      //   width: 16.w,
                      // ),
                      prefix: const Icon(
                        Iconsax.sms,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    ValueListenableBuilder(
                        valueListenable: _hidePass,
                        builder: (context, value, _) {
                          return CustomTextFormField(
                            obscureText: value,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter you password";
                              }
                              if (value.length < 6) {
                                return "Must have at lest 6 chars";
                              }
                              return null;
                            },
                            suffix: IconButton(
                              icon: Icon(
                                value ? Iconsax.eye : Iconsax.eye_slash,
                              ),
                              onPressed: () {
                                setState(() {
                                  _hidePass.value = !value;
                                });
                              },
                            ),
                            controller: password,
                            title: AppLocalizations.of(context)!.enterPassword,
                            prefix: SvgPicture.asset(
                              AppImages.lock_icon,
                              height: 16.h,
                              width: 16.w,
                            ),
                          );
                        }),
                    SizedBox(
                      height: 16.h,
                    ),
                    CustomButton(
                      name: AppLocalizations.of(context)!.signIn,
                      onPressed: () async {
                        if (password.text.isNotEmpty) {
                          if (email.text.isNotEmpty &&
                              email.text.contains('@')) {
                            var res = await authProvider.login(
                                email: email.text.trim(),
                                password: password.text.trim());
                            log("Success Values : ${res.success}");
                            if (res.success) {
                              log("Code : ${res.code}\nMessage : ${res.msg}");
                              Fluttertoast.showToast(
                                  msg: "Login Successfully ");
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const BottomNavBar()),
                                (route) => false,
                              );
                            } else {
                              log(" ${res.msg}  ");
                              Fluttertoast.showToast(msg: " ${res.msg}  ");
                            }
                          } else {
                            Fluttertoast.showToast(msg: "Please enter email");
                          }
                        } else {
                          Fluttertoast.showToast(msg: "Please enter password");
                        }
                      },
                      isLoading: authProvider.isLoading,
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) =>
                                    const ForgetPasswordScreen(),
                              ));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.forgotPassword,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color:
                                AppColors.primaryBlue, // Change color to blue
                            decoration: TextDecoration.underline,
                            // Underline the text
                          ),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
                    ),
                  ],
                ),
                // SizedBox(
                //   height: 16.h,
                // ),
                // MaterialButton(
                //   onPressed: () {
                //     // Navigator.push(
                //     //   context,
                //     //   CupertinoPageRoute(
                //     //     builder: (context) => const PrivacyPolicyScreen(),
                //     //   ),
                //     // );
                //   },
                //   child: Text(
                //     AppLocalizations.of(context)!.privacyPolicyTermsOfService,
                //     style: TextStyle(
                //       fontSize: 14.sp,

                //       color: AppColors.grey, // Change color to blue
                //     ),
                //     textAlign: TextAlign.end,
                //   ),
                // ),
                const SizedBox(height: 0),
              ],
            ),
          ),
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
      borderRadius: BorderRadius.circular(10000),
      child: TextFormField(
        // scrollPadding: EdgeInsets.all(12),
        obscureText: obscureText,
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
            borderRadius: BorderRadius.circular(10000),
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
