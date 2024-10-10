// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/forward_case.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class TicketDetailsScreen extends StatefulWidget {
  TicketModel ticket;
  TicketDetailsScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
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

  @override
  Widget build(BuildContext context) {
    String statusText = capitalizeFirstLetter(widget.ticket.status.toString());
    DateTime dateTime = DateTime.parse(widget.ticket.scheduleDate.toString());
    String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

    String formattedTime = DateFormat('h:mm a').format(dateTime);
    String timeUntilAppointment = getTimeUntilAppointment(dateTime);

    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            widget.ticket.name.toString(),
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                                            color: getStatusColor(widget
                                                .ticket.status
                                                .toString()),
                                            borderRadius:
                                                BorderRadius.circular(4),
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
                                        GestureDetector(
                                          onTap: () {
                                            _buildPatientProfile(
                                                context: context,
                                                patient: widget.ticket.patient,
                                                disease: widget
                                                    .ticket.disease!.name
                                                    .toString());
                                          },
                                          child: Text(
                                            "Patient Profile",
                                            style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    color:
                                                        AppColors.primaryBlue,
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline)),
                                          ),
                                        )
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
                                    SizedBox(height: 12.h),
                                    Row(
                                      children: [
                                        Text("ETA - $timeUntilAppointment  • ",
                                            style: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w400))),
                                        Text(
                                          widget.ticket.disease!.name
                                              .toString(),
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                                  fontSize: 12.sp,
                                                  color:
                                                      const Color(0xFF015988),
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
                              color: getStatusColor(
                                  widget.ticket.status.toString()),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                SizedBox(
                  height: 120,
                  child: widget.ticket.prescriptions != null &&
                          widget.ticket.prescriptions!.isNotEmpty
                      ? ListView.builder(
                          itemCount: widget.ticket.prescriptions!.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: GestureDetector(
                                onTap: () {
                                  showImageDialog(context,
                                      widget.ticket.prescriptions![index]);
                                },
                                child: Image.network(
                                  widget.ticket.prescriptions![index],
                                  height: 90,
                                  width: 115,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(child: ImagesShimmer());
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error);
                                  },
                                ),
                              ),
                            );
                          },
                        )
                      : const Center(
                          child: Text('No prescription images available')),
                ),
                SizedBox(height: 16.h),
                Column(
                  children: List.generate(
                    widget.ticket.questionsAndAnswers!.length,
                    (index) {
                      var data = widget.ticket.questionsAndAnswers![index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: QuestionAnswerWidget(questionAnswer: data),
                      );
                    },
                  ),
                ),
                widget.ticket.status.toString() == "completed" ||
                        widget.ticket.status.toString() == "forwarded"
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 10.h),
                        child: FractionallySizedBox(
                          widthFactor: 1,
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                )),
                            onPressed: () {
                              Fluttertoast.showToast(
                                  msg: "Ticket Completed or Forwaded ");
                            },
                            child: Text(
                              "Ticket Closed",
                              style: TextStyle(
                                  fontSize: 16.sp, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Column(
                          children: [
                            SizedBox(height: 16.h),
                            FractionallySizedBox(
                              widthFactor: 1,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    backgroundColor: const Color(0xFFEDEDF4),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) => ForwardCaseScreen(
                                            ticketId:
                                                widget.ticket.id.toString()),
                                      ));
                                },
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
                                    padding:
                                        EdgeInsets.symmetric(vertical: 12.h),
                                    backgroundColor: AppColors.primaryBlue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    )),
                                onPressed: () {
                                  _buildPrescribeFeild(
                                      context: context,
                                      id: widget.ticket.id.toString());
                                },
                                child: Text(
                                  "Prescribe",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                SizedBox(height: MediaQuery.paddingOf(context).bottom + 10),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class QuestionAnswerWidget extends StatefulWidget {
  final QuestionsAndAnswers questionAnswer;

  const QuestionAnswerWidget({super.key, required this.questionAnswer});

  @override
  _QuestionAnswerWidgetState createState() => _QuestionAnswerWidgetState();
}

class _QuestionAnswerWidgetState extends State<QuestionAnswerWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      _isExpanded ? _controller.forward() : _controller.reverse();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bluishWhite,
        borderRadius: BorderRadius.circular(8.h),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    widget.questionAnswer.question ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _toggleExpand,
                  icon: Icon(
                    _isExpanded
                        ? Icons.arrow_circle_up_rounded
                        : Icons.arrow_circle_down_rounded,
                  ),
                ),
              ],
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              child: Container(
                height: 44.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 12.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.h)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.questionAnswer.answer ?? '',
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void _buildPrescribeFeild({required BuildContext context, required String id}) {
  var homeProvider = Provider.of<HomeProvider>(context, listen: false);
  TextEditingController controller = TextEditingController();
  XFile? selectedImage;
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
                      controller: controller,
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
                          selectedImage == null
                              ? FractionallySizedBox(
                                  widthFactor: 1,
                                  child: FilledButton(
                                    style: FilledButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 12.h),
                                        backgroundColor:
                                            const Color(0xFFEDEDF4),
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        )),
                                    onPressed: () async {
                                      final XFile? pickedImage =
                                          await ImagePickerHelper.pickImage(
                                              context);
                                      if (pickedImage != null) {
                                        setState(() {
                                          selectedImage = pickedImage;
                                        });
                                      }
                                    },
                                    child: Text(
                                      "Attach File",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                )
                              : Text(
                                  selectedImage!.name.toString(),
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
                              onPressed: () async {
                                late CustomResponse res;

                                if (selectedImage != null &&
                                    selectedImage!.path.isNotEmpty) {
                                  res = await homeProvider.uploadPrescriptions(
                                      file: File(selectedImage!.path),
                                      context: context,
                                      ticketID: id);

                                  if (res.success) {
                                    var r = await homeProvider.completedTicket(
                                        id: id, note: controller.text);
                                    if (r.success) {
                                      Fluttertoast.showToast(msg: r.msg);
                                      Navigator.of(context).pop();
                                    } else {
                                      Fluttertoast.showToast(msg: r.msg);
                                    }
                                  } else {
                                    Fluttertoast.showToast(
                                        msg: "Profile picture upload failed!");
                                  }
                                } else {
                                  var r = await homeProvider.completedTicket(
                                      id: id, note: controller.text);
                                  if (r.success) {
                                    Fluttertoast.showToast(msg: r.msg);
                                    Navigator.of(context).pop();
                                  } else {
                                    Fluttertoast.showToast(msg: r.msg);
                                  }
                                }
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
                  child: Image.network(
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

void _buildPatientProfile(
    {required BuildContext context,
    required Patient? patient,
    required String disease}) {
  String formattedDate = '';

  // Ensure patient and patient.age are not null before parsing
  if (patient != null && patient.age != null) {
    try {
      // Assuming patient.age is in a proper date format. Adjust as necessary.
      formattedDate = DateTime.parse(patient.age.toString())
          .toIso8601String()
          .substring(0, 10);
    } catch (e) {
      print('Error parsing date: $e');
      formattedDate = 'Invalid date'; // Default value or handle it accordingly
    }
  } else {
    formattedDate = 'N/A'; // Handle the case when patient or age is null
  }

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
        initialChildSize: 0.90,
        minChildSize: 0.90,
        maxChildSize: 0.95,
        expand: false,
        snap: true,
        snapSizes: const [0.90, 0.95],
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
                            key: 'Patient Name:',
                            value: patient!.name.toString()),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            infoBox(
                                key: "Gender",
                                value: patient.gender.toString()),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(
                                key: "Blood Group",
                                value: patient.bloodGroup.toString()),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            infoBox(
                                key: "Height",
                                value: patient.height.toString()),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(
                                key: "Weight",
                                value: "${patient.weight.toString()}kg"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(key: "Age", value: formattedDate),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: "Father's Name:",
                            value: patient.fatherName.toString()),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: "Grandfather’s Name:",
                            value: patient.grandFatherName.toString()),
                        SizedBox(height: 20.h),
                        infoRow(key: 'Chronic Disease:', value: disease),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: 'Address:',
                            value:
                                "Mollit mollit id quis adipisicing minim amet tempor enim. Cillum nisi enim ea nisi aute. Sunt veniam quis eu fugiat ipsum."),
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
      SizedBox(
        width: 4.w,
      ),
      Expanded(
        child: Text(
          "  $value",
          maxLines: 2,
          textAlign: TextAlign.start,
          overflow: TextOverflow.ellipsis,
          style: GoogleFonts.openSans(
              fontSize: 14.sp,
              textStyle: const TextStyle(fontWeight: FontWeight.w400)),
        ),
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

class ImagePickerHelper {
  static Future<XFile?> pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        print('Selected image: ${pickedFile.name} at ${pickedFile.path}');
        return pickedFile;
      } else {
        print('No image selected');
        return null;
      }
    } catch (e) {
      print('Error picking image: $e');
      // Show an error dialog
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text('Failed to pick image. Please try again.'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }
  }
}
