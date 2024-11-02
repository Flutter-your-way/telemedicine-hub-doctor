import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/profile_provider.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool oldPass = true;
  bool newPass = true;
  TextEditingController email = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();
  clearcontroller() {
    setState(() {
      oldPassword.text = '';
      newPassword.text = '';
    });
  }

  // Password validation function
  String? _passwordValidator(String? value) {
    final trimmedValue = value?.trim() ?? '';
    if (trimmedValue.isEmpty) {
      return "Password cannot be empty";
    } else if (trimmedValue.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    var profileProvider = Provider.of<ProfileProvider>(context);
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            AppLocalizations.of(context)!.resetPassword,
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
              CustomTextFormField(
                obscureText: oldPass,
                controller: oldPassword,
                title: AppLocalizations.of(context)!.setPassword,
                prefix: const Icon(Iconsax.lock),
                suffix: IconButton(
                  icon: Icon(
                    oldPass ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                  onPressed: () {
                    setState(() {
                      oldPass = !oldPass;
                    });
                  },
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomTextFormField(
                obscureText: newPass,
                controller: newPassword,
                title: AppLocalizations.of(context)!.newPassword,
                prefix: const Icon(Iconsax.lock),
                suffix: IconButton(
                  icon: Icon(
                    newPass ? Iconsax.eye : Iconsax.eye_slash,
                  ),
                  onPressed: () {
                    setState(() {
                      newPass = !newPass;
                    });
                  },
                ),
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
                  onPressed: () async {
                    // Trimmed passwords for validation and submission
                    final trimmedOldPassword = oldPassword.text.trim();
                    final trimmedNewPassword = newPassword.text.trim();

                    // Validate each password field individually and show specific messages
                    String? oldPasswordError =
                        _passwordValidator(trimmedOldPassword);
                    String? newPasswordError =
                        _passwordValidator(trimmedNewPassword);

                    if (oldPasswordError != null) {
                      Fluttertoast.showToast(msg: oldPasswordError);
                    } else if (newPasswordError != null) {
                      Fluttertoast.showToast(msg: newPasswordError);
                    } else {
                      // If both passwords are valid, proceed with password reset
                      var res = await profileProvider.resetPassword(
                        email: Provider.of<AuthProvider>(context, listen: false)
                            .usermodel!
                            .email
                            .toString(),
                        oldPassword: trimmedOldPassword,
                        newPassword: trimmedNewPassword,
                      );
                      if (res.success) {
                        Fluttertoast.showToast(msg: res.msg);
                        clearcontroller();
                      } else {
                        Fluttertoast.showToast(msg: res.msg);
                      }
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.setPassword,
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
                    Text(AppLocalizations.of(context)!.toCreateASecurePassword,
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.w600),
                        )),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                        ' • ${AppLocalizations.of(context)!.useAtLeastEightCharacters}',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        )),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                        ''' • ${AppLocalizations.of(context)!.useMixOfLettersNumbers}''',
                        style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400),
                        )),
                    SizedBox(
                      height: 6.h,
                    ),
                    Text(
                        ' • ${AppLocalizations.of(context)!.combineWordsAndSymbols}',
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
