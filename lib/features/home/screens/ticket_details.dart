import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class TicketDetailsScreen extends StatefulWidget {
  const TicketDetailsScreen({super.key});

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Ticket No. 23145",
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
                                    GestureDetector(
                                      onTap: () {
                                        _buildPatientProfile(context);
                                      },
                                      child: Text(
                                        "Patient Profile",
                                        style: GoogleFonts.openSans(
                                            textStyle: TextStyle(
                                                fontSize: 14.sp,
                                                color: AppColors.primaryBlue,
                                                fontWeight: FontWeight.w600,
                                                decoration:
                                                    TextDecoration.underline)),
                                      ),
                                    )
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
            SizedBox(height: 16.h),
            Expanded(
                child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.h),
                  child: GestureDetector(
                    onTap: () {
                      showImageDialog(
                          context, 'assets/images/desease_image.png');
                    },
                    child: Image.asset(
                      'assets/images/desease_image.png',
                      height: 90.h,
                      width: 115.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                );
              },
            )),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bluishWhite,
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      "Add the following information to proceed for the medical checkup ",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400)),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_circle_down_rounded)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bluishWhite,
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      "Add the following information to proceed for the medical checkup ",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400)),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_circle_down_rounded)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.bluishWhite,
                borderRadius: BorderRadius.circular(8.h),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                      "Add the following information to proceed for the medical checkup ",
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.openSans(
                          textStyle: TextStyle(
                              fontSize: 12.sp, fontWeight: FontWeight.w400)),
                    )),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.h),
                      child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Icons.arrow_circle_down_rounded)),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.h),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
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
                      onPressed: () {},
                      child: Text(
                        "Forward Case",
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
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          )),
                      onPressed: () {
                        _buildPrescribeFeild(context);
                      },
                      child: Text(
                        "Prescribe",
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.paddingOf(context).bottom + 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _buildPrescribeFeild(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.6,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0.6, 0.95],
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16.h,
                  right: 16.h,
                  top: 16.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32.h,
                      height: 4.h,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF79747E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Prescribe the patient by adding notes ",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      maxLines: 9,
                      controller: null,
                      onChanged: (value) {
                        setState(() {});
                      },
                      autocorrect: true,
                      decoration: InputDecoration(
                          hintText: "Prescribe the patient",
                          hintFadeDuration: const Duration(milliseconds: 350),
                          hintStyle: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFFD0D2D5))),
                          disabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.h),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.1)),
                              gapPadding: 16.h),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.h),
                              borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.2)),
                              gapPadding: 16.h),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.h),
                              gapPadding: 16.h)),
                    ),
                    // SizedBox(height: 16.h),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Column(
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
                              onPressed: () {},
                              child: Text(
                                "Attach File",
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
                                  backgroundColor: AppColors.primaryBlue,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  )),
                              onPressed: () {
                                _buildPrescribeFeild(context);
                              },
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.paddingOf(context).bottom,
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

void showImageDialog(BuildContext context, String imagePath) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10),
          child: GestureDetector(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );
}

void _buildPatientProfile(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.85,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0.85, 0.95],
        builder: (BuildContext context, ScrollController scrollController) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Padding(
                padding: EdgeInsets.only(
                  left: 16.h,
                  right: 16.h,
                  top: 16.h,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  children: [
                    Container(
                      width: 32.h,
                      height: 4.h,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF79747E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        Text(
                          "Patient’s Profile",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          "Here’s all required information that you need in order to provide medication to the patient.",
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: 'Patient Name:', value: 'Sheikh Akram Ali'),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            infoBox(key: "Gender", value: "Male"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(key: "Blood Group", value: "B+"),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            infoBox(key: "Height", value: "5.8"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(key: "Weight", value: "75kg"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(key: "Age", value: "2024-01-28"),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        infoRow(key: "Father's Name:", value: 'Junnaid Ali'),
                        SizedBox(height: 20.h),
                        infoRow(key: "Grandfather’s Name:", value: 'Abdul Ali'),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: 'Chronic Disease:', value: ' Hypertension'),
                        SizedBox(height: 20.h),
                        infoRow(key: 'Address:', value: 'Street name, city'),
                        SizedBox(height: 20.h),
                        SizedBox(
                          height: MediaQuery.paddingOf(context).bottom,
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      );
    },
  );
}

Widget infoRow({required String key, required String value}) {
  return Container(
    // height: 42.h,
    padding: EdgeInsets.all(12.h),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8.h),
      color: AppColors.bluishWhite,
    ),
    child: Row(children: [
      Text(
        key,
        style: GoogleFonts.openSans(
            textStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600)),
      ),
      Text(
        "  $value",
        style: GoogleFonts.openSans(
            fontSize: 14.sp,
            textStyle: const TextStyle(fontWeight: FontWeight.w400)),
      ),
    ]),
  );
}

Widget infoBox({required String key, required String value}) {
  return Expanded(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.h),
        color: AppColors.bluishWhite,
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              key,
              style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  textStyle: const TextStyle(fontWeight: FontWeight.w600)),
            ),
            SizedBox(
              height: 6.h,
            ),
            Text(
              value,
              style: GoogleFonts.openSans(
                  fontSize: 14.sp,
                  textStyle: const TextStyle(fontWeight: FontWeight.w400)),
            ),
          ],
        ),
      ),
    ),
  );
}
