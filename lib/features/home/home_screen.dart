import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';

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
                          () {},
                        ),
                        _buildTopViewCards(
                          "6",
                          "Resolved Tickets",
                          () {},
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
    var authProvider = Provider.of<AuthProvider>(context);
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
                  var res = await authProvider.logOut(context);
                  if (res.success) {
                    Fluttertoast.showToast(msg: "Logged out succeddfully! ");
                  } else {
                    Fluttertoast.showToast(msg: "Log out failed");
                  }
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

class TicketCard extends StatefulWidget {
  const TicketCard({super.key});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 8.w,
          vertical: 16.h,
        ),
        child: Stack(
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width - 56,
              decoration: BoxDecoration(
                color: const Color(0xFFFAFAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFF4F4F6),
                  width: 2,
                  strokeAlign: BorderSide.strokeAlignInside,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.15),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                "Confirmed",
                                style: TextStyle(
                                  color: AppColors.greenishWhite,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const Spacer(),
                            const Icon(Iconsax.attach_square)
                          ],
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          "Ticket No : 001",
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Text("ETA - 4 hours  • ",
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w400))),
                            Text(
                              "Vaginal Yeast Infection",
                              style: GoogleFonts.openSans(
                                  textStyle: TextStyle(
                                      fontSize: 12.sp,
                                      color: const Color(0xFF015988),
                                      fontWeight: FontWeight.w600)),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                    color: AppColors.bluishWhite,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(12),
                    )),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Iconsax.calendar,
                          color: AppColors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '1 Aug, 2024',
                          style: TextStyle(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Icon(
                          Iconsax.clock,
                          color: AppColors.grey,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          '2:00 PM',
                          style: TextStyle(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              left: 0,
              top: 12.h,
              child: Container(
                height: 129.h,
                width: 1.5.h,
                decoration: const BoxDecoration(
                  color: Colors.green,
                ),
              ),
            ),
          ],
        ),
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
