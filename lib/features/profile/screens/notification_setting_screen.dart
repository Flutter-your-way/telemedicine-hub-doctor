import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({super.key});

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
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
            _buildSwitchView(
                title: "General push notifications",
                subtitle:
                    "All kind of notifications that the app gonna show to you",
                onPress: (bool) {},
                switchValue: true),
            SizedBox(
              height: 20.h,
            ),
            _buildSwitchView(
                title: "Patient’s Response",
                subtitle:
                    "Receive all patient’s response related notifications",
                onPress: (bool) {},
                switchValue: true),
            SizedBox(
              height: 20.h,
            ),
            _buildSwitchView(
                title: "Ticket notifications",
                subtitle: "Receive all ticket related notifications ",
                onPress: (bool) {},
                switchValue: false),
            SizedBox(
              height: 20.h,
            ),
          ],
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
    decoration: BoxDecoration(
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
