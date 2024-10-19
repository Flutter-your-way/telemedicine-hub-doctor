// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/psychology_ticket_details.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/ticket_details.dart';

class TicketCard extends StatefulWidget {
  TicketModel ticket;
  TicketCard({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'draft':
      case 'pending':
        return Colors.red;
      case 'completed':
        return Colors.green;
      case 'forwarded':
        return AppColors.yellow;
      default:
        return Colors.grey;
    }
  }

  // Function to capitalize the first letter of the status
  String capitalizeFirstLetter(String status) {
    if (status.isEmpty) return status;
    return status[0].toUpperCase() + status.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    String statusText = capitalizeFirstLetter(widget.ticket.status.toString());
    String getTimeUntilAppointment(DateTime scheduledDate) {
      final now = DateTime.now();
      final difference = scheduledDate.difference(now);

      if (difference.inDays > 0) {
        return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'Just now';
      }
    }

    DateTime dateTime = DateTime.parse(
        widget.ticket.scheduleDate.toString() ?? DateTime.now().toString());
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

    String formattedTime = DateFormat('h:mm a').format(dateTime);
    String timeUntilAppointment = getTimeUntilAppointment(dateTime);
    return GestureDetector(
      onTap: () {
        if (widget.ticket.disease?.name == "mental") {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    PsychologyTicketDetailsScreen(id: widget.ticket.id),
              ));
        } else {
          Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => TicketDetailsScreen(id: widget.ticket.id),
              ));
        }
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
                  borderRadius: BorderRadius.circular(12.h),
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
                                padding: EdgeInsets.all(6.h),
                                decoration: BoxDecoration(
                                  color: getStatusColor(
                                      widget.ticket.status.toString()),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  statusText,
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
                            widget.ticket.name.toString(),
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Row(
                            children: [
                              Text("ETA - $timeUntilAppointment  • ",
                                  style: GoogleFonts.openSans(
                                      textStyle: TextStyle(
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w400))),
                              Text(
                                widget.ticket.disease!.name.toString(),
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
                  padding: EdgeInsets.all(10.w),
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
                            formattedDate,
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
                            formattedTime,
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
                  decoration: BoxDecoration(
                    color: getStatusColor(widget.ticket.status.toString()),
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
