import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  int selectedIndex = -1; // Initialize with -1 to indicate no selection
  List<String> languageList = ['English', 'Arabic', 'Kurdish (Sorani)'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text(
          "Change Language",
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
              height: 20.h,
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.h),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: languageList.length,
                  itemBuilder: (context, index) {
                    String data = languageList[index];
                    bool isSelected = index ==
                        selectedIndex; // Check if this item is selected
                    return Padding(
                      padding: EdgeInsets.only(bottom: 20.h),
                      child: ListTile(
                        dense: true,
                        tileColor: Colors.white,
                        contentPadding: const EdgeInsets.all(16),
                        onTap: () {
                          setState(() {
                            selectedIndex = index; // Update the selected index
                          });
                        },
                        horizontalTitleGap: 30.h,
                        leading: Container(
                          height: 24,
                          width: 24,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
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
                                color: isSelected
                                    ? AppColors.blue
                                    : Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        title: Text(
                          data,
                          style: GoogleFonts.openSans(
                            textStyle: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
    );
  }
}
