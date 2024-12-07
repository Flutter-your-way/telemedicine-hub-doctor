// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously, library_private_types_in_public_api, curly_braces_in_flow_control_structures, empty_catches, must_be_immutable
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as path;

import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/models/comment_model.dart';
import 'package:telemedicine_hub_doctor/common/models/custom_response.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/forward_case.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/medical_history_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/meeting_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/pdf_viewer_screen.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class PsychologyTicketDetailsScreen extends StatefulWidget {
  String? id;
  PsychologyTicketDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<PsychologyTicketDetailsScreen> createState() =>
      _PsychologyTicketDetailsScreenState();
}

class _PsychologyTicketDetailsScreenState
    extends State<PsychologyTicketDetailsScreen> {
  TicketModel? ticket;
  bool isLoading = true;
  String? errorMessage;
  String? currentUserId = '';
  final TextEditingController _controller = TextEditingController();

  List<CommentModel> commentList = [];

  @override
  void initState() {
    super.initState();
    _fetchTicketDetails();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        // currentUserId = await LocalDataManager.getToken();
        currentUserId = Provider.of<AuthProvider>(context, listen: false)
            .usermodel!
            .id
            .toString();
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
    } catch (e) {}
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
          errorMessage = response.msg;
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
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            ticket?.name != null
                ? "${AppLocalizations.of(context)!.ticketNo}.${ticket!.name}"
                : "${AppLocalizations.of(context)!.loading}...",
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
                      : Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.h),
                          child: Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(children: [
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
                                              width: MediaQuery.sizeOf(context)
                                                      .width -
                                                  56,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFFAFAFC),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFF4F4F6),
                                                  width: 2,
                                                  strokeAlign: BorderSide
                                                      .strokeAlignInside,
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
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 16.w,
                                                            vertical: 20.h),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
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
                                                                    ticket!
                                                                        .status
                                                                        .toString()),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            4),
                                                              ),
                                                              child: Text(
                                                                capitalizeFirstLetter(
                                                                    ticket!
                                                                        .status
                                                                        .toString()),
                                                                style:
                                                                    TextStyle(
                                                                  color: AppColors
                                                                      .greenishWhite,
                                                                  fontSize:
                                                                      12.sp,
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
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .patientProfile,
                                                                style: GoogleFonts.openSans(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        color: AppColors
                                                                            .primaryBlue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        decoration:
                                                                            TextDecoration.underline)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 8.h),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              ticket!.name
                                                                  .toString(),
                                                              style: TextStyle(
                                                                fontSize: 20.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                            ),
                                                            const Spacer(),
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) =>
                                                                          MedicalHistoryScreen(
                                                                              userId: ticket?.patient?.id.toString() ?? " "),
                                                                    ));
                                                              },
                                                              child: Text(
                                                                "Patient History",
                                                                style: GoogleFonts.openSans(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        color: AppColors
                                                                            .primaryBlue,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                        decoration:
                                                                            TextDecoration.underline)),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                        SizedBox(height: 12.h),
                                                        Row(
                                                          children: [
                                                            Text(
                                                                "${getTimeUntilAppointment(ticket!.scheduleDate!)}  • ",
                                                                style: GoogleFonts.openSans(
                                                                    textStyle: TextStyle(
                                                                        fontSize: 14
                                                                            .sp,
                                                                        fontWeight:
                                                                            FontWeight.w400))),
                                                            Text(
                                                              ticket!
                                                                  .disease!.name
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
                                                    color:
                                                        AppColors.bluishWhite,
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                      bottom:
                                                          Radius.circular(12),
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
                                                          DateFormat(
                                                                  'd MMM yyyy')
                                                              .format(ticket!
                                                                  .scheduleDate!),
                                                          style: TextStyle(
                                                            color:
                                                                AppColors.grey,
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
                                                            color:
                                                                AppColors.grey,
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
                                                  color: getStatusColor(ticket!
                                                      .status
                                                      .toString()),
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
                                            child: ticket!.prescriptions !=
                                                        null &&
                                                    ticket!.prescriptions!
                                                        .isNotEmpty
                                                ? ListView.builder(
                                                    itemCount: ticket!
                                                        .prescriptions!.length,
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
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
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null)
                                                                return child;
                                                              return const Center(
                                                                  child:
                                                                      ImagesShimmer());
                                                            },
                                                            errorBuilder:
                                                                (context, error,
                                                                    stackTrace) {
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
                                    Row(
                                      children: [
                                        Icon(
                                          Iconsax.menu_board,
                                          color: AppColors.primaryBlue,
                                        ),
                                        SizedBox(
                                          width: 6.h,
                                        ),
                                        Text(
                                          AppLocalizations.of(context)!.notes,
                                          style: GoogleFonts.openSans(
                                              textStyle: TextStyle(
                                            fontSize: 18.h,
                                            fontWeight: FontWeight.bold,
                                          )),
                                        ),
                                        const Spacer(),
                                        ticket!.status.toString() != "completed"
                                            ? GestureDetector(
                                                onTap: () {
                                                  _buildPrescribeFeild(
                                                    context: context,
                                                    id: ticket!.id.toString(),
                                                    refreshTicketDetails:
                                                        () async {
                                                      await _fetchTicketDetails();
                                                      setState(
                                                          () {}); // This will rebuild the widget with the new data
                                                    },
                                                    meetTime:
                                                        ticket!.scheduleDate,
                                                  );
                                                },
                                                child: Container(
                                                  padding: EdgeInsets.all(8.h),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12.h),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Iconsax.add_square,
                                                        size: 24.h,
                                                        color: AppColors
                                                            .primaryBlue,
                                                      ),
                                                      SizedBox(
                                                        width: 6.h,
                                                      ),
                                                      Text(
                                                        AppLocalizations.of(
                                                                context)!
                                                            .addNote,
                                                        style: GoogleFonts
                                                            .openSans(
                                                                textStyle:
                                                                    TextStyle(
                                                          color: AppColors
                                                              .primaryBlue,
                                                          fontSize: 18.h,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        )),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                            : const SizedBox.shrink()
                                      ],
                                    ),
                                    SizedBox(
                                      height: 50.h,
                                    ),
                                    if (ticket?.questionsAndAnswers != null &&
                                        ticket!.questionsAndAnswers!.isNotEmpty)
                                      Column(
                                        children: ticket!.questionsAndAnswers!
                                            .map((qa) {
                                          return Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 8.h),
                                            child: QuestionAnswerWidget(
                                                questionAnswer: qa),
                                          );
                                        }).toList(),
                                      )
                                    else
                                      Text(
                                        AppLocalizations.of(context)!
                                            .noQuestionsAndAnswersAvailable,
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.grey),
                                      ),
                                    // if (commentList.isNotEmpty)
                                    //   Consumer<HomeProvider>(
                                    //     builder: (context, provider, child) {
                                    //       if (provider.isLoading) {
                                    //         return const Center(
                                    //             child: CircularProgressIndicator());
                                    //       }
                                    //       return ListView.builder(
                                    //         physics:
                                    //             const NeverScrollableScrollPhysics(),
                                    //         itemCount: commentList.length,
                                    //         shrinkWrap: true,
                                    //         itemBuilder: (context, index) {
                                    //           return CommentBubble(
                                    //             comment: commentList[index],
                                    //             isCurrentUser:
                                    //                 commentList[index].user ==
                                    //                     currentUserId,
                                    //           );
                                    //         },
                                    //       );
                                    //     },
                                    //   ),

                                    SizedBox(
                                      height: 20.h,
                                    ),
                                    if (commentList.isNotEmpty)
                                      Consumer<HomeProvider>(
                                          builder: (context, provider, child) {
                                        if (provider.commentLoading) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
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
                                  ]),
                                ),
                              ),
                              ticket!.status.toString() == "completed"
                                  ? Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 10.h),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: FilledButton.icon(
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
                                                    ),
                                                  ),
                                                  icon: const Icon(
                                                      Iconsax.document_1),
                                                  // onPressed: () {
                                                  //   if (ticket?.doctorPrescriptionAndNotes
                                                  //               ?.prescriptionUrls !=
                                                  //           null &&
                                                  //       ticket!
                                                  //           .doctorPrescriptionAndNotes!
                                                  //           .prescriptionUrls!
                                                  //           .isNotEmpty) {
                                                  //     final String fileUrl = ticket!
                                                  //         .doctorPrescriptionAndNotes!
                                                  //         .prescriptionUrls![0];
                                                  //     print(fileUrl);
                                                  //     final String
                                                  //         fileExtension = path
                                                  //             .extension(
                                                  //                 fileUrl)
                                                  //             .toLowerCase();
                                                  //     print(fileExtension);
                                                  //     if (fileExtension ==
                                                  //         '.pdf') {
                                                  //       Navigator.of(context)
                                                  //           .push(
                                                  //         MaterialPageRoute(
                                                  //           builder: (context) =>
                                                  //               PDFViewerPage(
                                                  //             url: fileUrl,
                                                  //           ),
                                                  //         ),
                                                  //       );
                                                  //     } else {
                                                  //       showImageDialog(
                                                  //           context, fileUrl);
                                                  //     }
                                                  //   } else {
                                                  //     Fluttertoast.showToast(
                                                  //         msg:
                                                  //             "No prescription uploaded");
                                                  //   }
                                                  // },
                                                  onPressed: () {
                                                    // Check if prescription URLs exist and are not empty
                                                    if (ticket?.doctorPrescriptionAndNotes
                                                                ?.prescriptionUrls !=
                                                            null &&
                                                        ticket!
                                                            .doctorPrescriptionAndNotes!
                                                            .prescriptionUrls!
                                                            .isNotEmpty) {
                                                      final String fileUrl = ticket!
                                                          .doctorPrescriptionAndNotes!
                                                          .prescriptionUrls![0];

                                                      // Extract the extension without query parameters
                                                      final Uri fileUri =
                                                          Uri.parse(fileUrl);
                                                      final String
                                                          fileExtension = path
                                                              .extension(
                                                                  fileUri.path)
                                                              .toLowerCase();

                                                      // Debugging logs (optional)
                                                      print(
                                                          "File URL: $fileUrl");
                                                      print(
                                                          "Cleaned File Extension: $fileExtension");

                                                      // Handle file types based on extension
                                                      if (fileExtension ==
                                                          '.pdf') {
                                                        // Open PDF Viewer
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                PDFViewerPage(
                                                              url: fileUrl,
                                                            ),
                                                          ),
                                                        );
                                                      } else if (fileExtension ==
                                                              '.jpg' ||
                                                          fileExtension ==
                                                              '.jpeg' ||
                                                          fileExtension ==
                                                              '.png') {
                                                        // Show Image Viewer
                                                        showImageDialog(
                                                            context, fileUrl);
                                                      } else {
                                                        // Show error for unsupported file types
                                                        Fluttertoast.showToast(
                                                            msg:
                                                                "Unsupported file type");
                                                      }
                                                    } else {
                                                      // Show toast if no prescription is uploaded
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "No prescription uploaded");
                                                    }
                                                  },
                                                  label: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .prescription,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 12.w),
                                              Expanded(
                                                child: FilledButton.icon(
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
                                                    ),
                                                  ),
                                                  icon: const Icon(
                                                      Iconsax.note_1),
                                                  onPressed: () {
                                                    if (ticket?.doctorPrescriptionAndNotes
                                                                ?.note !=
                                                            null &&
                                                        ticket!
                                                            .doctorPrescriptionAndNotes!
                                                            .note!
                                                            .isNotEmpty) {
                                                      final String notesString =
                                                          ticket!.doctorPrescriptionAndNotes!
                                                                  .note ??
                                                              "No notes available";
                                                      _showNotesBottomSheet(
                                                        context: context,
                                                        notesString:
                                                            notesString,
                                                      );
                                                    }
                                                  },
                                                  label: Text(
                                                    AppLocalizations.of(
                                                            context)!
                                                        .notes,
                                                    style: TextStyle(
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 12.w, vertical: 10.h),
                                          child: TextFormField(
                                            controller: _controller,
                                            decoration: InputDecoration(
                                              fillColor: Colors.white,
                                              hintText:
                                                  AppLocalizations.of(context)!
                                                      .addComment,
                                              hintStyle: GoogleFonts.openSans(
                                                textStyle: TextStyle(
                                                  color:
                                                      const Color(0xFFD0D2D5),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              suffixIcon: IconButton(
                                                onPressed: () async {
                                                  if (_controller.text
                                                      .trim()
                                                      .isNotEmpty) {
                                                    var r = await Provider.of<
                                                                HomeProvider>(
                                                            context,
                                                            listen: false)
                                                        .createComment(
                                                      doctorId: ticket!
                                                          .doctor!.id
                                                          .toString(),
                                                      patientId: ticket!
                                                          .patient!.id
                                                          .toString(),
                                                      ticketId:
                                                          ticket!.id.toString(),
                                                      message: _controller.text
                                                          .trim(),
                                                    );

                                                    if (r.success) {
                                                      Fluttertoast.showToast(
                                                          msg: r.msg);

                                                      CommentModel cm =
                                                          CommentModel(
                                                              message:
                                                                  _controller
                                                                      .text,
                                                              ticket: ticket!.id
                                                                  .toString(),
                                                              user: ticket!
                                                                  .doctor!.id
                                                                  .toString());
                                                      commentList.add(cm);
                                                      setState(() {
                                                        _controller.text = "";
                                                      });
                                                    } else {
                                                      Fluttertoast.showToast(
                                                          msg: r.msg);
                                                    }
                                                  } else if (_controller.text
                                                          .trim()
                                                          .length <
                                                      2) {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please write your comment!");
                                                  } else {
                                                    Fluttertoast.showToast(
                                                        msg:
                                                            "Please write your comment!");
                                                  }
                                                },
                                                icon:
                                                    const Icon(Iconsax.send_2),
                                              ),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(8.h)),
                                                borderSide: BorderSide(
                                                  color:
                                                      const Color(0xFFD0D2D5),
                                                  width: 1.h,
                                                  strokeAlign: 1.h,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )

                                  // FractionallySizedBox(
                                  //   widthFactor: 1,
                                  //   child: FilledButton(
                                  //     style: FilledButton.styleFrom(
                                  //         padding:
                                  //             EdgeInsets.symmetric(
                                  //                 vertical: 12.h),
                                  //         backgroundColor:
                                  //             Colors.green,
                                  //         foregroundColor:
                                  //             Colors.white,
                                  //         shape:
                                  //             RoundedRectangleBorder(
                                  //           borderRadius:
                                  //               BorderRadius.circular(
                                  //                   12),
                                  //         )),
                                  //     onPressed: () {
                                  //       Fluttertoast.showToast(
                                  //           msg:
                                  //               "Ticket Completed or Forwaded ");
                                  //     },
                                  //     child: Text(
                                  //       "Ticket Closed",
                                  //       style: TextStyle(
                                  //           fontSize: 16.sp,
                                  //           fontWeight:
                                  //               FontWeight.w600),
                                  //     ),
                                  //   ),
                                  // ),

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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12.h),
                                                  backgroundColor:
                                                      const Color(0xFFEDEDF4),
                                                  foregroundColor: Colors.black,
                                                  shape: RoundedRectangleBorder(
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
                                                AppLocalizations.of(context)!
                                                    .forwardCase,
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
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 12.h),
                                                  backgroundColor:
                                                      AppColors.primaryBlue,
                                                  foregroundColor: Colors.white,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  )),
                                              onPressed: () {
                                                buildJoinSessionFeild(
                                                  context: context,
                                                  doctorId:
                                                      ticket?.doctor?.id ?? ' ',
                                                  patientId:
                                                      ticket?.patient?.id ??
                                                          ' ',
                                                  channelName: ticket!
                                                      .meetingLink!.agora
                                                      .toString(),
                                                );
                                              },
                                              child: Text(
                                                AppLocalizations.of(context)!
                                                    .joinSession,
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
                                  height: MediaQuery.paddingOf(context).bottom +
                                      10),
                            ],
                          ),
                        ),
        ),
      ),
    );
  }
}

void _showNotesBottomSheet({
  required BuildContext context,
  required String notesString,
}) {
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
        initialChildSize: 0.93,
        minChildSize: 0.93,
        maxChildSize: 0.93,
        expand: false,
        snap: true,
        builder: (BuildContext context, ScrollController scrollController) {
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
                    "${AppLocalizations.of(context)!.prescription} ${AppLocalizations.of(context)!.notes}",
                    style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w600)),
                  ),
                ),
                SizedBox(height: 16.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(8.h),
                  ),
                  child: Text(
                    notesString,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.close,
                        style: TextStyle(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
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
                    widget.questionAnswer.answer?.join('\n') ?? '',
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
  required DateTime? meetTime,
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
                        AppLocalizations.of(context)!.addNotesForThePatient,
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
                          hintText: AppLocalizations.of(context)!
                              .shareAnythingImportantWithThePatient,
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
                                        final fileSize =
                                            result.files.first.size /
                                                (1024 * 1024); // Convert to MB

                                        if (fileSize > 5) {
                                          Fluttertoast.showToast(
                                            msg:
                                                "File size must be less than 5MB",
                                            backgroundColor: Colors.red,
                                          );
                                          return;
                                        }

                                        setState(() {
                                          selectedFile = result.files.first;
                                        });
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.attachFile,
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                      ),
                                    ),
                                  ),
                                )
                              : Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        selectedFile!.name.toString(),
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          setState(() {
                                            selectedFile = null;
                                          });
                                        },
                                        icon: const Icon(Icons.close))
                                  ],
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
                              // onPressed: () async {
                              //   // Show confirmation dialog

                              //   if (controller.text.trim().isEmpty &&
                              //       selectedFile == null) {
                              //     Fluttertoast.showToast(
                              //       msg:
                              //           "Please add a note or attach a prescription file",
                              //     );
                              //     return;
                              //   }

                              //   bool? confirm = await showDialog<bool>(
                              //     context: context,
                              //     builder: (BuildContext context) {
                              //       return AlertDialog(
                              //         title: const Text('Confirm Submission'),
                              //         content: const Text(
                              //             'Are you sure you want to submit this prescription?'),
                              //         actions: <Widget>[
                              //           TextButton(
                              //             child: const Text('Cancel'),
                              //             onPressed: () {
                              //               Navigator.of(context).pop(false);
                              //             },
                              //           ),
                              //           TextButton(
                              //             child: const Text('Submit'),
                              //             onPressed: () {
                              //               Navigator.of(context).pop(true);
                              //             },
                              //           ),
                              //         ],
                              //       );
                              //     },
                              //   );

                              //   // If user confirms, proceed with submission
                              //   if (confirm == true) {
                              //     File? fileToUpload;
                              //     String? directoryType;

                              //     if (selectedFile != null &&
                              //         selectedFile!.path != null) {
                              //       fileToUpload = File(selectedFile!.path!);
                              //       String fileType = selectedFile!.extension
                              //               ?.toLowerCase() ??
                              //           '';
                              //       directoryType = ['jpg', 'jpeg', 'png']
                              //               .contains(fileType)
                              //           ? 'image'
                              //           : 'pdf';
                              //     }

                              //     var noteText = controller.text.trim().isEmpty
                              //         ? "No note added"
                              //         : controller.text;

                              //     var r = await homeProvider.markAsComplete(
                              //       id: id,
                              //       note: noteText,
                              //       file: fileToUpload,
                              //       directoryType: directoryType,
                              //       context: context,
                              //     );

                              //     if (r.success) {
                              //       Fluttertoast.showToast(msg: r.msg);
                              //       Navigator.of(context).pop();
                              //       await refreshTicketDetails();
                              //     } else {
                              //       Fluttertoast.showToast(msg: r.msg);
                              //     }
                              //   }
                              // },
                              onPressed: () async {
                                if (controller.text.trim().isEmpty &&
                                    selectedFile == null) {
                                  Fluttertoast.showToast(
                                    msg:
                                        "Please add a note or attach a prescription file",
                                  );
                                  return;
                                }

                                bool? attendMeet = await showDialog<bool>(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!
                                          .quickReminder),
                                      content: Text(AppLocalizations.of(
                                              context)!
                                          .haveYouAttendedTheMeetingWithPatient),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!.no),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                            Navigator.of(context).pop(false);
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Please attend meeting first!");
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .yes),
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                                if (attendMeet == false) {
                                  return;
                                }

                                // Check if the current time is past the scheduled time
                                DateTime now = DateTime.now();
                                if (meetTime != null &&
                                    now.isBefore(meetTime)) {
                                  // Show dialog if the current time is before the scheduled time
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text(
                                            AppLocalizations.of(context)!
                                                .actionRestricted),
                                        content: Text(AppLocalizations.of(
                                                context)!
                                            .thisTicketCanOnlyBeMarkedAsCompleteAfterTheAttendingMeeting),
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
                                  return;
                                }

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
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .cancel),
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                        ),
                                        TextButton(
                                          child: Text(
                                              AppLocalizations.of(context)!
                                                  .submit),
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

                                  var noteText = controller.text.trim().isEmpty
                                      ? "No note added"
                                      : controller.text;

                                  var r = await homeProvider.markAsComplete(
                                    id: id,
                                    note: noteText,
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
                                AppLocalizations.of(context)!.addNote,
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

void buildJoinSessionFeild(
    {required BuildContext context,
    required String doctorId,
    required String patientId,
    required String channelName}) {
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
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.3,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                          color: const Color(0xFFFAFAFC),
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/icons/meetLink.png',
                                height: 40.h,
                                width: 40.w,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Join Meeting",
                                    style: TextStyle(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Click below to join session",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 24.h),
                          // Container(
                          //   padding: EdgeInsets.symmetric(
                          //       horizontal: 12.w, vertical: 8.h),
                          //   decoration: BoxDecoration(
                          //     border: Border.all(color: Colors.grey[300]!),
                          //     borderRadius: BorderRadius.circular(8),
                          //   ),
                          //   child: Row(
                          //     children: [
                          //       Expanded(
                          //         child: Text(
                          //           meetLink,
                          //           maxLines: 1,
                          //           overflow: TextOverflow.ellipsis,
                          //           style: TextStyle(fontSize: 14.sp),
                          //         ),
                          //       ),
                          //       IconButton(
                          //         icon: const Icon(Icons.copy, size: 20),
                          //         onPressed: () {
                          //           Clipboard.setData(
                          //               ClipboardData(text: meetLink));

                          //           Fluttertoast.showToast(
                          //               msg: "Link copied to clipboard");
                          //         },
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 16.h,
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
                        onPressed: () async {
                          // launchUrl(Uri.parse(meetLink));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MeetingScreen(
                                  doctorId: doctorId,
                                  patientId: patientId,
                                  channelName: channelName,
                                ),
                              ));
                        },
                        child: Text(
                          AppLocalizations.of(context)!.joinSession,
                          style: TextStyle(
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.paddingOf(context).bottom,
                    )
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
  // // Ensure patient and patient.age are not null before parsing
  // if (patient != null && patient.age != null) {
  //   try {
  //     print("Dob${patient.age.toString()}");
  //     // Assuming patient.age is in a proper date format. Adjust as necessary.
  //     formattedDate = DateTime.parse(patient.age.toString())
  //         .toIso8601String()
  //         .substring(0, 10);
  //   } catch (e) {
  //     print('Error parsing date: $e');
  //     formattedDate = 'Invalid date'; // Default value or handle it accordingly
  //   }
  // } else {
  //   formattedDate = 'N/A'; // Handle the case when patient or age is null
  // }

  String calculateAge(DateTime? birthDate) {
    if (birthDate == null) {
      return 'N/A'; // Handle null birthdate case
    }

    DateTime currentDate = DateTime.now();
    int years = currentDate.year - birthDate.year;
    int months = currentDate.month - birthDate.month;
    int days = currentDate.day - birthDate.day;

    // Adjust for cases where the month/day hasn’t occurred yet this year/month
    if (days < 0) {
      months -= 1;
      days += DateTime(currentDate.year, currentDate.month, 0)
          .day; // days in previous month
    }
    if (months < 0) {
      years -= 1;
      months += 12;
    }

    if (years > 0) {
      return "$years ${years == 1 ? 'year' : 'years'}";
    } else if (months > 0) {
      return "$months ${months == 1 ? 'month' : 'months'}";
    } else {
      return "$days ${days == 1 ? 'day' : 'days'}";
    }
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
                          AppLocalizations.of(context)!.patientsProfile,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(height: 10.h),
                        Text(
                          AppLocalizations.of(context)!
                              .heresAllRequiredInformationThatYouNeedInOrderToProvideMedicationToThePatient,
                          style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w400)),
                        ),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: AppLocalizations.of(context)!.patientName,
                            value: patient?.name.toString() ?? "N/A"),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            infoBox(
                                key: AppLocalizations.of(context)!.gender,
                                value: patient?.gender.toString() ?? "N/A"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(
                                key: AppLocalizations.of(context)!.bloodGroup,
                                value: patient?.bloodGroup.toString() ?? "N/A"),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          children: [
                            infoBox(
                                key: AppLocalizations.of(context)!.height,
                                value: patient?.height.toString() ?? "N/A"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(
                                key: AppLocalizations.of(context)!.weight,
                                value:
                                    "${patient?.weight.toString() ?? 'N/A '}kg"),
                            SizedBox(
                              width: 10.w,
                            ),
                            infoBox(
                                key: AppLocalizations.of(context)!.age,
                                value: calculateAge(patient?.age)),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: AppLocalizations.of(context)!.fathersName,
                            value: patient?.fatherName.toString() ?? "N/A"),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: AppLocalizations.of(context)!.grandfathersName,
                            value:
                                patient?.grandFatherName.toString() ?? "N/A"),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: AppLocalizations.of(context)!.chronicDisease,
                            value: disease),
                        SizedBox(height: 20.h),
                        infoRow(
                            key: AppLocalizations.of(context)!.address,
                            value: patient?.address.toString() ?? 'N/A'),
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
        return pickedFile;
      } else {
        return null;
      }
    } catch (e) {
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
                        buildAttachment(
                            context, comment.fileUrl.toString(), isCurrentUser),
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
          isCurrentUser ? AppColors.primaryBlue : const Color(0xFF4CAF50),
      child: Icon(
        isCurrentUser ? Icons.medical_services : Icons.person,
        color: Colors.white,
        size: 20.r,
      ),
    );
  }

  Widget buildAttachment(
      BuildContext context, String attachment, bool isCurrentUser) {
    if (!isCurrentUser) {
      return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              CupertinoDialogRoute(
                  builder: (context) =>
                      FullScreenImageView(imageUrl: attachment),
                  context: context));
        },
        child: Container(
          width: 150.w,
          height: 150.w,
          margin: EdgeInsets.only(top: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: NetworkImage(attachment),
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    } else {
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
                  var res =
                      await Provider.of<HomeProvider>(context, listen: false)
                          .downloadFile(attachment);
                  if (res.success) {
                    Fluttertoast.showToast(msg: res.msg);
                  } else {
                    Fluttertoast.showToast(msg: res.msg);
                  }
                },
                icon: const Icon(Iconsax.document_download))
          ],
        ),
      );
    }
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.white,
        title: Text(
          "Prescription Image",
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        ),
        centerTitle: false,
      ),
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: PhotoView(
          imageProvider: NetworkImage(imageUrl),
          minScale: PhotoViewComputedScale.contained,
          maxScale: PhotoViewComputedScale.covered * 2,
        ),
      ),
    );
  }
}
