import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/authentication/screen/sign_in_mail.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/ticket_details.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/language_provider.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/profile_provider.dart';
import 'package:telemedicine_hub_doctor/features/profile/screens/change_language_screen.dart';

import 'package:telemedicine_hub_doctor/features/profile/screens/help_support_screen.dart';
import 'package:telemedicine_hub_doctor/features/profile/screens/notification_setting_screen.dart';
import 'package:telemedicine_hub_doctor/features/profile/screens/reset_password_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  XFile? selectedImage;
  @override
  Widget build(BuildContext context) {
    var authProvider = Provider.of<AuthProvider>(context);
    var profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: Column(
                children: [
                  Container(
                    height: 84.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12.h)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.h, vertical: 12.h),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2000),
                            clipBehavior: Clip.antiAlias,
                            child: CircleAvatar(
                              backgroundImage:
                                  (authProvider.usermodel?.imageUrl != null &&
                                          authProvider
                                              .usermodel!.imageUrl!.isNotEmpty)
                                      ? NetworkImage(
                                          // fit: BoxFit.contain,
                                          authProvider.usermodel!.imageUrl!)
                                      : const AssetImage(
                                          "assets/images/profile.png"),
                              radius: 30.h,
                              //   child:

                              //       (authProvider.usermodel?.imageUrl != null &&
                              //               authProvider
                              //                   .usermodel!.imageUrl!.isNotEmpty)
                              //           ? Image.network(
                              //               fit: BoxFit.contain,
                              //               authProvider.usermodel!.imageUrl!)
                              //           : SvgPicture.asset(
                              //               AppImages.person,
                              //               fit: BoxFit.contain,
                              //             ),
                            ),
                          ),
                          SizedBox(
                            width: 16.h,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                authProvider.usermodel?.nameEnglish
                                        .toString() ??
                                    '',
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        fontSize: 18.h,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Text(
                                authProvider.usermodel?.email.toString() ?? "",
                                // "${authProvider.usermodel?.imageUrl}",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        fontSize: 12.h,
                                        fontWeight: FontWeight.w400)),
                              )
                            ],
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () async {
                              final XFile? pickedImage =
                                  await ImagePickerHelper.pickImage(context);
                              if (pickedImage != null) {
                                setState(() {
                                  selectedImage = pickedImage;
                                });
                                var res =
                                    await profileProvider.uploadProfilePicture(
                                        file: File(selectedImage!.path),
                                        context: context);
                                if (res.success) {
                                  Fluttertoast.showToast(
                                      msg: "Profile Upload Successfully!");
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Profile Upload Failed!");
                                }
                              }
                            },
                            child: Container(
                              height: 32.h,
                              width: 32.w,
                              // padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: AppColors.primaryBlue,
                                  )),
                              child: Icon(
                                Iconsax.document_upload,
                                size: 18.h,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.generalSettings,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 14.h, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: Column(
                      children: [
                        _buildOptionBar(
                            icon: Iconsax.notification,
                            name: AppLocalizations.of(context)!.notifications,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const NotificationSettingScreen()));
                            }),
                        SizedBox(
                          height: 20.h,
                        ),
                        _buildOptionBar(
                            icon: Iconsax.language_circle,
                            name: AppLocalizations.of(context)!.changeLanguage,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const ChangeLanguageScreen()));
                            }),
                        SizedBox(
                          height: 20.h,
                        ),
                        _buildOptionBar(
                            icon: Iconsax.like_1,
                            name: AppLocalizations.of(context)!.helpAndSupport,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const HelpSupportScreen()));
                            }),
                        SizedBox(
                          height: 20.h,
                        ),
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      AppLocalizations.of(context)!.accountSettings,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 14.h, fontWeight: FontWeight.w600)),
                    ),
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.h),
                    child: Column(
                      children: [
                        _buildOptionBar(
                            icon: Iconsax.key,
                            name: AppLocalizations.of(context)!.resetPassword,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                      builder: (context) =>
                                          const ResetPasswordScreen()));
                            }),
                        SizedBox(
                          height: 20.h,
                        ),
                        _buildOptionBar(
                            icon: Iconsax.logout,
                            name: AppLocalizations.of(context)!.logOut,
                            onPressed: () async {
                              _buildLogoutview(context);
                            }),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget _buildOptionBar(
    {required IconData icon,
    required String name,
    required VoidCallback onPressed}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12.h),
    onTap: onPressed,
    child: Container(
      height: 56.h,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(12.h))),
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.h),
      child: Row(
        children: [
          Icon(
            icon,
          ),
          SizedBox(
            width: 18.h,
          ),
          Text(
            name,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(fontSize: 14.h, fontWeight: FontWeight.w600)),
          ),
          const Spacer(),
          const Icon(Iconsax.arrow_right_34)
        ],
      ),
    ),
  );
}

void _buildLogoutview(BuildContext context) {
  var authProvider = Provider.of<AuthProvider>(context, listen: false);
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.9,
        expand: false,
        snap: true,
        snapSizes: const [0.6, 0.9],
        builder: (context, scrollController) => Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.h),
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                SizedBox(
                  height: 28.h,
                ),
                Text(
                  AppLocalizations.of(context)!.areYouSureYouWantToLogout,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w600)),
                ),
                Column(
                  children: [
                    SizedBox(height: 16.h),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: const Color(0xFFEDEDF4),
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          AppLocalizations.of(context)!.cancel,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 12.h),
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            )),
                        onPressed: () async {
                          var res = await authProvider.logOut(context);
                          if (res.success) {
                            Fluttertoast.showToast(
                                msg: "Logged out succeddfully! ");
                            Navigator.pushAndRemoveUntil(
                              context,
                              CupertinoPageRoute(
                                  builder: (context) => const SignInEmail()),
                              (route) => false,
                            );
                          } else {
                            Fluttertoast.showToast(msg: "Log out failed");
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.yesLogout,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ),
                    SizedBox(height: MediaQuery.paddingOf(context).bottom + 10),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
