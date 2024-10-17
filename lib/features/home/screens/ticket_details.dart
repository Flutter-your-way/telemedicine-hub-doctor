// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
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
import 'package:telemedicine_hub_doctor/common/models/comment_model.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/forward_case.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/pdf_viewer_screen.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class TicketDetailsScreen extends StatefulWidget {
  String? id;
  TicketDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<TicketDetailsScreen> createState() => _TicketDetailsScreenState();
}

class _TicketDetailsScreenState extends State<TicketDetailsScreen> {
  TicketModel? ticket;
  bool isLoading = true;
  String? errorMessage;
  String? currentUserId = '';

  List<CommentModel> commentList = [];

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // currentUserId = await LocalDataManager.getToken();
        getComment();
      },
    );
  }

  Future<void> getComment() async {
    try {
      var r = await Provider.of<HomeProvider>(context, listen: false)
          .getComments(ticketid: widget.id.toString());
      if (r.success) {
        setState(() {
          commentList = r.data;
        });
      } else {
        commentList = [];
        Fluttertoast.showToast(msg: "No Comment till now !");
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _fetchTicketDetails() async {
    if (widget.id == null) {
      setState(() {
        isLoading = false;
        errorMessage = "Ticket ID is missing";
      });
      return;
    }

    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    try {
      CustomResponse response =
          await homeProvider.getTicketById(ticketId: widget.id!);
      if (response.success) {
        setState(() {
          ticket = response.data;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = response.msg ?? "Failed to fetch ticket details";
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = "An error occurred: $e";
      });
    }
  }

  Future<void> _handleRefresh() async {
    await _fetchTicketDetails();
  }

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
    print('Questions and Answers: ${ticket?.questionsAndAnswers}');
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            ticket?.name.toString() ?? "",
            style: GoogleFonts.openSans(
                textStyle:
                    TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
          ),
          centerTitle: false,
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : errorMessage != null
                  ? Center(child: Text(errorMessage!))
                  : ticket == null
                      ? const Center(child: Text("No ticket data available"))
                      : SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
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
                                          width:
                                              MediaQuery.sizeOf(context).width -
                                                  56,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFAFAFC),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            border: Border.all(
                                              color: const Color(0xFFF4F4F6),
                                              width: 2,
                                              strokeAlign:
                                                  BorderSide.strokeAlignInside,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(.15),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 16.w,
                                                    vertical: 20.h),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(6),
                                                          decoration:
                                                              BoxDecoration(
                                                            color: getStatusColor(
                                                                ticket!.status
                                                                    .toString()),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4),
                                                          ),
                                                          child: Text(
                                                            capitalizeFirstLetter(
                                                                ticket!.status
                                                                    .toString()),
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .greenishWhite,
                                                              fontSize: 12.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            _buildPatientProfile(
                                                                context:
                                                                    context,
                                                                patient: ticket!
                                                                    .patient,
                                                                disease: ticket!
                                                                    .disease!
                                                                    .name
                                                                    .toString());
                                                          },
                                                          child: Text(
                                                            "Patient Profile",
                                                            style: GoogleFonts.openSans(
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    color: AppColors
                                                                        .primaryBlue,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    decoration:
                                                                        TextDecoration
                                                                            .underline)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 8.h),
                                                    Text(
                                                      ticket!.name.toString(),
                                                      style: TextStyle(
                                                        fontSize: 20.sp,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    SizedBox(height: 12.h),
                                                    Row(
                                                      children: [
                                                        Text(
                                                            "ETA - ${getTimeUntilAppointment(ticket!.scheduleDate!)}  • ",
                                                            style: GoogleFonts.openSans(
                                                                textStyle: TextStyle(
                                                                    fontSize:
                                                                        14.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400))),
                                                        Text(
                                                          ticket!.disease!.name
                                                              .toString(),
                                                          style: GoogleFonts.openSans(
                                                              textStyle: TextStyle(
                                                                  fontSize:
                                                                      12.sp,
                                                                  color: const Color(
                                                                      0xFF015988),
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
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
                                                borderRadius:
                                                    const BorderRadius.vertical(
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
                                                      DateFormat('d MMM yyyy')
                                                          .format(ticket!
                                                              .scheduleDate!),
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
                                                      DateFormat('h:mm a')
                                                          .format(ticket!
                                                              .scheduleDate!),
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
                                                  ticket!.status.toString()),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                ticket!.prescriptions != null &&
                                        ticket!.prescriptions!.isNotEmpty
                                    ? SizedBox(
                                        height: 120,
                                        child: ticket!.prescriptions != null &&
                                                ticket!
                                                    .prescriptions!.isNotEmpty
                                            ? ListView.builder(
                                                itemCount: ticket!
                                                    .prescriptions!.length,
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        showImageDialog(
                                                            context,
                                                            ticket!.prescriptions![
                                                                index]);
                                                      },
                                                      child: Image.network(
                                                        ticket!.prescriptions![
                                                            index],
                                                        height: 90,
                                                        width: 115,
                                                        fit: BoxFit.cover,
                                                        loadingBuilder:
                                                            (BuildContext
                                                                    context,
                                                                Widget child,
                                                                ImageChunkEvent?
                                                                    loadingProgress) {
                                                          if (loadingProgress ==
                                                              null)
                                                            return child;
                                                          return const Center(
                                                              child:
                                                                  ImagesShimmer());
                                                        },
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(
                                                              Icons.error);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              )
                                            : const SizedBox.shrink(),
                                      )
                                    : const SizedBox.shrink(),
                                SizedBox(height: 16.h),
                                if (ticket?.questionsAndAnswers != null &&
                                    ticket!.questionsAndAnswers!.isNotEmpty)
                                  Column(
                                    children:
                                        ticket!.questionsAndAnswers!.map((qa) {
                                      return Padding(
                                        padding: EdgeInsets.only(bottom: 8.h),
                                        child: QuestionAnswerWidget(
                                            questionAnswer: qa),
                                      );
                                    }).toList(),
                                  )
                                else
                                  Text(
                                    "No questions and answers available",
                                    style: TextStyle(
                                        fontSize: 14.sp, color: Colors.grey),
                                  ),
                                Consumer<HomeProvider>(
                                    builder: (context, provider, child) {
                                  if (provider.isLoading) {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                  return ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: commentList.length,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return CommentBubble(
                                          comment: commentList[index],
                                          isCurrentUser:
                                              commentList[index].user ==
                                                  currentUserId,
                                        );
                                      });
                                }),
                                ticket!.status.toString() == "completed" ||
                                        ticket!.status.toString() == "forwarded"
                                    ? Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 10.h),
                                            child: FractionallySizedBox(
                                              widthFactor: 1,
                                              child: FilledButton(
                                                style: FilledButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h),
                                                    backgroundColor:
                                                        const Color(0xFFEDEDF4),
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    )),
                                                onPressed: () {
                                                  if (ticket?.doctorPrescriptionAndNotes
                                                              ?.prescriptionUrls !=
                                                          null &&
                                                      ticket!
                                                          .doctorPrescriptionAndNotes!
                                                          .prescriptionUrls!
                                                          .isNotEmpty) {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PDFViewerPage(
                                                          url: ticket!
                                                              .doctorPrescriptionAndNotes!
                                                              .prescriptionUrls![0],
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "No prescription available +- ");
                                                  }
                                                },
                                                child: Text(
                                                  "View prescription",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.w,
                                                vertical: 10.h),
                                            child: FractionallySizedBox(
                                              widthFactor: 1,
                                              child: FilledButton(
                                                style: FilledButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h),
                                                    backgroundColor:
                                                        Colors.green,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    )),
                                                onPressed: () {
                                                  Fluttertoast.showToast(
                                                      msg:
                                                          "Ticket Completed or Forwaded ");
                                                },
                                                child: Text(
                                                  "Ticket Closed",
                                                  style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    : Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w),
                                        child: Column(
                                          children: [
                                            SizedBox(height: 16.h),
                                            FractionallySizedBox(
                                              widthFactor: 1,
                                              child: FilledButton(
                                                style: FilledButton.styleFrom(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h),
                                                    backgroundColor:
                                                        const Color(0xFFEDEDF4),
                                                    foregroundColor:
                                                        Colors.black,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    )),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      CupertinoPageRoute(
                                                        builder: (context) =>
                                                            ForwardCaseScreen(
                                                                ticketId: ticket!
                                                                    .id
                                                                    .toString()),
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
                                                        EdgeInsets.symmetric(
                                                            vertical: 12.h),
                                                    backgroundColor:
                                                        AppColors.primaryBlue,
                                                    foregroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    )),
                                                onPressed: () {
                                                  _buildPrescribeFeild(
                                                    context: context,
                                                    id: ticket!.id.toString(),
                                                    refreshTicketDetails:
                                                        () async {
                                                      await _fetchTicketDetails();
                                                      setState(
                                                          () {}); // This will rebuild the widget with the new data
                                                    },
                                                  );
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
                                SizedBox(
                                    height:
                                        MediaQuery.paddingOf(context).bottom +
                                            10),
                              ],
                            ),
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

void _buildPrescribeFeild({
  required BuildContext context,
  required String id,
  required Function refreshTicketDetails,
}) {
  var homeProvider = Provider.of<HomeProvider>(context, listen: false);
  TextEditingController controller = TextEditingController();

  PlatformFile? selectedFile;
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
        snap: true,

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
                          selectedFile == null
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
                                      final result =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: [
                                          'pdf',
                                          'jpg',
                                          'jpeg',
                                          'png'
                                        ],
                                      );

                                      if (result != null) {
                                        setState(() {
                                          selectedFile = result.files.first;
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
                                  selectedFile!.name.toString(),
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
                                // Show confirmation dialog
                                bool? confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Confirm Submission'),
                                      content: const Text(
                                          'Are you sure you want to submit this prescription?'),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Cancel'),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: const Text('Submit'),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );

                                // If user confirms, proceed with submission
                                if (confirm == true) {
                                  File? fileToUpload;
                                  String? directoryType;

                                  if (selectedFile != null &&
                                      selectedFile!.path != null) {
                                    fileToUpload = File(selectedFile!.path!);
                                    String fileType = selectedFile!.extension
                                            ?.toLowerCase() ??
                                        '';
                                    directoryType = ['jpg', 'jpeg', 'png']
                                            .contains(fileType)
                                        ? 'image'
                                        : 'pdf';
                                  }

                                  var r = await homeProvider.MarkAsComplete(
                                    id: id,
                                    note: controller.text,
                                    file: fileToUpload,
                                    directoryType: directoryType,
                                    context: context,
                                  );

                                  if (r.success) {
                                    Fluttertoast.showToast(msg: r.msg);
                                    Navigator.of(context).pop();
                                    await refreshTicketDetails();
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

class CommentBubble extends StatelessWidget {
  final CommentModel comment;
  final bool isCurrentUser;

  const CommentBubble({
    super.key,
    required this.comment,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        mainAxisAlignment:
            isCurrentUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isCurrentUser) _buildAvatar(),
          SizedBox(width: 8.w),
          Flexible(
            child: Column(
              crossAxisAlignment: isCurrentUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width *
                        0.6, // Maximum width constraint
                  ),
                  padding: EdgeInsets.all(12.h),
                  decoration: BoxDecoration(
                    color:
                        isCurrentUser ? const Color(0xFFE8F3FF) : Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        comment.message ?? "",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 14.sp,
                        ),
                      ),
                      if (comment.fileUrl != null &&
                          comment.fileUrl!.isNotEmpty)
                        _buildAttachment(context, comment.fileUrl.toString()),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          if (isCurrentUser) _buildAvatar(),
        ],
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 16.r,
      backgroundColor:
          isCurrentUser ? const Color(0xFF4CAF50) : AppColors.primaryBlue,
      child: Icon(
        isCurrentUser ? Icons.person : Icons.medical_services,
        color: Colors.white,
        size: 20.r,
      ),
    );
  }

  Widget _buildAttachment(BuildContext context, String attachment) {
    return Container(
      width: MediaQuery.sizeOf(context).width * 0.5,
      height: 45.h,
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon(Icons.insert_drive_file, color: Colors.blue, size: 20.r),
          Container(
            height: 32.h,
            width: 32.w,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0xFF0065FF)),
            child: const Center(
              child: Icon(
                Icons.link_outlined,
                color: Colors.white,
              ),
            ),
          ),

          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    attachment,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 14.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),
                Text(
                  "PDF",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400)),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 4.w,
          ),
          IconButton(
              onPressed: () async {
                // var res =
                //     await Provider.of<HomeProvider>(context, listen: false)
                //         .downloadFile(attachment);
                // if (res.success) {
                //   Fluttertoast.showToast(msg: res.msg);
                // } else {
                //   Fluttertoast.showToast(msg: res.msg);
                // }
              },
              icon: const Icon(Iconsax.document_download))
        ],
      ),
    );
  }
}
