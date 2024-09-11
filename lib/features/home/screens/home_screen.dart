import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/notification_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/ticket_view_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const HomeAppBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: [
                        _buildTopViewCards(
                          "10",
                          "Open Tickets",
                          () {
                            Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                  builder: (context) => TicketViewScreen(
                                    title: 'Complete Ticket',
                                  ),
                                  context: context,
                                ));
                          },
                        ),
                        _buildTopViewCards(
                          "6",
                          "Resolved Tickets",
                          () {
                            Navigator.push(
                                context,
                                CupertinoDialogRoute(
                                  builder: (context) => TicketViewScreen(
                                    title: 'Pending Ticket',
                                  ),
                                  context: context,
                                ));
                          },
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Row(
                      children: [
                        Text("Tickets",
                            style: GoogleFonts.notoSans(
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                        const Spacer(),
                        CupertinoButton(
                          child: Text('View All',
                              style: GoogleFonts.openSans(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 5,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return const TicketCard();
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
  
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 8.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Good Morning",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.captionColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text("Dr. Peter",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const NotificationScreen()));
              
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue,
                      )),
                  child: const Icon(
                    Iconsax.notification_1,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

Widget _buildTopViewCards(
  String value,
  String name,
  final VoidCallback onPressed,
) {
  return Expanded(
      child: SizedBox(
    child: Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))),
          Text(name,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400))),
          CupertinoButton(
              onPressed: onPressed,
              child: Text("View All",
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600)))),
        ],
      ),
    ),
  ));
}
