import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Notifications",
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
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildNotification(
                      time: '12:00',
                      title: 'New Ticket',
                      subtitle:
                          'New ticket with [Ticket No.] on [Date] at [Time]'),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildNotification(
                      time: '12:00',
                      title: 'New Ticket',
                      subtitle:
                          'New ticket with [Ticket No.] on [Date] at [Time]'),
                  SizedBox(
                    height: 20.h,
                  ),
                  _buildNotification(
                      time: '12:00',
                      title: 'New Ticket',
                      subtitle:
                          'New ticket with [Ticket No.] on [Date] at [Time]'),
                  SizedBox(
                    height: 20.h,
                  ),
                ],
              ),
            ),
            FractionallySizedBox(
              widthFactor: 1,
              child: FilledButton(
                style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    )),
                onPressed: () {},
                child: Text(
                  "Clear All",
                  style: TextStyle(
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.paddingOf(context).bottom + 20.h,
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildNotification(
    {required String time, required String title, required String subtitle}) {
  return Container(
    height: 88.h,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.h),
    ),
    child: Padding(
      padding: EdgeInsets.all(12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w400)),
          ),
          SizedBox(
            height: 4.h,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40.h,
                width: 40.w,
                child: const Icon(Iconsax.notification),
              ),
              SizedBox(
                width: 8.h,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 14.sp, fontWeight: FontWeight.bold)),
                    ),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.fade,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400)),
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
