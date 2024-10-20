// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/doctor_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/home_screen.dart';
import 'package:telemedicine_hub_doctor/features/navigation/bottom_nav_bar.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class ForwardCaseScreen extends StatefulWidget {
  String ticketId;
  ForwardCaseScreen({
    super.key,
    required this.ticketId,
  });

  @override
  State<ForwardCaseScreen> createState() => _ForwardCaseScreenState();
}

class _ForwardCaseScreenState extends State<ForwardCaseScreen> {
  List<DoctorModel> doctorsList = [];
  List<DoctorModel> filteredDoctorList = [];
  String status = '';
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getDoctors();
      },
    );
    super.initState();
  }

  void getDoctors() async {
    try {
      var res = await Provider.of<HomeProvider>(context, listen: false)
          .getAllDoctors();
      if (res.success) {
        if (mounted) {
          setState(() {
            doctorsList = res.data;
            filteredDoctorList = doctorsList;
          });
        }
      } else {}
    } catch (e) {}
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredDoctorList = doctorsList;
      } else {
        filteredDoctorList = doctorsList.where((ticketList) {
          return ticketList.name!.toLowerCase().contains(query.toLowerCase()) ||
              ticketList.email
                  .toString()
                  .toLowerCase()
                  .contains(query.toLowerCase());
        }).toList();
      }
    });
  }

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
            "Forward Case",
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          ),
          centerTitle: false,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 20.h),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  onChanged: (value) {
                    setState(() {
                      _onSearchChanged(value);
                    });
                  },
                  onTapOutside: (_) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.w),
                    hintText: "Search for doctors",
                    prefixIcon: const Icon(Iconsax.search_normal),
                    hintStyle: TextStyle(
                      color: AppColors.captionColor,
                      fontWeight: FontWeight.bold,
                    ),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.captionColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.captionColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.captionColor),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.h),
                  child: Provider.of<HomeProvider>(context).isLoading
                      ? TicketShimmer()
                      : filteredDoctorList.isEmpty
                          ? noDataView(context)
                          : ListView.builder(
                              padding: EdgeInsets.zero,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredDoctorList.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                var data = filteredDoctorList[index];
                                return Padding(
                                  padding: EdgeInsets.only(bottom: 10.h),
                                  child: DoctorCard(
                                    doctor: data,
                                    ticketId: widget.ticketId,
                                  ),
                                );
                              },
                            ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DoctorCard extends StatefulWidget {
  DoctorModel doctor;
  String ticketId;
  DoctorCard({
    super.key,
    required this.doctor,
    required this.ticketId,
  });

  @override
  State<DoctorCard> createState() => _DoctorCardState();
}

class _DoctorCardState extends State<DoctorCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _buildForwardCaseView(
            context: context,
            ticketId: widget.ticketId,
            doctorId: widget.doctor.id.toString());
      },
      child: Container(
        height: 85.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.h),
        ),
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: Row(
            children: [
              Container(
                height: 60.h,
                width: 60.w,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: Image.network(
                  widget.doctor.imageUrl ?? "",
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(
                width: 12.w,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    widget.doctor.name.toString(),
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 16.sp, fontWeight: FontWeight.w600)),
                  ),
                  Text(
                    widget.doctor.specialization!.name.toString(),
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w400)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

void _buildForwardCaseView(
    {required BuildContext context,
    required String ticketId,
    required String doctorId}) {
  var homeProvider = Provider.of<HomeProvider>(context, listen: false);
  TextEditingController controller = TextEditingController();
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
        initialChildSize:
            0.93, // Adjust this value to leave space for the app bar
        minChildSize: 0.93,
        maxChildSize: 0.93,
        expand: false,

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
                        "Add Notes for the doctor ",
                        style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                                fontSize: 12.sp, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      maxLines: 9,
                      controller: controller,
                      autocorrect: true,
                      decoration: InputDecoration(
                          hintText:
                              "Anything specific you would like to share with the doctor",
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
                              onPressed: () async {
                                if (controller.text.isNotEmpty) {
                                  var res = await homeProvider.forwardTicket(
                                      newDoctorId: doctorId,
                                      note: controller.text,
                                      id: ticketId);

                                  if (res.success) {
                                    Fluttertoast.showToast(
                                        msg: "Case Forwarded Successfully!");
                                    Navigator.pushReplacement(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (context) =>
                                                const BottomNavBar()));
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Failed to Forwarded Case!");
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Please write a note!");
                                }
                              },
                              child: Text(
                                "Forward Case",
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
