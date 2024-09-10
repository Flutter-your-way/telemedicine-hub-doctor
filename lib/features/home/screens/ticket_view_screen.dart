// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';

import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';

class TicketViewScreen extends StatefulWidget {
  String title;
  TicketViewScreen({
    super.key,
    required this.title,
  });

  @override
  State<TicketViewScreen> createState() => _TicketViewScreenState();
}

class _TicketViewScreenState extends State<TicketViewScreen> {
  List<String> sortList = [
    'Vaginal Yeast Infection',
    'UTI',
    'Stomach Issues',
    'Heart Burns',
    'Cold Sore',
    'Canker Sore',
    'COVID-19',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          widget.title,
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600)),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: SearchField(
              sortList: sortList,
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              children: [
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
          ))
        ],
      ),
    );
  }
}

class SearchField extends StatelessWidget {
  List<String> sortList;
  SearchField({
    super.key,
    required this.sortList,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(horizontal: 25.h, vertical: 15.w),
        hintText: "Search for tickets",
        prefixIcon: const Icon(Iconsax.search_normal),
        hintStyle: TextStyle(
          color: AppColors.captionColor,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: IconButton(
            onPressed: () {
              showSortBottomSheet(context, sortList);
            },
            icon: const Icon(Icons.filter_list_rounded)),
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
    );
  }
}

void showSortBottomSheet(BuildContext context, List<String> sortList) {
  List<String> selectedList = [];
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
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF79747E),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.h),
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          controller: scrollController,
                          itemCount: sortList.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              onTap: () {
                                setState(() {
                                  selectedList.contains(sortList[index])
                                      ? selectedList.remove(sortList[index])
                                      : selectedList.add(sortList[index]);
                                });
                              },
                              horizontalTitleGap: 24.h,
                              leading: Container(
                                height: 24,
                                width: 24,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color:
                                        selectedList.contains(sortList[index])
                                            ? AppColors.blue
                                            : const Color(0xFFD9D9D9),
                                    width: 2,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color:
                                          selectedList.contains(sortList[index])
                                              ? AppColors.blue
                                              : Colors.transparent,
                                    ),
                                  ),
                                ),
                              ),
                              title: Text(
                                sortList[index],
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          // Handle sort action
                          Navigator.pop(context);
                        },
                        child: const Text(
                          "Sort",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.paddingOf(context).bottom - 10,
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
