// ignore_for_file: avoid_types_as_parameter_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            AppLocalizations.of(context)!.notificationSettings,
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
              _buildSwitchView(
                  title: AppLocalizations.of(context)!.generalPushNotifications,
                  subtitle: AppLocalizations.of(context)!
                      .allKindOfNotificationsThatTheAppGonnaShowToYou,
                  onPress: (bool) {},
                  switchValue: true),
              SizedBox(
                height: 20.h,
              ),
              _buildSwitchView(
                  title: AppLocalizations.of(context)!.patientsResponse,
                  subtitle: AppLocalizations.of(context)!
                      .receiveAllPatientsResponseRelatedNotifications,
                  onPress: (bool) {},
                  switchValue: true),
              SizedBox(
                height: 20.h,
              ),
              _buildSwitchView(
                  title: AppLocalizations.of(context)!.ticketNotifications,
                  subtitle: AppLocalizations.of(context)!
                      .receiveAllTicketRelatedNotifications,
                  onPress: (bool) {},
                  switchValue: false),
              SizedBox(
                height: 20.h,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _buildSwitchView(
    {required String title,
    required String subtitle,
    required bool switchValue,
    required Function(bool) onPress}) {
  return Container(
    height: 88.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.h),
    ),
    child: Padding(
      padding: EdgeInsets.all(12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontSize: 16.h,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(
                  height: 6.h,
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.openSans(
                    textStyle: TextStyle(
                      fontSize: 12.h,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            width: 20.w,
          ),
          SizedBox(
            height: 32.h,
            width: 52.w,
            child: CupertinoSwitch(
              value: switchValue, // Use the dynamic value here
              onChanged: onPress,
              activeColor: AppColors.primaryBlue,
            ),
          )
        ],
      ),
    ),
  );
}
