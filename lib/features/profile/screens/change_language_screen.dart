import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/language_provider.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class ChangeLanguageScreen extends StatefulWidget {
  const ChangeLanguageScreen({super.key});

  @override
  State<ChangeLanguageScreen> createState() => _ChangeLanguageScreenState();
}

class _ChangeLanguageScreenState extends State<ChangeLanguageScreen> {
  int selectedIndex = -1; // Initialize with -1 to indicate no selection
  List<String> languageList = ['English', 'Arabic', 'Kurdish (Sorani)'];
  List<String> languageCodes = ['en', 'ar', 'ku'];

  @override
  void initState() {
    super.initState();
    // Call the loadLanguagePreference method when initializing
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final languageProvider =
          Provider.of<LanguageProvider>(context, listen: false);
      await languageProvider
          .loadLanguagePreference(); // Load the preferred language
      setState(() {
        selectedIndex =
            languageCodes.indexOf(languageProvider.locale.languageCode);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final languageProvider =
        Provider.of<LanguageProvider>(context, listen: false);
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Text(
            AppLocalizations.of(context)!.changeLanguage,
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
                              selectedIndex =
                                  index; // Update the selected index
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
                    if (selectedIndex != -1) {
                      await languageProvider
                          .setLocale(languageCodes[selectedIndex]);
                      if (mounted) {
                        Navigator.of(context)
                            .pop(); // Close the language selection screen
                      }
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.save,
                    style: TextStyle(
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.paddingOf(context).bottom + 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
