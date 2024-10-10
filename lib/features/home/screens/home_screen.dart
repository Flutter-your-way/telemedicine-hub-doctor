import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:svg_flutter/svg.dart';
import 'package:telemedicine_hub_doctor/common/color/app_colors.dart';
import 'package:telemedicine_hub_doctor/common/images/app_images.dart';
import 'package:telemedicine_hub_doctor/common/models/ticket_model.dart';
import 'package:telemedicine_hub_doctor/common/shimmer/skelton_shimmer.dart';
import 'package:telemedicine_hub_doctor/common/util/loading_view.dart';
import 'package:telemedicine_hub_doctor/features/authentication/provider/auth_provider.dart';
import 'package:telemedicine_hub_doctor/features/home/provider/home_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/notification_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/screens/ticket_view_screen.dart';
import 'package:telemedicine_hub_doctor/features/home/widget/ticker_view.dart';
import 'package:telemedicine_hub_doctor/features/profile/provider/language_provider.dart';
import 'package:telemedicine_hub_doctor/gradient_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TicketModel> ticketList = [];
  int completedTickets = 0;
  int pendingTickets = 0;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        getTickets();
      },
    );
    super.initState();
  }

  Future<void> getTickets() async {
    try {
      var res = await Provider.of<HomeProvider>(context, listen: false)
          .getTickets(
              doctorId: Provider.of<AuthProvider>(context, listen: false)
                  .usermodel!
                  .id
                  .toString(),
              status: '');
      if (res.success) {
        if (mounted) {
          setState(() {
            ticketList = res.data;
            completedTickets = ticketList
                .where((ticket) => ticket.status == 'completed')
                .length;

            pendingTickets = ticketList
                .where((ticket) =>
                    ticket.status == 'pending' || ticket.status == 'draft')
                .length;
          });
        }
      } else {}
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    var homeProvider = Provider.of<HomeProvider>(context);
    return Container(
      decoration: BoxDecoration(
        gradient:
            Theme.of(context).extension<GradientTheme>()?.backgroundGradient,
      ),
      child: Scaffold(
        body: Column(
          children: [
            const HomeAppBar(),
            Expanded(
              child: RefreshIndicator(
                onRefresh: getTickets,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            _buildTopViewCards(completedTickets.toString(),
                                AppLocalizations.of(context)!.resolvedTickets,
                                () {
                              Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                    builder: (context) => TicketViewScreen(
                                      title: 'Complete Ticket',
                                    ),
                                    context: context,
                                  ));
                            }, context),
                            SizedBox(
                              width: 16.h,
                            ),
                            _buildTopViewCards(pendingTickets.toString(),
                                AppLocalizations.of(context)!.resolvedTickets,
                                () {
                              Navigator.push(
                                  context,
                                  CupertinoDialogRoute(
                                    builder: (context) => TicketViewScreen(
                                      title: 'Pending Ticket',
                                    ),
                                    context: context,
                                  ));
                            }, context),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Row(
                          children: [
                            Text(AppLocalizations.of(context)!.ticket,
                                style: GoogleFonts.notoSans(
                                  textStyle: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                            const Spacer(),
                            CupertinoButton(
                              child: Text(AppLocalizations.of(context)!.viewAll,
                                  style: GoogleFonts.openSans(
                                    textStyle: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: homeProvider.isLoading
                            ? TicketShimmer()
                            : ticketList.isEmpty
                                ? noDataView(context)
                                : ListView.builder(
                                    padding: EdgeInsets.zero,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: ticketList.length,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      var data = ticketList[index];
                                      return TicketCard(ticket: data);
                                    },
                                  ),
                      ),
                    ],
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

Widget noDataView(BuildContext context) {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 100.h,
        ),
        Text(
          AppLocalizations.of(context)!.noTicketFound,
          style: GoogleFonts.openSans(
              textStyle:
                  TextStyle(fontWeight: FontWeight.w400, fontSize: 18.sp)),
        ),
        SizedBox(
          height: 40.h,
        ),
        SizedBox(
            height: 160.h,
            width: 160.w,
            child: SvgPicture.asset(AppImages.no_data)),
      ],
    ),
  );
}

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    String getGreeting() {
      final hour = DateTime.now().hour;
      if (hour < 12) {
        return 'Good Morning';
      } else if (hour < 17) {
        return 'Good Afternoon';
      } else {
        return 'Good Evening';
      }
    }

    var authProvider = Provider.of<AuthProvider>(context);
    var selectedLanguage =
        Provider.of<LanguageProvider>(context, listen: false).selectedLanguage;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: MediaQuery.paddingOf(context).top + 8.h),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    getGreeting(),
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.captionColor,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                      selectedLanguage == "english"
                          ? authProvider.usermodel?.nameEnglish.toString() ?? ''
                          : selectedLanguage == "arabic"
                              ? authProvider.usermodel?.nameArabic.toString() ??
                                  ''
                              : selectedLanguage == "kurdish"
                                  ? authProvider.usermodel?.nameKurdish
                                          .toString() ??
                                      ''
                                  : "N/A",
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                      )),
                ],
              ),
              const Spacer(),
              GestureDetector(
                onTap: () async {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => const NotificationScreen()));
                },
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primaryBlue,
                      )),
                  child: const Icon(
                    Iconsax.notification_1,
                    size: 24,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}

Widget _buildTopViewCards(String value, String name,
    final VoidCallback onPressed, BuildContext context) {
  return Expanded(
      child: Container(
    decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200, width: 1),
        borderRadius: BorderRadius.circular(12.h),
        color: Colors.white),
    child: Padding(
      padding: EdgeInsets.all(16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold))),
          Text(name,
              style: GoogleFonts.openSans(
                  textStyle:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400))),
          SizedBox(height: 16.h),
          CupertinoButton(
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              borderRadius: BorderRadius.circular(12.h),
              padding: EdgeInsets.symmetric(horizontal: 35.h),
              onPressed: onPressed,
              child: Text(AppLocalizations.of(context)!.viewAll,
                  style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600)))),
          // Container(
          //   height: 32.h,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(8.h),
          //       color: Colors.grey.shade300),
          //   child: const Row(
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [Text("View")],
          //   ),
          // ),
        ],
      ),
    ),
  ));
}
