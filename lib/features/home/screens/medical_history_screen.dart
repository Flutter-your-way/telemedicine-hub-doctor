import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/common/models/medical_history_model.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';

class MedicalHistoryScreen extends StatefulWidget {
  final String userId;
  const MedicalHistoryScreen({
    super.key,
    required this.userId,
  });

  @override
  State<MedicalHistoryScreen> createState() => _MedicalHistoryScreenState();
}

class _MedicalHistoryScreenState extends State<MedicalHistoryScreen> {
  MedicalHistoryModel? medicalHistory;
  bool isLoading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    _fetchMedicalHistory();
  }

  Future<void> _fetchMedicalHistory() async {
    try {
      setState(() {
        isLoading = true;
        error = null;
      });

      final response = await Provider.of<HomeProvider>(context, listen: false)
          .getMedicalHistory(
        userID: widget.userId,
      );

      if (response.success) {
        // Debug print to check the full response structure
        print('Full response data: ${response.data}');

        // Try different approaches to extract medical history
        final historyData =
            (response.data?['medicalHistory'] as List?)?.firstOrNull ??
                response.data?['medicalHistory'] ??
                response.data;

        if (historyData != null) {
          setState(() {
            medicalHistory = MedicalHistoryModel.fromJson(historyData);
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'No medical history data found';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = response.msg ?? 'Failed to fetch medical history';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Failed to fetch medical history: $e';
        isLoading = false;
      });
      // Log the error for debugging
      print('Error fetching medical history: $e');
    }
  }

  List<MedicalHistoryItem> getMedicalHistoryItems() {
    if (medicalHistory == null) return [];

    final items = <MedicalHistoryItem>[];
    final history = medicalHistory!.medicalHistory;

    // Always add items, even if they are "no" or empty
    // Allergies Section
    items.add(MedicalHistoryItem(
      title: 'Allergies',
      answer: history.allergies.hasAllergies
          ? (history.allergies.details.isEmpty
              ? 'Yes'
              : history.allergies.details)
          : 'No',
    ));

    // Current Medication Section
    items.add(MedicalHistoryItem(
      title: 'Current Medication',
      answer: history.currentMedication.hasMedication
          ? (history.currentMedication.details.isEmpty
              ? 'Yes'
              : history.currentMedication.details)
          : 'No',
    ));

    // Add a method to translate condition status
    String translateConditionStatus(String status) {
      switch (status) {
        case 'yes-current':
          return 'Current';
        case 'yes-past':
          return 'Past';
        case 'no':
          return 'No';
        default:
          return status;
      }
    }

    // Conditions Section - Use _translateConditionStatus
    final conditions = history.conditions;
    final conditionsList = [
      {'title': 'Alcoholism', 'value': conditions.alcoholism},
      {'title': 'Asthma', 'value': conditions.asthma},
      {'title': 'Cancer', 'value': conditions.cancer},
      {'title': 'Depression/Anxiety', 'value': conditions.depressionAnxiety},
      {'title': 'Diabetes', 'value': conditions.diabetes},
      {'title': 'Emphysema', 'value': conditions.emphysema},
      {'title': 'Heart Disease', 'value': conditions.heartDisease},
      {'title': 'Hypertension', 'value': conditions.hypertension},
      {'title': 'High Cholesterol', 'value': conditions.highCholesterol},
      {'title': 'Thyroid Disease', 'value': conditions.thyroidDisease},
      {'title': 'Kidney Disease', 'value': conditions.kidneyDisease},
      {'title': 'Migraine Headaches', 'value': conditions.migraineHeadaches},
      {'title': 'Stroke', 'value': conditions.stroke},
    ];

    for (var condition in conditionsList) {
      items.add(MedicalHistoryItem(
          title: condition['title'] as String,
          answer: translateConditionStatus(condition['value'] as String)));
    }

    // Add other conditions if exist
    if (conditions.other.isNotEmpty) {
      items.add(MedicalHistoryItem(
          title: 'Other Conditions', answer: conditions.other));
    }

    // Previous Surgeries Section
    // items.add(MedicalHistoryItem(
    //     title: 'Previous Surgeries',
    //     answer: history.previousSurgeries.hasSurgeries
    //         ? (history.previousSurgeries.details.isEmpty
    //             ? 'Yes'
    //             : history.previousSurgeries.details
    //                 .map((surgery) =>
    //                     '${surgery.type}${surgery.date != null ? " (${DateFormat('MM/dd/yyyy').format(surgery.date!)})" : ""}')
    //                 .join(', '))
    //         : 'No'));

    // Women's Health Section
    items.add(MedicalHistoryItem(
        title: 'Total Births',
        answer: history.womensHealth.totalBirths.toString()));

    items.add(MedicalHistoryItem(
        title: 'Pregnancy Complications',
        answer: history.womensHealth.pregnancyComplications ? 'Yes' : 'No'));

    // Family History Section
    final familyHistory = history.familyHistory;
    final familyConditions = [
      {
        'title': 'Family History: Alcoholism',
        'value': familyHistory.alcoholism
      },
      {'title': 'Family History: Asthma', 'value': familyHistory.asthma},
      {'title': 'Family History: Cancer', 'value': familyHistory.cancer},
      {
        'title': 'Family History: Depression/Anxiety',
        'value': familyHistory.depressionAnxiety
      },
      {'title': 'Family History: Diabetes', 'value': familyHistory.diabetes},
      {'title': 'Family History: Emphysema', 'value': familyHistory.emphysema},
      {
        'title': 'Family History: Heart Disease',
        'value': familyHistory.heartDisease
      },
      {
        'title': 'Family History: Hypertension',
        'value': familyHistory.hypertension
      },
      {
        'title': 'Family History: High Cholesterol',
        'value': familyHistory.highCholesterol
      },
      {
        'title': 'Family History: Thyroid Disease',
        'value': familyHistory.thyroidDisease
      },
      {
        'title': 'Family History: Kidney Disease',
        'value': familyHistory.kidneyDisease
      },
      {
        'title': 'Family History: Migraine Headaches',
        'value': familyHistory.migraineHeadaches
      },
      {'title': 'Family History: Stroke', 'value': familyHistory.stroke},
    ];

    for (var condition in familyConditions) {
      items.add(MedicalHistoryItem(
          title: condition['title'] as String,
          answer: (condition['value'] as bool) ? 'Yes' : 'No'));
    }

    // Family History Other
    if (familyHistory.other.isNotEmpty) {
      items.add(MedicalHistoryItem(
          title: 'Family History: Other', answer: familyHistory.other));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Patient History",
          style: GoogleFonts.openSans(
            textStyle: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
          ),
        ),
        centerTitle: false,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(error!),
                      ElevatedButton(
                        onPressed: _fetchMedicalHistory,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h),
                  child: RefreshIndicator(
                    onRefresh: _fetchMedicalHistory,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: medicalHistory != null
                          ? Column(
                              children: List.generate(
                                getMedicalHistoryItems().length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.h),
                                  child: MedicalHistoryWidget(
                                    item: getMedicalHistoryItems()[index],
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 100.h,
                                    ),
                                    Text(
                                      "Not Found Patient History",
                                      style: GoogleFonts.openSans(
                                          textStyle: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 18.sp)),
                                    ),
                                    SizedBox(
                                      height: 40.h,
                                    ),
                                    SizedBox(
                                        height: 160.h,
                                        width: 160.w,
                                        child: SvgPicture.asset(
                                            AppImages.no_data)),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                ),
    );
  }
}

class MedicalHistoryItem {
  final String title;
  final String answer;

  MedicalHistoryItem({required this.title, required this.answer});
}

class MedicalHistoryWidget extends StatefulWidget {
  final MedicalHistoryItem item;

  const MedicalHistoryWidget({super.key, required this.item});

  @override
  _MedicalHistoryWidgetState createState() => _MedicalHistoryWidgetState();
}

class _MedicalHistoryWidgetState extends State<MedicalHistoryWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

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

    // Automatically start the animation when widget is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
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
                    widget.item.title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizeTransition(
              sizeFactor: _animation,
              axis: Axis.vertical,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(top: 8.h),
                padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.h),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    widget.item.answer,
                    textAlign: TextAlign.start,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                      ),
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
