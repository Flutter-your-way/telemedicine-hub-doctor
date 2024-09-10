import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/ticket_details.dart';

class TicketCard extends StatefulWidget {
  const TicketCard({super.key});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => const TicketDetailsScreen(),
            ));
      },
      child: SizedBox(
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 20.h),
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
      ),
    );
  }
}
